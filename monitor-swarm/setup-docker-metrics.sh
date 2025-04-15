sudo apt update
sudo apt install sshpass -y

tạo file bash: sudo nano setup-docker-metrics.sh
#!/bin/bash

START=10
END=19
USER="osboxes"                          # 👈 Tên user SSH trên các node
PASSWORD="osboxes.org"                 # 👈 Mật khẩu SSH (và sudo nếu giống)

for i in $(seq $START $END); do
  IP="192.168.19.$i"
  echo "👉 Đang cấu hình node $IP..."

  sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no "$USER@$IP" bash -s <<EOF
echo '$PASSWORD' | sudo -S bash -c '
cat > /etc/docker/daemon.json <<EOL
{
  "metrics-addr": "0.0.0.0:9323",
  "experimental": true,
  "dns": ["8.8.8.8", "8.8.4.4", "127.0.0.11"]
}
EOL
'

echo '$PASSWORD' | sudo -S systemctl restart docker

echo "\n✅ Node $IP đã xong rồi đó brooooo!"
EOF

done

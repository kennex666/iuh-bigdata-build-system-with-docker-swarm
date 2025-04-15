#!/bin/bash

# chmod +x cleanup-docker.sh


START=10
END=19
USER="osboxes"                            # 👈 Tên user SSH trên các node
PASSWORD="osboxes.org"                   # 👈 Mật khẩu SSH (và sudo nếu giống)

for i in $(seq $START $END); do
  IP="192.168.19.$i"
  echo "🧹 Đang dọn dẹp node $IP..."

  sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no "$USER@$IP" bash -s <<EOF
echo '$PASSWORD' | sudo -S bash -c '
  echo "⏳ Đang dọn container dừng..."
  docker container prune -f

  echo "⏳ Đang dọn image không dùng..."
  docker image prune -a -f

  echo "⏳ Đang dọn volume rác..."
  docker volume prune -f

  echo "⏳ Dọn network mồ côi..."
  docker network prune -f

  echo "✅ DONE! Node $IP đã dọn dẹp Docker xong rồi nhó!!"
'
EOF

done

#!/bin/bash

# chmod +x delete-monitoring-volumes.sh

START=10
END=19
USER="osboxes"                          # 👈 SSH user trên node
PASSWORD="osboxes.org"                 # 👈 SSH + sudo password

for i in $(seq $START $END); do
  IP="192.168.19.$i"
  echo "🧹 Đang xóa các volume bắt đầu bằng 'monitoring_' trên node $IP..."

  sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no "$USER@$IP" bash -s <<EOF
echo '$PASSWORD' | sudo -S bash -c '
  for vol in \$(docker volume ls --format "{{.Name}}" | grep "^monitoring_"); do
    echo "🗑️ Xoá volume: \$vol"
    docker volume rm "\$vol" && echo "✅ Đã xóa \$vol" || echo "❌ Không thể xoá \$vol (có thể đang được dùng)"
  done
  echo "✅ Hoàn tất trên node $IP"
'
EOF

done

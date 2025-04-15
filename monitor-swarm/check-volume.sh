#!/bin/bash

# chmod +x check-volumes.sh

START=10
END=19
USER="osboxes"                          # 👈 Sửa đúng SSH user
PASSWORD="osboxes.org"                 # 👈 SSH & sudo password

for i in $(seq $START $END); do
  IP="192.168.19.$i"
  echo "🔍 Đang kiểm tra volumes trên node $IP..."

  sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no "$USER@$IP" bash -s <<EOF
echo '$PASSWORD' | sudo -S bash -c '
  echo "📦 Danh sách volumes trên $IP:"
  docker volume ls
  echo "🔢 Số lượng volumes: \$(docker volume ls -q | wc -l)"
  echo "----------------------------"
'
EOF

done

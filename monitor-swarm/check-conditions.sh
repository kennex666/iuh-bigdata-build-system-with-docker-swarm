#!/bin/bash

# chmod +x check-docker-swarm.sh
# ./check-docker-swarm.sh

START=10
END=19
USER="osboxes"
PASSWORD="osboxes.org"

echo "🚀 Bắt đầu kiểm tra Docker Swarm từ 192.168.19.$START đến .$END..."
echo ""

for i in $(seq $START $END); do
  IP="192.168.19.$i"
  echo "🧪 Đang kiểm tra node $IP..."

  sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no "$USER@$IP" bash -s <<EOF
echo '$PASSWORD' | sudo -S bash -c '
  echo "🔧 Kiểm tra Docker daemon..."
  systemctl is-active --quiet docker && echo "✅ Docker daemon đang chạy" || echo "❌ Docker daemon KHÔNG chạy"

  echo "🧩 Kiểm tra docker.sock..."
  [ -S /var/run/docker.sock ] && echo "✅ Có docker.sock" || echo "❌ KHÔNG có docker.sock"

  echo "📦 Kiểm tra volume lỗi..."
  docker volume ls >/dev/null 2>&1 && echo "✅ Volume hoạt động ổn" || echo "⚠️  Lỗi khi gọi docker volume"

  echo "--------------------------------------------------"
'
EOF

done

echo ""
echo "✅ Kiểm tra hoàn tất! Kiểm tra lỗi thủ công nếu có ❌ hoặc ⚠️ hiện ra."

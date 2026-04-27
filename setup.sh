#!/bin/bash

echo "Memulai Setup Environment..."

# 1. Install MariaDB Client (untuk mysqldump)
echo "Menginstal MariaDB Client..."
sudo dnf install mariadb105 -y

# 2. Install NVM
echo "Mendownload dan menginstal NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# 3. Install Node.js (Versi 18 LTS)
echo "Menginstal Node.js versi 18..."
nvm install 18
nvm use 18

# 4. Install Dependencies Aplikasi
echo "Menginstal dependencies aplikasi..."
npm install

# 5. Install PM2 secara Global
echo "Menginstal PM2..."
npm install -g pm2

echo "========================================="
echo "Setup selesai! Jangan lupa jalankan: source ~/.bashrc"
echo "========================================="
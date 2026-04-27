# LKS Cloud Computing – Module 2 (Application Deployment & Data Services)

## 🎯 Objective
Deploy Node.js application with:
- RDS Aurora MySQL (Multi-AZ)
- S3 Backup Integration
- Auto-provisioning script

---

## 🧠 Architecture
![Infra](/public/uploads/modul2.png)

---

## ⚡ Setup Steps

### 1. Create DB Subnet Group (Crucial for Aurora)
- Name: `sg-rds-lks-jp2`
- VPC: `vpc-lks-jp2`
- Subnets: Include `cloud-private-1` (AZ-a) & `cloud-private-2` (AZ-b)

### 2. Create RDS (Aurora MySQL)
- Engine: **Aurora MySQL 5.7**
- Template: **Production**
- Instance Class: **db.t3.small**
- Multi-AZ Deployment: **Yes** (Create Aurora Replica)
- Subnet Group: `sg-rds-lks-jp2`
- Public access: **NO**
- Security Group: `db-sg`
- Initial Database Name: `rentalmobil`
- Enhanced Monitoring: **OFF**

### 3. Create S3 Bucket
- Unique name: `lks-jp2-backup-[your-name]`
- Region: Same as VPC
- Block Public Access: **Enabled** (Default)

---

### 4. Setup Application

SSH into your `ec2-web` instance, then run:

```bash
# Clone the repository
git clone [https://github.com/Deri-Nugroho/modul2-rentalmobil](https://github.com/Deri-Nugroho/modul2-rentalmobil)
cd modul2-rentalmobil

# Run the setup script (installs MariaDB Client, Node.js, and PM2)
bash setup.sh

# IMPORTANT: Reload bash configuration to use Node.js and PM2
source ~/.bashrc
```

### 5. Configure Environment
Create the .env file:

```Bash
sudo nano .env
```
Paste and adjust the following values:

```Bash
DB_HOST=<RDS-WRITER-ENDPOINT>
DB_USER=admin
DB_PASSWORD=LKS2026!
DB_NAME=rentalmobil

AWS_REGION=us-east-1
AWS_BUCKET_NAME=lks-jp2-backup-[your-name]
```
### 6. Initialize Database
Populate the database with dummy data and tables:

```Bash
npm run init-db
```

### 7. Run Application
Start the application using PM2 to ensure process persistence:

```Bash
pm2 start app.js --name lks-app
pm2 save
pm2 startup
```

## 🌐 Nginx Reverse Proxy Setup (IMPORTANT)

To allow access without specifying port 3000, configure Nginx as reverse proxy.

Edit Nginx config:

```bash
sudo nano /etc/nginx/nginx.conf
```

Modify inside server {} block:

```bash
        include /etc/nginx/default.d/*.conf;

        location / {
                proxy_pass http://localhost:3000;
                proxy_http_version 1.1;

                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection 'upgrade';
                proxy_set_header Host $host;

                proxy_cache_bypass $http_upgrade;
        }
```

Restart Nginx:
```bash
sudo systemctl restart nginx
```
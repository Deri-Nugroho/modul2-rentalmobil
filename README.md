# LKS Cloud Computing – Module 2 (Deployment)

## 🎯 Objective
Deploy Node.js application with:
- RDS Aurora MySQL
- S3 Backup Integration

---

## 🧠 Architecture
![Infra](/public/uploads/modul2.png)

---
## ⚡ Setup Steps

### 1. Create RDS (Aurora MySQL)

- Private subnet
- Public access: NO
- SG: sg-db

---

### 2. Create S3 Bucket

- Unique name (e.g. lks-jp2-deri)
- Same region

---

### 3. Connect EC2 to DB

Install client:
```bash
sudo dnf install mariadb105 -y
```

### 4. Setup Application
```bash
git clone https://github.com/Deri-Nugroho/modul2-rentalmobil
cd rentalmobil

bash setup.sh
```

### 5. Configure Environment

Create .env:
```bash
DB_HOST=<RDS-ENDPOINT>
DB_USER=admin
DB_PASSWORD=yourpassword
DB_NAME=rentalmobil

AWS_REGION=us-east-1
AWS_BUCKET_NAME=lks-jp2-deri
```

### 6. Initialize Database
```bash
npm run init-db
```

### 7. Run Application
```bash
pm2 start app.js --name lks-app
pm2 save
pm2 startup
```

### 8. Test Application

Open browser:
```bash
http://<EC2-PUBLIC-IP>
```
Application should be accessible without port.

### 9. Test Backup
```bash
http://<EC2-PUBLIC-IP>/backup
```

> Note:
> Application runs on port 3000 internally, but exposed via Nginx (port 80).

## 🔄 Process Persistence

Ensure application auto-start on reboot:

```bash
pm2 save
pm2 startup
```
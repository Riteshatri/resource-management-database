# 🗄️ Azure SQL Database Setup Guide

This folder contains all SQL scripts required to set up the Azure SQL Database for the Resource Management Dashboard.

---

## 📋 Files in This Folder

| File | Purpose |
|------|---------|
| `01_create_tables.sql` | Creates all database tables |
| `02_insert_default_data.sql` | Inserts default theme configuration |
| `03_create_admin_user.sql` | Creates default admin user |
| `04_sample_resources.sql` | Inserts sample resources (optional) |
| `backup_and_restore.sql` | Backup and restore commands |

---

## 🚀 Quick Setup (Step-by-Step)

### Step 1: Create Azure SQL Database

1. **Login to Azure Portal:** https://portal.azure.com
2. Search for **"SQL databases"**
3. Click **"+ Create"**
4. Fill in details:
   - **Resource Group:** Create new or select existing
   - **Database Name:** `resource-dashboard-db` (**CHANGE ACCORDINGLY**)
   - **Server:** Create new
     - **Server name:** `your-unique-server-name` (**CHANGE ACCORDINGLY**)
     - **Location:** Southeast Asia (or your preferred region)
     - **Authentication:** SQL authentication
     - **Admin login:** `dbadmin` (**CHANGE ACCORDINGLY**)
     - **Password:** Strong password (**CHANGE ACCORDINGLY** and SAVE IT!)
   - **Compute + Storage:** Basic or Standard tier
5. **Networking:**
   - ✅ Allow Azure services
   - ✅ Add current client IP
6. Click **"Review + Create"** > **"Create"**

⏱ **Wait:** 5-10 minutes for deployment

---

### Step 2: Get Connection String

1. Go to your database resource
2. Click **"Connection strings"** (left menu)
3. Copy the **ADO.NET** connection string
4. Note it down - you'll need it for `.env` configuration

**Format for PyMSSQL (Backend .env):**
```
mssql+pymssql://USERNAME:PASSWORD@SERVER_NAME.database.windows.net:1433/DATABASE_NAME
```

**Example (CHANGE ACCORDINGLY):**
```
mssql+pymssql://dbadmin:MySecure@Pass123@resource-server.database.windows.net:1433/resource-dashboard-db
```

---

### Step 3: Run SQL Scripts

#### Option A: Using Azure Portal Query Editor (Easiest)

1. Go to your database in Azure Portal
2. Click **"Query editor"** (left menu)
3. Login with:
   - **Authentication type:** SQL authentication
   - **Login:** `dbadmin` (or your admin username)
   - **Password:** Your database password  
   ***PLEASE NOTE THAT, IN YOUR **SQL** SERVER FIREWALL,  CLIENT IP AND BACKEND IP SHOULD BE ALLOWED,***  
    ***FOR PRACTISE PURPOSE ONLY***
4. Run scripts in order:
   - Copy content of `01_create_tables.sql` → Paste → Click **"Run"**
   - Copy content of `02_insert_default_data.sql` → Paste → Click **"Run"**
   - Copy content of `03_create_admin_user.sql` → Paste → Click **"Run"**
   - (Optional) Copy content of `04_sample_resources.sql` → Paste → Click **"Run"**

✅ **Done!** Database is ready.

#### Option B: Using SQL Server Management Studio (SSMS)

1. Download SSMS: https://aka.ms/ssmsfullsetup
2. Connect to Azure SQL:
   - **Server name:** `your-server.database.windows.net`
   - **Authentication:** SQL Server Authentication
   - **Login:** Your admin username
   - **Password:** Your admin password
3. Open each `.sql` file and execute in order

#### Option C: Using Python Script (From Backend)

```bash
# Make sure backend .env is configured with DATABASE_URL
cd backend
source venv/bin/activate  # or venv\Scripts\activate on Windows

# Run migration
python -c "from app.db.database import engine; from app.models.user import Base; Base.metadata.create_all(engine)"
```

---

### Step 4: Verify Tables

Run this query in Query Editor:

```sql
-- Check all tables
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE';
```

**Expected Output:**
- `users`
- `theme_config`
- `resources`

---

## 🔐 Default Admin User

After running `03_create_admin_user.sql`, you'll have:

- **Email:** `admin@example.com` (**CHANGE ACCORDINGLY** in the SQL file)
- **Password:** `Admin@123` (**CHANGE ACCORDINGLY** in the SQL file)
- **Role:** admin
- **Protected:** Yes (cannot be deleted)

⚠️ **IMPORTANT:** Change these credentials in production!

---

## 🔄 Backup and Restore

### Backup Database

**Azure Portal:**
1. Go to SQL database
2. Click **"Export"**
3. Choose storage account
4. Enter admin credentials
5. Click **"OK"**

**Automated Backups:**
Azure SQL automatically backs up databases. You can restore to any point in last 7-35 days.

### Restore Database

1. Go to SQL database
2. Click **"Restore"**
3. Select restore point
4. Enter new database name
5. Click **"OK"**

---

## 🔍 Troubleshooting

### Cannot connect to database

**Check:**
- ✅ Firewall rules include your IP
- ✅ Connection string is correct
- ✅ Username/password are correct
- ✅ Server name has `.database.windows.net`

**Add IP to Firewall:**
1. SQL Database > Networking
2. Add your current IP address
3. Save

### Query timeout

**Solution:**
- Increase connection timeout in connection string
- Check database tier (Basic might be slow)
- Upgrade to Standard tier

### Permission denied

**Check:**
- Using admin credentials?
- User has proper permissions?

---

## 📊 Database Schema

### Users Table
- Stores user accounts
- Includes authentication info
- Role-based access control

### Resources Table
- Infrastructure resources
- Performance metrics
- User ownership

### Theme Config Table
- User theme preferences
- Color schemes
- Dark/light mode settings

---

## 🔗 Connection String Examples

**Development (Local):**
```env
DATABASE_URL=sqlite:///./resource_dashboard.db
```

**Production (Azure SQL):**
```env
# CHANGE ACCORDINGLY with your actual credentials
DATABASE_URL=mssql+pymssql://dbadmin:YourPassword@your-server.database.windows.net:1433/resource-dashboard-db
```

<details>
<summary style="background: #1f2937; color: #ff57c4ff; padding: 15px; border-radius: 8px; cursor: pointer; font-weight: bold; margin: 10px 0; border-left: 4px solid #ff57c4ff;">💡 Architecture Benefits</summary>

## ✅ All About Our Complete Project 


1. **Frontend** - React + Vite (Static build ready)
2. **Backend** - Python FastAPI with JWT authentication
3. **Database** - Azure SQL Database

## 📁 Project Structure

```
project/
├── backend/                    # Python FastAPI Backend
│   ├── app/
│   │   ├── api/               # API endpoints (auth, users, theme)
│   │   ├── core/              # Config & security
│   │   ├── db/                # Database setup
│   │   ├── models/            # SQLAlchemy models
│   │   ├── schemas/           # Pydantic schemas
│   │   └── main.py           # FastAPI application
│   ├── requirements.txt       # Python dependencies
│   ├── azure_sql_schema.sql  # Database schema
│   └── README.md             # Backend documentation
│
├── client/                    # React Frontend
│   ├── src/
│   │   ├── components/       # UI components
│   │   ├── pages/           # Page components
│   │   ├── contexts/        # Auth context (updated for Python backend)
│   │   ├── config/          # API configuration
│   │   └── lib/             # API client (updated)
│   └── .env.example         # Frontend env vars
│
└── DEPLOYMENT_GUIDE.md      # Complete deployment instructions

```
</details>
<details>
<summary style="background: #1f2937; color: #8b5cf6; padding: 15px; border-radius: 8px; cursor: pointer; font-weight: bold; margin: 10px 0; border-left: 4px solid #8b5cf6;">🔧 What Included</summary>

### Backend
- ✅ **Python FastAPI** framework instead of Node.js
- ✅ **Azure SQL Database** instead of Supabase Postgres
- ✅ **JWT Authentication** with python-jose
- ✅ **SQLAlchemy ORM** for database operations
- ✅ **Pydantic** for request/response validation

### Frontend  
- ✅ **Auth Context** to use Python backend API
- ✅ **API Client** to call FastAPI endpoints
- ✅ **API Configuration** for backend URL

### Database
- ✅ **Azure SQL Schema** created
- ✅ **Users table** with email, password, roles
- ✅ **Theme config table** for customization
- ✅ **Default theme values** inserted

</details>  

<details>
<summary style="background: #1f2937; color: #ff0080ff; padding: 15px; border-radius: 8px; cursor: pointer; font-weight: bold; margin: 10px 0; border-left: 4px solid #ff0080ff;">🚀 OUR MAIN IMPORTANT STEPS</summary>
 
### 1. Setup Azure SQL Database
```bash
# Azure Portal mein:
1. Create SQL Database
2. Note: server name, database name, username, password
3. Run: backend/azure_sql_schema.sql
4. Configure firewall rules for VM IPs
```

### 2. Deploy Backend (VM 2)
```bash
# Backend VM mein:
cd backend
pip install -r requirements.txt

# .env file configure karo:
AZURE_SQL_SERVER=your-server.database.windows.net
AZURE_SQL_DATABASE=your-database
AZURE_SQL_USERNAME=your-username
AZURE_SQL_PASSWORD=your-password
SECRET_KEY=your-secret-key

# Run backend:
python run.py
# Production: uvicorn app.main:app --host 0.0.0.0 --port 8000
```

### 3. Deploy Frontend (VM 1)
```bash
# Frontend VM mein:
cd client

# Update API URL in .env:
VITE_API_URL=http://backend-vm-ip:8000

# Build frontend:
npm install
npm run build

# Deploy to nginx:
sudo cp -r dist/public/* /var/www/html/
```
</details>

<details>
<summary style="background: #1f2937; color: #ddff00ff; padding: 15px; border-radius: 8px; cursor: pointer; font-weight: bold; margin: 10px 0; border-left: 4px solid #ddff00ff;">🔐 Security Notes</summary>

1. **Environment Variables**:
   - Backend: Use `.env` file (see `backend/.env.example`)
   - Frontend: Use `client/.env` (see `client/.env.example`)

2. **Production Checklist**:
   - [ ] Change SECRET_KEY to random secure value
   - [ ] Enable HTTPS with SSL certificates
   - [ ] Configure Azure SQL firewall rules
   - [ ] Set up Azure Key Vault for secrets
   - [ ] Enable CORS only for your frontend domain
   - [ ] Use strong passwords for database

</details>

<details>
<summary style="background: #1f2937; color: #00ff66ff; padding: 15px; border-radius: 8px; cursor: pointer; font-weight: bold; margin: 10px 0; border-left: 4px solid #00ff66ff;">📋 Features Implemented</summary>


### Authentication
- ✅ User signup with email/password
- ✅ User login with JWT tokens
- ✅ Role-based access control (admin/user)
- ✅ Protected routes

### User Management
- ✅ Get current user profile
- ✅ Update user profile (name, bio, avatar)
- ✅ Admin: View all users
- ✅ Admin: View user by ID

### Theme Configuration
- ✅ Get theme configuration
- ✅ Admin: Update theme colors
- ✅ Default theme values
</details>

<details>
<summary style="background: #1f2937; color: #ff0000ff; padding: 15px; border-radius: 8px; cursor: pointer; font-weight: bold; margin: 10px 0; border-left: 4px solid #ff0000ff;">🧪 Testing</summary>


### Test Backend API
```bash
# Health check
curl http://localhost:8000/health

# Get theme config (public)
curl http://localhost:8000/api/theme

# Signup
curl -X POST http://localhost:8000/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'

# Login
curl -X POST http://localhost:8000/api/auth/login \
  -d "email=test@example.com&password=password123"
```

### Test Frontend
```bash
# Local development:
npm run dev
# Open: http://localhost:5000

# Production build:
npm run build
# Serve dist/public/ with nginx
```
</details>

<details>
<summary style="background: #1f2937; color: #8b5cf6; padding: 15px; border-radius: 8px; cursor: pointer; font-weight: bold; margin: 10px 0; border-left: 4px solid #8b5cf6;">💡 Architecture Benefits</summary>

### After (3-Tier Azure)
- ✅ Complete control over all layers
- ✅ Python backend (widely used in enterprise)
- ✅ Azure SQL Database (enterprise-grade)
- ✅ Scalable VM-based deployment
- ✅ Easy to demonstrate to clients
- ✅ Each tier independently deployable  

</details>


<details>
<summary style="background: #1f2937; color: #51f289ff; padding: 15px; border-radius: 8px; cursor: pointer; font-weight: bold; margin: 10px 0; border-left: 4px solid #51f289ff;">🎯 Key Endpoints</summary>


### Backend API (Port 8000)
- `POST /api/auth/signup` - Register new user
- `POST /api/auth/login` - Login user (returns JWT)
- `GET /api/users/me` - Get current user (requires auth)
- `PATCH /api/users/me` - Update profile (requires auth)
- `GET /api/users/` - Get all users (admin only)
- `GET /api/theme/` - Get theme config (public)
- `PATCH /api/theme/{key}` - Update theme (admin only)

### Frontend (Port 80/443)
- `/auth` - Login/Signup page
- `/` - Dashboard (protected)
- `/profile` - User profile (protected)
- `/settings` - Settings (protected)
- `/theme-settings` - Theme config (admin only)
- `/user-management` - User management (admin only)

</details>

<details>
<summary style="background: #1f2937; color: #006312ff; padding: 15px; border-radius: 8px; cursor: pointer; font-weight: bold; margin: 10px 0; border-left: 4px solid #006312ff;">🎉 Summary</summary>

Our Project is now **production-ready 3-tier architecture** :

- ✅ **Frontend**: Static React build (nginx se serve hoga)
- ✅ **Backend**: Python FastAPI (systemd service se chalega)
- ✅ **Database**: Azure SQL (managed service)

All documentation and scripts are ready. now onlt step left to set environment variables and then do deploy!

**Happy Deploying! 🚀**

---

</details>

<details>
<summary style="background: #1f2937; color: #826c62ff; padding: 15px; border-radius: 8px; cursor: pointer; font-weight: bold; margin: 10px 0; border-left: 4px solid #826c62ff;">✅ Final Checklist</summary>

- [ ] Azure SQL Database created
- [ ] Connection string copied
- [ ] All SQL scripts executed successfully
- [ ] Tables verified in Query Editor
- [ ] Default admin user created
- [ ] Backend `.env` updated with DATABASE_URL
- [ ] Firewall rules configured
- [ ] Test connection from backend

---
</details>


# Resource Management Dashboard - 3-Tier Azure Architecture

## Overview
Resource management dashboard converted to 3-tier architecture for Azure deployment with Python FastAPI backend and Azure SQL Database. No more Supabase/PostgreSQL - pure Azure Stack!

## Architecture
```
Frontend (React/Vite)  →  Backend (FastAPI/Python)  →  Azure SQL Database
Static HTML/CSS/JS        REST API (port 8000)         (ritserver.database.windows.net)
```

## Project Structure
```
/
├── client/                    # Frontend - React 18 + Vite + TypeScript
│   ├── src/
│   │   ├── components/       # Shadcn UI components
│   │   ├── pages/            # Page components
│   │   ├── contexts/         # React contexts (Auth, etc)
│   │   ├── hooks/            # Custom hooks
│   │   ├── lib/              # API client, utilities
│   │   └── integrations/     # Third-party integrations
│   ├── public/               # Static assets
│   └── vite.config.ts        # Vite configuration
│
├── backend/                  # Backend - Python FastAPI
│   ├── app/
│   │   ├── main.py          # FastAPI app + routes
│   │   ├── core/
│   │   │   └── config.py    # Settings (Azure SQL credentials)
│   │   ├── api/
│   │   │   ├── auth.py      # Authentication endpoints
│   │   │   ├── users.py     # User management
│   │   │   └── theme.py     # Theme configuration
│   │   ├── db/
│   │   │   ├── database.py  # SQLAlchemy setup
│   │   │   └── models.py    # Database models
│   │   └── utils/
│   │       └── jwt.py       # JWT utilities
│   ├── requirements.txt      # Python dependencies
│   ├── run.py               # Development server entry
│   └── .env                 # Azure SQL credentials
│
└── docs/                     # Deployment guides
    ├── DEPLOYMENT_GUIDE.md   # Step-by-step Azure deployment
    └── MIGRATION_SUMMARY.md  # Lovable → Azure migration details
```
<details>
<summary style="background: #1f2937; color: #21a52eff; padding: 15px; border-radius: 8px; cursor: pointer; font-weight: bold; margin: 10px 0; border-left: 4px solid #21a52eff;">💡 Architecture Benefits</summary>

## ✅ Completion Status

### Frontend
- ✅ React 18 + TypeScript + Vite
- ✅ Removed Supabase dependencies
- ✅ Updated API client to call Python backend
- ✅ Auth context updated for JWT
- ✅ Ready to build and deploy

### Backend (Python FastAPI)
- ✅ **LIVE on localhost:8000**
- ✅ Connected to Azure SQL Database (ritserver)
- ✅ JWT Authentication implemented
- ✅ User management endpoints
- ✅ Theme configuration endpoints
- ✅ Auto-creates database tables on startup
- ✅ CORS configured for frontend

### Database
- ✅ Azure SQL Database created (ritserver.database.windows.net)
- ✅ Schema auto-generated by SQLAlchemy
- ✅ Tables: users, user_profiles, user_roles, theme_configurations

## 🧪 Testing Endpoints

```bash
# Health check
curl http://localhost:8000/health
# Response: {"status":"healthy"}

# Root endpoint
curl http://localhost:8000/
# Response: {"message":"Resource Management API is running"}

# API docs (interactive)
http://localhost:8000/docs
```

## 🚀 Running Locally

### Backend (Python)
```bash
cd backend
python -m venv venv
venv\Scripts\activate  # Windows
pip install -r requirements.txt
python run.py
# Server runs on http://localhost:8000
```

### Frontend (React)
```bash
npm install
npm run dev
# Server runs on http://localhost:5000
```

## 📊 Tech Stack
**Frontend:**
- React 18, TypeScript, Vite
- Shadcn UI, Tailwind CSS
- React Router, React Query
- Axios for API calls

**Backend:**
- Python 3.11
- FastAPI + Uvicorn
- SQLAlchemy ORM
- PyMSSQL (Azure SQL driver)

**Database:**
- Azure SQL Database
- Auto-migrations via SQLAlchemy

## 🔐 Credentials (Local Testing)
```
Server: YOUR_server_NAME.database.windows.net
Database: YOUR_DB_NAME
Username: SERVER_NAME@DB_NAME
Password: YUOR_PASSWORD
```

## 📝 Next Steps for Production

1. **Deploy Backend to Azure VM:**
   - Create Windows/Linux VM in Azure
   - Install Python 3.11
   - Copy backend folder
   - Run: `pip install -r requirements.txt && python run.py`

2. **Deploy Frontend to Azure VM:**
   - Build: `npm run build`
   - Serve `client/dist/` with Nginx or IIS

3. **Network Configuration:**
   - Open port 8000 (backend) on VM security group
   - Update frontend API URL to backend VM IP
   - Configure Azure SQL firewall to allow VM access

4. **Optional: Use Azure App Services**
   - Backend: App Service (Python runtime)
   - Frontend: Static Web Apps
   - Database: Managed Azure SQL

## ⚠️ Important Notes
- Azure SQL credentials are hardcoded in `backend/app/core/config.py` for simplicity
- For production: Use Azure Key Vault for secret management
- CORS is configured for localhost - update for production URLs
- JWT SECRET_KEY should be changed before production deployment

</details>



<details>
  <summary style="
    background: linear-gradient(90deg, #1f2937, #111827);
    color: #22c55e;
    padding: 18px;
    border-radius: 10px;
    cursor: pointer;
    font-size: 1.35rem;
    font-weight: 700;
    margin: 12px 0;
    border-left: 5px solid #22c55e;
    box-shadow: 0 0 12px rgba(34, 197, 94, 0.25);
    display: flex;
    flex-direction: column;
  ">
    <span style="font-size: 1.5rem; font-weight: 700;">3-Tier Deployment Guide</span>
    <span style="font-size: 1rem; margin-top: 6px; color: #22c55e;">
      This guide explains how to deploy the Resource Management System in a 3-tier architecture on Azure.
    </span>
  </summary>

  <div style="
    background: #0d1117;
    padding: 18px;
    margin-top: 10px;
    border-radius: 8px;
    color: #e5e7eb;
    line-height: 1.6;
    border-left: 4px solid #22c55e;
  ">


## Architecture Overview

```
┌─────────────────────┐
│   Frontend (VM 1)   │
│   Static Files      │
│   Nginx Server      │
└──────────┬──────────┘
           │
           │ HTTP/HTTPS
           ▼
┌─────────────────────┐
│   Backend (VM 2)    │
│   Python FastAPI    │
│   Port 8000         │
└──────────┬──────────┘
           │
           │ SQL Connection
           ▼
┌─────────────────────┐
│  Azure SQL Database │
│   Managed Service   │
└─────────────────────┘
```

## Part 1: Azure SQL Database Setup

### Step 1: Create Azure SQL Database
1. Go to Azure Portal → Create Resource → SQL Database
2. Configure:
   - **Resource Group**: Create new or use existing
   - **Database Name**: `resource-management-db`
   - **Server**: Create new server
   - **Pricing Tier**: Choose appropriate tier (Basic/Standard/Premium)

### Step 2: Configure Firewall Rules
1. Go to your SQL Server → Networking
2. Add firewall rules:
   - Add client IP (for your development machine)
   - **_Add Backend VM IP (once created)_ -> IMPORTANT(NOT TO FORGET)**
   - Add Frontend VM IP (if needed)

### Step 3: Run Database Schema
1. Connect to Azure SQL using SQL Server Management Studio or Azure Data Studio
2. Run the script: `backend/azure_sql_schema.sql`
3. Verify tables are created: `users`, `theme_config`

## Part 2: Backend Deployment (VM 2 - Python API)

### Create Ubuntu VM
1. Azure Portal → Virtual Machines → Create
2. Configuration:
   - **OS**: Ubuntu 22.04 LTS
   - **Size**: Standard_B2s (2 vCPUs, 4 GB RAM) minimum
   - **Ports**: Open port **_8000_** (or use nginx reverse proxy on **_80/443_**)
   - **Authentication**: SSH key

### Install Dependencies
```bash
# SSH into the VM
ssh azureuser@<backend-vm-ip>

# Update system
sudo apt update && sudo apt upgrade -y

# Install Python 3 and pip
sudo apt install python3 python3-pip python3-venv -y

# Install SQL Server ODBC Driver
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list | sudo tee /etc/apt/sources.list.d/mssql-release.list
sudo apt-get update
sudo ACCEPT_EULA=Y apt-get install -y msodbcsql18
sudo ACCEPT_EULA=Y apt-get install -y mssql-tools18
sudo apt-get install -y unixodbc-dev
```

### Deploy Backend Code
```bash
# Clone your repository (or upload files)
git clone <your-repo-url>
cd backend

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Configure environment variables
nano .env
```

**.env file:**
```
AZURE_SQL_SERVER=your-server.database.windows.net
AZURE_SQL_DATABASE=resource-management-db
AZURE_SQL_USERNAME=your-admin-username (SOMETIME IT WILL TAKE YOUR_SERVERNAME/YOUR_DBNAME AS USER_NAME)
AZURE_SQL_PASSWORD=your-password
AZURE_SQL_DRIVER=ODBC Driver 18 for SQL Server
SECRET_KEY=your-super-secret-key-change-this
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
FRONTEND_URL=http://<frontend-vm-ip>
```

### Set up as System Service
```bash
sudo nano /etc/systemd/system/resource-api.service
```

```ini
[Unit]
Description=Resource Management FastAPI Backend
After=network.target

[Service]
User=azureuser
WorkingDirectory=/home/azureuser/backend
Environment="PATH=/home/azureuser/backend/venv/bin"
EnvironmentFile=/home/azureuser/backend/.env
ExecStart=/home/azureuser/backend/venv/bin/uvicorn app.main:app --host 0.0.0.0 --port 8000
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

```bash
# Enable and start service
sudo systemctl daemon-reload
sudo systemctl enable resource-api
sudo systemctl start resource-api
sudo systemctl status resource-api
```

### Configure Nginx (Optional but Recommended)
```bash
sudo apt install nginx -y
sudo nano /etc/nginx/sites-available/resource-api
```

```nginx
server {
    listen 80;
    server_name <backend-vm-ip-or-domain>;

    location / {
        proxy_pass http://localhost:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

```bash
sudo ln -s /etc/nginx/sites-available/resource-api /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

## Part 3: Frontend Deployment (VM 1 - Static Files)

### Create Ubuntu VM
1. Azure Portal → Virtual Machines → Create
2. Configuration:
   - **OS**: Ubuntu 22.04 LTS
   - **Size**: Standard_B1s (1 vCPU, 1 GB RAM) minimum
   - **Ports**: Open ports 80 and 443
   - **Authentication**: SSH key

### Install Node.js and Build Frontend
```bash
# SSH into the VM
ssh azureuser@<frontend-vm-ip>

# Install Node.js 20
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# Clone your repository
git clone <your-repo-url>
cd <your-repo>

# Update backend API URL in frontend
nano client/src/config/api.ts
```

**Update API URL:**
```typescript
export const API_BASE_URL = 'http://<backend-vm-ip>:8000';
```

**Build the frontend:**
```bash
# Install dependencies
npm install

# Build for production
npm run build
# This creates dist/public/ folder
```

### Install and Configure Nginx
```bash
sudo apt install nginx -y

# Copy build files to nginx directory
sudo cp -r dist/public/* /var/www/html/

# Configure nginx
sudo nano /etc/nginx/sites-available/default
```

```nginx
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html;

    server_name _;

    location / {
        try_files $uri $uri/ /index.html;
    }

    # API proxy (optional - if you want to avoid CORS)
    location /api {
        proxy_pass http://<backend-vm-ip>:8000/api;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

```bash
sudo nginx -t
sudo systemctl restart nginx
```

## Part 4: Testing the Deployment

### Test Backend API
```bash
curl http://<backend-vm-ip>:8000/health
# Should return: {"status":"healthy"}

curl http://<backend-vm-ip>:8000/api/theme/
# Should return theme configurations
```

### Test Frontend
Open browser: `http://<frontend-vm-ip>`

You should see the login page.

### Test End-to-End
1. Create a user via signup
2. Login
3. Navigate through the application
4. Check if all features work

## Security Checklist

- [ ] Change default SSH ports
- [ ] Configure UFW firewall
- [ ] Enable HTTPS with Let's Encrypt
- [ ] Use Azure Key Vault for secrets
- [ ] Enable Azure SQL firewall rules
- [ ] Set up monitoring and alerts
- [ ] Configure backup for Azure SQL
- [ ] Use private networking (VNet) between VMs
- [ ] Implement rate limiting
- [ ] Enable logging and monitoring

## Monitoring Commands

### Backend VM
```bash
# Check API status
sudo systemctl status resource-api

# View logs
sudo journalctl -u resource-api -f

# Check nginx
sudo systemctl status nginx
```

### Frontend VM
```bash
# Check nginx
sudo systemctl status nginx

# View nginx logs
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

## Troubleshooting

### Backend not connecting to Azure SQL
- Check firewall rules
- Verify connection string
- Test with: `telnet <server>.database.windows.net 1433`

### Frontend can't reach Backend
- Check CORS configuration in backend
- Verify backend VM firewall
- Check API_BASE_URL in frontend

### 502 Bad Gateway
- Check if backend service is running
- Verify nginx proxy configuration
- Check backend port availability

## Cost Optimization
- Use Azure Reserved Instances for VMs
- Choose appropriate SQL Database tier
- Set up auto-shutdown for non-production VMs
- Use Azure CDN for frontend static files
- Enable Azure SQL auto-pause for dev/test environments

    <p>This section contains detailed architecture insights.</p>
  </div>
</details>
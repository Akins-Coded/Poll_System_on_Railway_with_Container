"# Poll_System_on_Railway_with_Container" 
# Online Poll System – Production Docker Setup

This project runs the **Online Poll System** in a **production-ready Dockerized environment** using:

- **Postgres** for database
- **Django + Gunicorn** for the web app
- **Nginx** as reverse proxy
- **Certbot** for automatic SSL certificates (Let's Encrypt)

---

## 📂 Project Structure

```plaintext
online_poll_system/
├── .env                   # Environment variables (not committed to Git)
├── docker-compose.yml     # Main docker-compose file
├── Dockerfile             # Builds the Django app image
├── entrypoint.sh          # Startup script for Django container
├── nginx/
│   └── django.conf        # Nginx reverse proxy + SSL config
├── app/                   # Django project source code
│   ├── manage.py
│   ├── online_poll_system/
│   │   ├── settings.py
│   │   ├── wsgi.py
│   │   └── ...
└── README.md    

## 🔹 Environment Variables

Create a `.env` file in the project root (`online_poll_system/.env`).  
This file is **not committed to Git** (ensure `.env` is in `.gitignore`).

### Example `.env`

```env
# ---------------------------
# Postgres database settings
# ---------------------------
POSTGRES_USER=postgres
POSTGRES_PASSWORD=supersecurepassword
POSTGRES_DB=online_poll_system

# ---------------------------
# Django settings
# ---------------------------
DEBUG=0
DJANGO_SETTINGS_MODULE=online_poll_system.settings
SECRET_KEY=your-very-secret-production-key

# ---------------------------
# Database connection string
# ---------------------------
DATABASE_URL=postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@db:5432/${POSTGRES_DB}

🔹 Deployment Instructions
1. Clone the Project
git clone https://github.com/yourusername/online_poll_system.git
cd online_poll_system

2. Create .env File
nano .env


Paste the variables from the Example .env above, and save.

3. Build and Start Services (without Certbot)
docker compose up -d db web nginx


This will start Postgres, Django (Gunicorn), and Nginx.

4. Point Your Domain

Ensure your domain (yourdomain.com) has an A record pointing to your server’s IP.

5. Request Initial SSL Certificates

Run this one-time command:

docker run --rm \
  -v certbot_certs:/etc/letsencrypt \
  -v certbot_challenges:/var/www/certbot \
  certbot/certbot certonly --webroot \
  --webroot-path=/var/www/certbot \
  -d yourdomain.com -d www.yourdomain.com \
  --email you@example.com --agree-tos --no-eff-email

6. Restart the Stack with Certbot Included
docker compose up -d

7. Verify HTTPS

Visit:

https://yourdomain.com


If everything is correct:

Nginx proxies traffic to Django (via Gunicorn)

Static/media served directly by Nginx

SSL certificates auto-renew via Certbot

🔹 Notes

Always keep .env and certificates out of Git.

To check logs:

docker compose logs -f web
docker compose logs -f nginx
docker compose logs -f certbot


To rebuild after code changes:

docker compose build web
docker compose up -d

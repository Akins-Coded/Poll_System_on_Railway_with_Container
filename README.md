# Online Poll System – Railway Deployment Guide 🚀

This project is a **Django application** (Online Poll System) that is **containerized with Docker**, tested and built via **GitHub Actions**, published to **Docker Hub**, and deployed on **Railway**.  

---

## 📌 Workflow Overview

1. **Local Development**  
   - Run services with `docker-compose.yml` (`web + postgres`).  
   - Debug locally before pushing to GitHub.  

2. **Continuous Integration (CI)** – *GitHub Actions*  
   - Runs `migrate` and `test` with a Postgres container.  
   - Ensures code is production-ready before deployment.  

3. **Continuous Deployment (CD)** – *GitHub Actions → Docker Hub*  
   - Builds Docker image.  
   - Pushes to Docker Hub:  
     ```bash
     your-dockerhub-username/online_poll_system:latest
     ```

4. **Deployment (Production)** – *Railway*  
   - Railway pulls the Docker Hub image.  
   - Runs your Django app with Railway’s managed Postgres + HTTPS.  
   - No Nginx or Certbot required (Railway handles SSL).  

---

## 📂 Project Structure

```plaintext
online_poll_system/
├── .env                 # Environment variables (not committed)
├── Dockerfile           # Production-ready build
├── docker-compose.yml   # Local dev setup
├── entrypoint.sh        # Runs migrations + collectstatic + gunicorn
├── requirements.txt
├── manage.py
├── online_poll_system/  # Django project
│   ├── settings.py
│   ├── wsgi.py
│   └── ...
├── .github/
│   └── workflows/
│       └── ci.yml       # GitHub Actions CI/CD pipeline
└── README.md            # You are here
⚙️ Local Development
1. Configure .env
Create a .env file for local dev:

ini
Copy code
DEBUG=1
SECRET_KEY=localdevsecret
DJANGO_SETTINGS_MODULE=online_poll_system.settings
DATABASE_URL=postgres://postgres:postgres@db:5432/online_poll_system
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=online_poll_system
2. Run with Docker Compose
bash
Copy code
docker-compose up --build
Access app at 👉 http://localhost:8000.

🐳 Production Build (Dockerfile)
The production image:

Uses python:3.12-slim

Installs dependencies from requirements.txt

Runs migrations, collects static files, and starts gunicorn via entrypoint.sh

⚡ GitHub Actions (CI/CD)
File: .github/workflows/ci.yml

On Push/Pull to main:

Run migrations + tests with Postgres.

If tests pass → build + push Docker image to Docker Hub.

Clean up Docker cache and GitHub workspace.

Secrets required in GitHub repo:
DOCKER_HUB_USERNAME

DOCKER_HUB_ACCESS_TOKEN

🚀 Deploying to Railway
Login to Railway
Create a new project → choose Deploy from Docker Hub.

Use the image from Docker Hub:

bash
Copy code
your-dockerhub-username/online_poll_system:latest
Set environment variables in Railway Dashboard (same as .env, but adjust DATABASE_URL to Railway’s managed Postgres).

Done 🎉
Railway auto-handles:

HTTPS (SSL certs)

Scaling and monitoring

Automatic redeploy when Docker Hub is updated

🔄 Deployment Flow
mermaid
Copy code
flowchart LR
    A[Push Code to GitHub] --> B[GitHub Actions CI]
    B -->|Run Tests| C{Tests Pass?}
    C -->|No| D[Fail ❌]
    C -->|Yes| E[Build & Push to Docker Hub]
    E --> F[Railway Pulls Image]
    F --> G[Deployed ✅]
🧹 Workspace Cleanup
GitHub Actions job runs:

bash
Copy code
docker system prune -af
rm -rf ${{ github.workspace }}
Prevents storage bloat.

Ensures clean environment for next runs.

✅ Summary
Local dev → docker-compose up

GitHub CI → runs tests on push/pull

GitHub CD → builds + pushes Docker image

Railway → pulls from Docker Hub + deploys

This setup ensures reliable, production-ready deployments with minimal manual intervention.
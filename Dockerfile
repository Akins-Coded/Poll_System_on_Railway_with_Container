# --------------------------
# Base image (lightweight Python)
# --------------------------
FROM python:3.12-slim AS base

# --------------------------
# Environment settings
# --------------------------
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_DEFAULT_TIMEOUT=100

# --------------------------
# Set working directory
# --------------------------
WORKDIR /app

# --------------------------
# Install system dependencies (Postgres + build tools)
# --------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# --------------------------
# Install Python dependencies (use cache layers)
# --------------------------
COPY requirements.txt .
RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# --------------------------
# Copy project files
# --------------------------
COPY . .

# --------------------------
# Collect static files for Django
# --------------------------
RUN python manage.py collectstatic --noinput || echo "⚠️ collectstatic skipped"

# --------------------------
# Expose port (Railway sets $PORT automatically)
# --------------------------
EXPOSE 8000

# --------------------------
# Run Gunicorn as production server
# --------------------------
CMD ["sh", "-c", "gunicorn online_poll_system.wsgi:application --bind 0.0.0.0:${PORT:-8000} --workers=4 --threads=4 --timeout=120"]

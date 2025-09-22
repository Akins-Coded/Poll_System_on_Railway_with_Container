# --------------------------
# Base image
# --------------------------
FROM python:3.12-slim AS base

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

WORKDIR /app

# --------------------------
# System dependencies
# --------------------------
RUN apt-get update && apt-get install -y \
    libpq-dev gcc curl netcat-traditional \
    && rm -rf /var/lib/apt/lists/*

# --------------------------
# Install Python dependencies
# --------------------------
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# --------------------------
# Copy project
# --------------------------
COPY . .

# --------------------------
# Entrypoint for migrations, collectstatic & gunicorn
# --------------------------
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]

#!/bin/sh
set -e

echo "Waiting for database..."
until nc -z db 5432; do
  sleep 2
done
echo "Database is ready!"

echo "Running migrations..."
python manage.py migrate --noinput

echo "Collecting static files..."
python manage.py collectstatic --noinput

echo "Starting Gunicorn..."
exec gunicorn online_poll_system.wsgi:application \
    --bind 0.0.0.0:8000 \
    --workers=4 \
    --threads=4 \
    --timeout=120

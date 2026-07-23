FROM python:3.11-slim-buster

# Set work directory
WORKDIR /app

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Dependencies for psycopg2 (Removed exact version pins to prevent build crash)
#RUN apt-get update && apt-get install --no-install-recommends -y dnsutils libpq-dev gcc && apt-get clean && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN python -m pip install --no-cache-dir --upgrade pip

# Install requirements
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

EXPOSE 8000

# Run migrations and start gunicorn at RUNTIME (not build time)
CMD python manage.py migrate && gunicorn --bind 0.0.0.0:8000 --workers 6 pygoat.wsgi

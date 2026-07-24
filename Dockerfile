FROM python:3.11-slim-bookworm

# Set work directory
WORKDIR /app

# Install system dependencies (Debian Bookworm uses updated packages)
RUN apt-get update && apt-get install --no-install-recommends -y \
    dnsutils \
    libpq-dev \
    gcc \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Upgrade pip and install requirements in fewer layers
#RUN python -m pip install --no-cache-dir --upgrade pip
RUN python -m pip install --upgrade pip setuptools wheel
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . /app/

EXPOSE 8000

# Start server directly (Run migrations externally)
RUN python3 /app/manage.py migrate
WORKDIR /app/pygoat/
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers","6", "pygoat.wsgi"]

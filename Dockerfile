# Python Flask Guessing Game (port 80)
FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy requirements and install
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose Flask/Gunicorn port
ENV PORT=80
EXPOSE 80

# Run using Gunicorn (Flask factory pattern)
CMD ["gunicorn", "-w", "2", "-b", "0.0.0.0:80", "guessing_game_computer:create_app()"]
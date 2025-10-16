FROM public.ecr.aws/docker/library/python:3.12-slim

WORKDIR /app
COPY guessing_game_computer.py /app/guessing_game_computer.py

RUN pip install --no-cache-dir flask gunicorn

# ✅ Create the Flask app file instead of running it during build
RUN /bin/sh -c 'cat > /app/app.py <<EOF
from flask import Flask, jsonify, request
import random

app = Flask(__name__)

@app.get("/")
def index():
    return "Guessing Game service is up. Try /health", 200

@app.get("/health")
def health():
    return jsonify(ok=True), 200

@app.get("/guess")
def guess():
    target = int(request.args.get("target", random.randint(1,100)))
    g = int(request.args.get("g", random.randint(1,100)))
    if g == target:
        outcome = "correct"
    elif g < target:
        outcome = "low"
    else:
        outcome = "high"
    return jsonify(target=target, guess=g, outcome=outcome)
EOF'

ENV PORT=8080
EXPOSE 8080

# Gunicorn runs the app at runtime (not build time)
CMD ["gunicorn", "-b", "0.0.0.0:8080", "app:app", "--workers", "2", "--threads", "4"]
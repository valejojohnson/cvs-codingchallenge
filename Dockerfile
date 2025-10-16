FROM public.ecr.aws/docker/library/python:3.12-slim
WORKDIR /app
COPY guessing_game_computer.py /app/guessing_game_computer.py
RUN pip install --no-cache-dir flask gunicorn
RUN python - <<'PY'
from flask import Flask, jsonify, request
import random
app = Flask(__name__)
@app.get("/")
def index():
    return "Guessing Game service is up. Try /health", 200
@app.get("/health")
def health():
    return jsonify(ok=True), 200
# quick demo endpoint using guessing logic; adjust as you like
@app.get("/guess")
def guess():
    target = int(request.args.get("target", random.randint(1,100)))
    g = int(request.args.get("g", random.randint(1,100)))
    if g==target: outcome="correct"
    elif g<target: outcome="low"
    else: outcome="high"
    return jsonify(target=target, guess=g, outcome=outcome)
if __name__ == "__main__":
    import os
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", "8080")))
PY
ENV PORT=8080
EXPOSE 8080
CMD ["gunicorn","-b","0.0.0.0:8080","app:app","--workers","2","--threads","4"]
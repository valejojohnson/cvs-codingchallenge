import os
import random
import threading
from flask import Flask, request, redirect, url_for, render_template_string, jsonify

app = Flask(__name__)

# ---- single-game, in-memory state ----
MAX_NUMBER = int(os.environ.get("MAX_NUMBER", "10"))
_game_lock = threading.Lock()   # protects the state below
_target = random.randint(1, MAX_NUMBER)
_tries = 0
_last_hint = ""                 # "Too low", "Too high", "Correct!"

PAGE = """
<!doctype html>
<title>Guessing Game (single player)</title>
<meta name="viewport" content="width=device-width,initial-scale=1">
<style>
  body{font-family:system-ui,-apple-system,Segoe UI,Roboto,sans-serif;margin:0;background:#0b1220;color:#e7eaf1}
  .card{max-width:520px;margin:4rem auto;background:#121a2a;padding:24px;border-radius:16px}
  input[type=number]{padding:10px;border-radius:10px;border:1px solid #2b3a5c;background:#0d1626;color:#e7eaf1;width:120px}
  button{padding:10px 14px;border:0;border-radius:10px;background:#4f7cff;color:#fff;font-weight:600;cursor:pointer}
  .muted{opacity:.75}
  .ok{color:#78ffb0} .bad{color:#ff7c7c}
</style>
<div class="card">
  <h1>🧠 Guessing Game</h1>
  <p class="muted">I'm thinking of a number between 1 and {{max}}. Enter a guess and press “Submit”.</p>

  {% if hint %}
    <p>
      {% if hint == "Correct!" %}
        <strong class="ok">🎉 {{hint}}</strong>
      {% elif "low" in hint %}
        <span class="bad">📉 {{hint}}</span>
      {% elif "high" in hint %}
        <span class="bad">📈 {{hint}}</span>
      {% else %}
        {{hint}}
      {% endif %}
    </p>
  {% endif %}

  <form method="post" action="{{url_for('guess')}}">
    <input type="number" name="g" min="1" max="{{max}}" autofocus required>
    <button type="submit">Submit</button>
    <a href="{{url_for('reset')}}"><button type="button">New game</button></a>
  </form>

  <p class="muted">Tries: {{tries}}</p>
  <p class="muted">Health: <a href="{{url_for('health')}}" target="_blank">/health</a></p>
</div>
"""

def _reset():
    global _target, _tries, _last_hint
    _target = random.randint(1, MAX_NUMBER)
    _tries = 0
    _last_hint = ""

@app.get("/")
def index():
    with _game_lock:
        return render_template_string(PAGE, max=MAX_NUMBER, tries=_tries, hint=_last_hint)

@app.post("/guess")
def guess():
    global _tries, _last_hint
    g_raw = request.form.get("g")
    try:
        g = int(g_raw)
    except Exception:
        with _game_lock:
            _last_hint = "Please enter a valid integer."
            return redirect(url_for("index"))

    with _game_lock:
        _tries += 1
        if g == _target:
            _last_hint = "Correct!"
        elif g < _target:
            _last_hint = "Too low."
        else:
            _last_hint = "Too high."
    return redirect(url_for("index"))

@app.get("/reset")
def reset():
    with _game_lock:
        _reset()
    return redirect(url_for("index"))

@app.get("/health")
def health():
    return jsonify(ok=True), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", "80")))
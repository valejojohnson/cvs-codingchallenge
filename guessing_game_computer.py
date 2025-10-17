import os, random
from flask import Flask, render_template_string, request, session, redirect, url_for, jsonify

# ---------- Config ----------
SECRET = os.environ.get("SECRET_KEY", "dev-secret")
MAX_NUMBER = int(os.environ.get("MAX_NUMBER", "5"))  # default 1–5

# ---------- App ----------
def create_app():
    app = Flask(__name__)
    app.secret_key = SECRET
    app.config.update(SESSION_COOKIE_HTTPONLY=True, SESSION_COOKIE_SAMESITE="Lax")

    # ---------- Helpers ----------
    def reset_game():
        session["number"] = random.randint(1, MAX_NUMBER)
        session["attempts"] = 0
        session["message"] = f"I’m thinking of a number between 1 and {MAX_NUMBER}. Can you guess it? 🤔"
        session["success"] = False
        session["streak"] = session.get("streak", 0)

    @app.before_request
    def ensure_game():
        if "number" not in session:
            reset_game()

    # ---------- Routes ----------
    @app.get("/")
    def index():
        return render_template_string(PAGE,
                                      message=session.get("message",""),
                                      attempts=session.get("attempts",0),
                                      success=session.get("success",False),
                                      streak=session.get("streak",0),
                                      maxnum=MAX_NUMBER
                                      )

    @app.post("/guess")
    def guess():
        raw = (request.form.get("guess") or "").strip()
        try:
            g = int(raw)
        except ValueError:
            session["message"] = f"That wasn’t a number. Try 1–{MAX_NUMBER}! 😅"
            session["success"] = False
            return redirect(url_for("index"))

        if not (1 <= g <= MAX_NUMBER):
            session["message"] = f"Out of bounds! Pick 1–{MAX_NUMBER}. 🎯"
            session["success"] = False
            return redirect(url_for("index"))

        session["attempts"] = session.get("attempts", 0) + 1
        target = session["number"]

        if g == target:
            tries = session["attempts"]
            session["message"] = f"🎉 Nailed it! {g} was the number. {tries} attempt{'s' if tries != 1 else ''}. Play again for a streak!"
            session["success"] = True
            session["streak"] = session.get("streak", 0) + 1
        else:
            hint = "higher ⬆️" if g < target else "lower ⬇️"
            pep = random.choice(["You got this!", "Close!", "Trust your gut.", "Channel your inner psychic 🔮"])
            session["message"] = f"Not quite. Try {hint}! (Attempt {session['attempts']}) — {pep}"
            session["success"] = False
            session["streak"] = 0

        return redirect(url_for("index"))

    @app.post("/reset")
    def reset():
        reset_game()
        return redirect(url_for("index"))

    @app.get("/health")
    def health():
        return jsonify(status="ok"), 200

    return app

# ---------- Inline UI (glassy card + confetti) ----------
PAGE = r"""
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8"/><meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Guess 1–{{maxnum}} 🎲</title>
<style>
:root{--bg:#0b0f1d;--bg2:#0e1426;--bord:rgba(255,255,255,.14);--text:#eef1ff;--muted:#a9b1d6;--accent:#8da2ff;--success:#32d296;--shadow:0 30px 80px rgba(0,0,0,.45)}
*{box-sizing:border-box}html,body{height:100%}
body{margin:0;font-family:ui-sans-serif,system-ui,-apple-system,Inter,Roboto,Arial,sans-serif;color:var(--text);
background:radial-gradient(1200px 400px at 10% -20%, rgba(141,162,255,.12), transparent 60%),
radial-gradient(900px 360px at 120% 10%, rgba(177,134,255,.12), transparent 65%),linear-gradient(180deg,var(--bg),var(--bg2));
display:grid;place-items:center;padding:28px}
.card{width:min(720px,92vw);background:linear-gradient(180deg,rgba(255,255,255,.09),rgba(255,255,255,.03));border:1px solid var(--bord);
border-radius:22px;padding:26px 24px;box-shadow:var(--shadow);backdrop-filter:blur(9px) saturate(140%);position:relative}
.pop-in{animation:pop .45s cubic-bezier(.2,.8,.2,1) both}@keyframes pop{from{transform:translateY(8px) scale(.98);opacity:0}to{transform:none;opacity:1}}
h1{margin:0 0 6px;font-weight:900;letter-spacing:.2px;font-size:clamp(28px,4.4vw,40px)}
.subtle{margin:0 0 16px;color:var(--muted)}.blink{animation:blink 2.5s infinite}@keyframes blink{50%{opacity:.6}}
.message{margin:10px 0 18px;color:var(--muted);border-left:3px solid rgba(255,255,255,.22);padding:10px 12px;border-radius:10px;
background:linear-gradient(90deg,rgba(255,255,255,.06),transparent)}.message.success{color:var(--success);border-left-color:var(--success)}
.row{display:flex;gap:10px;margin:10px 0 8px}
input[type=number]{flex:1;padding:14px 16px;border-radius:14px;border:1px solid rgba(255,255,255,.16);background:rgba(8,10,20,.8);color:var(--text);font-size:16px;outline:none;transition:border .2s, box-shadow .2s}
input[type=number]:focus{border-color:var(--accent);box-shadow:0 0 0 4px rgba(141,162,255,.15)}
button{padding:12px 16px;border-radius:14px;border:1px solid rgba(255,255,255,.14);background:linear-gradient(180deg,var(--accent),#6e84ff);color:#0a0d1a;font-weight:800;cursor:pointer;transition:transform .08s, filter .2s, box-shadow .2s;box-shadow:0 10px 24px rgba(109,132,255,.25)}
button:hover{transform:translateY(-1px);filter:brightness(1.06)}button:active{transform:translateY(0) scale(.98)}
button.secondary{background:transparent;color:var(--text);border:1px solid rgba(255,255,255,.14);box-shadow:none}
.stats{display:flex;gap:10px;margin:10px 0 12px;flex-wrap:wrap}
.chip{background:rgba(255,255,255,.06);border:1px solid rgba(255,255,255,.12);border-radius:999px;padding:8px 12px;color:var(--muted)}
footer{margin-top:6px;font-size:12px}footer a{color:var(--muted);text-decoration:none}
#confetti{pointer-events:none;position:fixed;inset:0;overflow:hidden}.confetto{position:absolute;will-change:transform,opacity;font-size:18px;opacity:0;animation:fall 1.6s ease-out forwards}
@keyframes fall{0%{transform:translateY(-10vh) rotate(0) scale(1);opacity:0}10%{opacity:1}100%{transform:translateY(100vh) rotate(540deg) scale(1.2);opacity:0}}
</style>
</head>
<body>
<div id="confetti"></div>
<main class="card pop-in">
  <h1>Guess 1–{{maxnum}} 🎲</h1>
  <p class="subtle">I’m thinking of a number between 1 and {{maxnum}}. Can you guess it? <span class="blink">🤔</span></p>

  {% if message %}<p class="message {% if success %}success{% endif %}">{{message}}</p>{% endif %}

  <form action="{{ url_for('guess') }}" method="post" class="row" id="guess-form">
    <input id="guess-input" type="number" name="guess" min="1" max="{{maxnum}}" placeholder="Type 1–{{maxnum}} and hit Enter" required>
    <button class="primary" type="submit">Guess</button>
  </form>

  <div class="stats">
    <div class="chip">Attempts: <strong>{{attempts}}</strong></div>
    <div class="chip">Streak: <strong>{{streak}}</strong></div>
  </div>

  <form action="{{ url_for('reset') }}" method="post"><button class="secondary" type="submit">Play Again</button></form>
  <footer><a href="/health" target="_blank">health</a></footer>
</main>
<script>
(function(){
  const input=document.getElementById('guess-input'), form=document.getElementById('guess-form');
  if(input){ setTimeout(()=>input.focus(),50); input.addEventListener('keydown',e=>{if(e.key==='Enter')form.requestSubmit();}); }
  const success={{ 'true' if success else 'false' }};
  if(success){ confetti(); pulse(); }
  function confetti(){ const em=['🎉','✨','🎊','💫','🟦','🟣','🟡','🟠'], root=document.getElementById('confetti'), count=42, vw=window.innerWidth||800;
    for(let i=0;i<count;i++){ const s=document.createElement('span'); s.className='confetto'; s.textContent=em[Math.random()*em.length|0];
      s.style.left=(Math.random()*vw)+'px'; s.style.animationDelay=(Math.random()*0.4)+'s'; root.appendChild(s); setTimeout(()=>root.removeChild(s),1800); } }
  function pulse(){ const card=document.querySelector('.card'); if(!card)return;
    card.animate([{transform:'scale(1)',boxShadow:'var(--shadow)'},{transform:'scale(1.02)',boxShadow:'0 40px 90px rgba(0,0,0,.55)'},{transform:'scale(1)',boxShadow:'var(--shadow)'}],{duration:600,easing:'ease-out'}); }
})();
</script>
</body></html>
"""

# ---------- Local Dev ----------
if __name__ == "__main__":
    create_app().run(host="0.0.0.0", port=int(os.environ.get("PORT","80")))
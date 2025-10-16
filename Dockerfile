FROM public.ecr.aws/docker/library/python:3.12-slim

WORKDIR /app
COPY guessing_game_computer.py /app/guessing_game_computer.py
RUN pip install --no-cache-dir flask gunicorn

ENV PORT=80
EXPOSE 80

CMD ["gunicorn", "-b", "0.0.0.0:80", "guessing_game_computer:app", "--workers", "1", "--threads", "1"]
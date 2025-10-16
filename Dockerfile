FROM public.ecr.aws/docker/library/python:3.12-slim

WORKDIR /app

# Copy your existing app file
COPY guessing_game_computer.py /app/guessing_game_computer.py

# Install Flask & Gunicorn
RUN pip install --no-cache-dir flask gunicorn

# Expose the app port
ENV PORT=8080
EXPOSE 8080

# Run your Python app directly
CMD ["gunicorn", "-b", "0.0.0.0:8080", "guessing_game_computer:app", "--workers", "2", "--threads", "4"]
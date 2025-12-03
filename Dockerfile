# Basis-Image: schlankes Python-Image
FROM python:3.11-slim

# Arbeitsverzeichnis im Container
WORKDIR /app

# Dependencies zuerst kopieren
COPY requirements.txt .

# Dependencies installieren
RUN pip install --no-cache-dir -r requirements.txt

# Restlichen Code kopieren
COPY . .

# Exposed Port (reine Doku)
EXPOSE 8000

# Startbefehl für den Container
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

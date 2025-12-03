from fastapi import FastAPI
from datetime import datetime

app = FastAPI(title="Enterprise K8s Demo App")

@app.get("/")
def read_root():
    return {
        "message": "Hello from your Enterprise Kubernetes Demo App!",
        "timestamp": datetime.utcnow().isoformat() + "Z"
    }

@app.get("/health")
def health_check():
    return {"status": "ok"}
# Test App – Enterprise Kubernetes Demo

Dieses Repository dokumentiert Schritt für Schritt, wie eine kleine Webanwendung von null an aufgebaut, containerisiert und schließlich in einem lokalen Kubernetes-Cluster (kind) deployed wird.  
Das Ziel ist, eine realistische Grundlage für eine **Enterprise Kubernetes Platform** zu schaffen (später mit Helm, ArgoCD, Monitoring usw.).

Die Anleitung ist so aufgebaut, dass sie auch für absolute Einsteiger nachvollziehbar ist.

---

## Inhaltsverzeichnis

1. [Ziel des Projekts](#ziel-des-projekts)  
2. [Voraussetzungen & Installationen](#voraussetzungen--installationen)  
   2.1 [Git installieren & konfigurieren](#21-git-installieren--konfigurieren)  
   2.2 [GitHub-Account & Repository](#22-github-account--repository)  
   2.3 [Visual Studio Code](#23-visual-studio-code)  
   2.4 [Docker Desktop](#24-docker-desktop)  
   2.5 [Python installieren](#25-python-installieren)  
   2.6 [Kubernetes lokal mit kind](#26-kubernetes-lokal-mit-kind)  
   2.7 [Helm installieren](#27-helm-installieren)  
3. [Projektstruktur & Git-Setup](#projektstruktur--git-setup)  
4. [Webanwendung mit FastAPI erstellen](#webanwendung-mit-fastapi-erstellen)  
5. [Python-Abhängigkeiten definieren](#python-abhängigkeiten-definieren)  
6. [Docker-Container bauen & starten](#docker-container-bauen--starten)  
7. [Kubernetes-Deployment & Service erstellen](#kubernetes-deployment--service-erstellen)  
   7.1 [Image in den kind-Cluster laden](#71-image-in-den-kind-cluster-laden)  
   7.2 [Deployment erstellen](#72-deployment-erstellen)  
   7.3 [Service erstellen](#73-service-erstellen)  
   7.4 [Deployment & Service anwenden](#74-deployment--service-anwenden)  
   7.5 [App in Kubernetes testen](#75-app-in-kubernetes-testen)   
   7.6 [Erklärung: Was Deployment & Service tun](#76-erklärung-was-deployment--service-tun)  
   7.7 [Git-Commits & Push nach GitHub](#77-git-commits--push-nach-github)  
   7.8 [Nächste Schritte 1 (Ausblick)](#78-nächste-schritte-1-ausblick)  
8. [Helm-Chart (Deployment der Anwendung mit Helm)](#helm-chart-deployment-der-anwendung-mit-helm)  
   8.1 [Helm-Chart erstellen](#81-helm-chart-erstellen)  
   8.2 [Anwendung in Kubernetes testen](#82-anwendung-in-kubernetes-testen)  
   8.3 [Helm-Upgrade (Beispiel)](#83-helm-upgrade-beispiel)  
   8.4 [Zusammenfassung – Vorteile des Helm-Charts](#84-zusammenfassung--vorteile-des-helm-charts)  
9. [GitOps mit ArgoCD – Automatisiertes Deployment des Helm-Charts](#gitops-mit-argocd--automatisiertes-deployment-des-helm-charts)  
   9.1 [Installation von ArgoCD im Kubernetes-Cluster](#91-installation-von-argocd-im-kubernetes-cluster)  
   9.2 [Zugriff auf die ArgoCD-Weboberfläche](#92-zugriff-auf-die-argocd-weboberfläche)  
   9.3 [Erstellen der ersten ArgoCD Application](#93-erstellen-der-ersten-argocd-application)  
   9.4 [Synchronisation des Deployments mit ArgoCD](#94-synchronisation-des-deployments-mit-argocd)  
   9.5 [GitOps in Aktion - Änderungen per Git ausrollen](#95-gitops-in-aktion---änderungen-per-git-ausrollen)  
   9.6 [Optional: Autmatische Synchronisation aktivieren](#96-optional-autmatische-synchronisation-aktivieren)  
   9.7 [Zusammenfassung – GitOps mit ArgoCD](#97-zusammenfassung--gitops-mit-argocd)  

---

## Ziel des Projekts

Ziel dieses Projekts ist es, eine einfache, aber realistische Grundlage für eine **Cloud-/DevOps-/Kubernetes-Demonstration** aufzubauen:

- Eine kleine Web-API mit **FastAPI**
- Versioniert mit **Git** und **GitHub**
- In einem **Docker-Container** lauffähig
- In einem lokalen **Kubernetes-Cluster (kind)** deployed
- Mit professioneller Struktur, die später erweitert werden kann (Helm, ArgoCD, Monitoring, Cloud-Cluster etc.)

Dieses Repository ist damit der erste Baustein für eine größere **„Enterprise Kubernetes Platform“**.

---

## Voraussetzungen & Installationen

### 2.1 Git installieren & konfigurieren

1. **Git herunterladen**  
   - Webseite: https://git-scm.com  
   - „Download for Windows“ auswählen (bzw. passende Version für dein Betriebssystem).

2. **Installer ausführen**  
   - Doppelklick auf die heruntergeladene `.exe`  
   - Die meisten Einstellungen können auf Standard bleiben. Wichtig:
     - *Adjusting PATH* → „Git from the command line and also from 3rd-party software“ auswählen.
     - Optional Editor: VS Code auswählen, wenn installiert.

3. **Installation testen**  
   Im Terminal / PowerShell:

   ```bash
   git --version
   ```

   Wenn eine Version ausgegeben wird, ist Git installiert.

4. **Namen und E-Mail global konfigurieren**  
   (E-Mail sollte zur GitHub-Adresse passen, z. B. echte Mail oder GitHub-Noreply)

   ```bash
   git config --global user.name "Dein Name"
   git config --global user.email "deine_github_email@example.com"
   ```

   Beispiel:

   ```bash
   git config --global user.name "Max Mustermann"
   git config --global user.email "12345678+username@users.noreply.github.com"
   ```

---

### 2.2 GitHub-Account & Repository

1. **GitHub-Account erstellen**  
   - https://github.com aufrufen  
   - Registrieren bzw. einloggen.

2. **Neues Repository erstellen**  
   - Oben rechts „+“ → „New repository“  
   - Name: z. B. `test-app`  
   - Visibility: `Public` (für Portfolio sinnvoll)  
   - Kein Häkchen bei „Initialize this repository with a README“.

Das Repository wird später mit dem lokalen Projekt verbunden.

---

### 2.3 Visual Studio Code

Visual Studio Code dient als Editor/IDE.

1. Download: https://code.visualstudio.com  
2. Installieren mit Standardoptionen.  
3. Praktische Extensions:
   - „Python“
   - „Docker“
   - „YAML“
   - „GitHub Pull Requests and Issues“

---

### 2.4 Docker Desktop

1. Download: https://www.docker.com/products/docker-desktop/  
2. Installer ausführen (unter Windows mit WSL 2-Unterstützung).  
3. Docker Desktop starten.  
4. Testen im Terminal:

   ```bash
   docker version
   ```

---

### 2.5 Python installieren

1. Download: https://www.python.org/downloads/  
2. Bei der Installation **„Add Python to PATH“** aktivieren.  
3. Nach Installation prüfen:

   ```bash
   python --version
   ```

   oder

   ```bash
   py --version
   ```

---

### 2.6 Kubernetes lokal mit kind

Wir nutzen **kind** (Kubernetes IN Docker), um einen lokalen Kubernetes-Cluster zu starten.

1. **kubectl installieren** (Windows-Beispiel mit `winget`):

   ```bash
   winget install -e --id Kubernetes.kubectl
   ```

   Test:

   ```bash
   kubectl version --client
   ```

2. **kind installieren**:

   ```bash
   winget install -e --id Kubernetes.kind
   ```

   Test:

   ```bash
   kind version
   ```

3. **Cluster erstellen**:

   ```bash
   kind create cluster --name dev-cluster
   ```

4. **Cluster prüfen**:

   ```bash
   kubectl cluster-info
   kubectl get nodes
   ```

---

### 2.7 Helm installieren

Helm ist der Paketmanager für Kubernetes.

Installation unter Windows mit `winget`:

```bash
winget install -e --id Helm.Helm
```

Test:

```bash
helm version
```

---

## Projektstruktur & Git-Setup

Das Projekt liegt beispielsweise unter:

```text
D:\dev\test-app
```

### 1. Projektordner anlegen

Im Terminal:

```bash
D:
mkdir dev
cd dev
mkdir test-app
cd test-app
```

### 2. Git-Repository initialisieren

```bash
git init
```

### 3. Erste README-Datei anlegen

In VS Code (`code .`) oder im Terminal:

```bash
echo "# Test App – Enterprise Kubernetes Demo" > README.md
```

Datei mit Git versionieren:

```bash
git add README.md
git commit -m "Initial commit: add README"
```

### 4. Repository mit GitHub verbinden

Auf GitHub wurde zuvor ein leeres Repository (z. B. `test-app`) erstellt.

Im Projektordner:

```bash
git remote add origin https://github.com/DEIN_USERNAME/test-app.git
git branch -M main
git push -u origin main
```

Jetzt ist das Projekt mit GitHub verknüpft.

---

## Webanwendung mit FastAPI erstellen

### 1. FastAPI und Uvicorn installieren

Im Projektordner:

```bash
cd D:\dev\test-app
pip install fastapi uvicorn
```

### 2. `main.py` erstellen

In VS Code `main.py` anlegen mit folgendem Inhalt:

```python
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
```

### 3. Anwendung lokal ohne Docker testen

```bash
uvicorn main:app --reload
```

Im Browser aufrufen:

- http://localhost:8000/
- http://localhost:8000/health

Beenden mit `Strg + C`.

---

## Python-Abhängigkeiten definieren

`requirements.txt` erstellen:

```text
fastapi
uvicorn[standard]
```

Diese Datei beschreibt die Python-Abhängigkeiten, die später im Docker-Container installiert werden.

---

## Docker-Container bauen & starten

### 1. Dockerfile erstellen

Im Projektordner `Dockerfile` mit folgendem Inhalt anlegen:

```dockerfile
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
```

### 2. Docker-Image bauen

```bash
docker build -t test-app:local .
```

Wenn der Build erfolgreich war, sollte ein Image `test-app:local` vorhanden sein:

```bash
docker images
```

### 3. Container starten

```bash
docker run --name test-app-container -p 8000:8000 test-app:local
```

Im Browser testen:

- http://localhost:8000/
- http://localhost:8000/health

Container stoppen mit `Strg + C`, optional entfernen:

```bash
docker rm test-app-container
```

---

## Kubernetes-Deployment & Service erstellen

Ziel dieses Abschnitts:  
Die Anwendung soll im lokalen Kubernetes-Cluster (kind) laufen.

### 7.1 Image in den kind-Cluster laden

Damit der Cluster das lokal gebaute Image verwenden kann:

```bash
kind load docker-image test-app:local --name dev-cluster
```

---

### 7.2 Deployment erstellen

Im Projektordner einen Unterordner für Kubernetes-Dateien anlegen:

```bash
cd D:\dev\test-app
mkdir k8s
```

`k8s/deployment.yaml` erstellen mit:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: test-app
  labels:
    app: test-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: test-app
  template:
    metadata:
      labels:
        app: test-app
    spec:
      containers:
        - name: test-app
          image: test-app:local
          imagePullPolicy: IfNotPresent
          ports:
            - containerPort: 8000
          readinessProbe:
            httpGet:
              path: /health
              port: 8000
            initialDelaySeconds: 3
            periodSeconds: 5
          livenessProbe:
            httpGet:
              path: /health
              port: 8000
            initialDelaySeconds: 10
            periodSeconds: 10
```

---

### 7.3 Service erstellen

`k8s/service.yaml` erstellen mit:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: test-app
  labels:
    app: test-app
spec:
  type: ClusterIP
  selector:
    app: test-app
  ports:
    - name: http
      port: 8000
      targetPort: 8000
```

---

### 7.4 Deployment & Service anwenden

Im Projektordner:

```bash
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
```

Pods prüfen:

```bash
kubectl get pods
```

Services prüfen:

```bash
kubectl get svc
```

---

### 7.5 App in Kubernetes testen

Da der Service vom Typ `ClusterIP` ist, wird Port-Forwarding verwendet:

```bash
kubectl port-forward service/test-app 8000:8000
```

Danach im Browser:

- http://localhost:8000/
- http://localhost:8000/health

Beenden mit `Strg + C`.

---

### 7.6 Erklärung: Was Deployment & Service tun

#### Deployment (`deployment.yaml`)

Das Deployment definiert, wie Kubernetes die Anwendung startet und am Laufen hält:

- **Anzahl der Instanzen (replicas)**: hier `2` Pods  
- **Container-Image**: `test-app:local`  
- **Health-Checks** über `/health`:
  - *ReadinessProbe*: Ist der Pod bereit, Anfragen zu beantworten?
  - *LivenessProbe*: Lebt der Pod noch oder muss er neugestartet werden?

Kurz gesagt:

> Das Deployment ist der „Startauftrag“ für die App in Kubernetes und sorgt für Stabilität, Skalierung und Selbstheilung.

#### Service (`service.yaml`)

Der Service stellt eine feste Adresse für die Pods bereit:

- Wählt Pods mit Label `app: test-app`
- Leitet Anfragen auf Port `8000` an die Anwendung weiter
- Typ `ClusterIP`: intern im Cluster erreichbar (für lokale Tests per Port-Forward)

Kurz gesagt:

> Der Service macht die App im Cluster erreichbar, auch wenn Pods neu gestartet oder ersetzt werden.

---

### 7.7 Git-Commits & Push nach GitHub

Alle wichtigen Schritte werden mit Git versioniert und auf GitHub veröffentlicht.

Nach dem Hinzufügen von Dateien wie `main.py`, `requirements.txt`, `Dockerfile` und den Kubernetes-Manifests:

```bash
git status
git add main.py requirements.txt Dockerfile k8s/deployment.yaml k8s/service.yaml
git commit -m "Add FastAPI app, Docker setup and Kubernetes manifests"
git push
```

Damit ist der aktuelle Projektstand im GitHub-Repository sichtbar.

---

### 7.8 Nächste Schritte 1 (Ausblick)

Dieses Repository bildet die Basis für weitere, fortgeschrittene DevOps-/Cloud-Themen:

- Erstellung eines **Helm-Charts** für die Anwendung
- Installation von **ArgoCD** und Aufbau eines **GitOps-Workflows**
- Integration eines **Monitoring-Stacks** (Prometheus, Grafana, Loki)
- Migration vom lokalen `kind`-Cluster auf einen Managed Kubernetes-Dienst (z. B. AWS EKS)

Diese weiteren Schritte können auf diesem Fundament aufbauen und das Projekt in Richtung einer vollwertigen „Enterprise Kubernetes Platform“ weiterentwickeln.

---

## Helm-Chart (Deployment der Anwendung mit Helm)

Nachdem die Anwendung erfolgreich über reine Kubernetes-Manifeste (`deployment.yaml`, `service.yaml`) im Cluster lief, wurde im nächsten Schritt ein eigenes **Helm-Chart** erstellt.  
Helm ermöglicht ein wiederverwendbares, versionierbares und produktionsähnliches Deployment der Anwendung.

---

### Warum Helm?

Helm löst mehrere typische Probleme bei Kubernetes-Deployments:

- Wiederverwendbare Templates statt duplizierter YAML-Dateien  
- Klare Struktur und Trennung von Werten (`values.yaml`) und Logik (`templates/`)  
- Einfache Deployments, Upgrades und Rollbacks  
- Versionskontrolle über Git  
- Grundstein für GitOps mit ArgoCD  

Kurz gesagt:

> Helm macht Deployments professioneller, flexibler und einfacher wartbar.

---

### 8.1 Helm-Chart erstellen

Im Projektordner wurde ein neues Chart erzeugt:

```bash
cd D:\dev\test-app
helm create test-app-chart
```

Helm erzeugt die folgende Struktur:

```
test-app-chart/
  Chart.yaml
  values.yaml
  templates/
    deployment.yaml
    service.yaml
    _helpers.tpl
```

---

#### 1. Konfiguration in `values.yaml`

In `test-app-chart/values.yaml` wurden die Werte für das Deployment definiert:

```yaml
replicaCount: 2

image:
  repository: test-app
  tag: "local"
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: 8000
```

Diese Werte steuern:

- Anzahl der Pods  
- Docker-Image der App  
- Port des Services  
- Pull-Verhalten  

---

#### 2. Deployment-Template anpassen

Die Datei `templates/deployment.yaml` wurde an die eigene Anwendung angepasst und Health-Checks übernommen (readiness & liveness Probes):

- Dynamische Namen & Labels via Helm (`fullname`, `labels`)  
- Image & Replicas aus `values.yaml`  
- Container-Port: 8000  
- `/health` wird als Probe-Endpunkt verwendet

Damit ist das Deployment vollständig template-basiert und konfigurierbar.

---

#### 3. Service-Template anpassen

In `templates/service.yaml` wurde der Kubernetes-Service templatisiert:

- Typ (`ClusterIP`) und Port (`8000`) aus `values.yaml`
- Selektiert Pods anhand von automatisch gesetzten Labels
- Service-Name wird über Helm generiert (z. B. `test-app-test-app-chart`)

Der Name ergibt sich aus:

```
<release-name>-<chart-name>
```

---

#### 4. Chart rendern (lokaler Test)

Bevor das Chart installiert wird, kann man es als plain YAML rendern:

```bash
helm template test-app ./test-app-chart
```

Damit sieht man exakt, welche Kubernetes-Objekte erzeugt werden.

---

#### 5. Image in den kind-Cluster laden

Da kind keine lokalen Images kennt:

```bash
kind load docker-image test-app:local --name dev-cluster
```

---

#### 6. Chart im Cluster installieren

Installation oder Upgrade:

```bash
helm upgrade --install test-app ./test-app-chart
```

Danach prüfen:

```bash
kubectl get pods
kubectl get svc
```

Der automatisch generierte Service-Name war z. B.:

```
test-app-test-app-chart
```

---

### 8.2 Anwendung in Kubernetes testen

Port-Forwarding:

```bash
kubectl port-forward service/test-app-test-app-chart 8000:8000
```

API erreichbar unter:

- http://localhost:8000/
- http://localhost:8000/health

---

### 8.3 Helm-Upgrade (Beispiel)

Änderung in `values.yaml`, z. B.:

```yaml
replicaCount: 3
```

Upgrade:

```bash
helm upgrade test-app ./test-app-chart
```

Pods prüfen:

```bash
kubectl get pods
```

---

### 8.4 Zusammenfassung – Vorteile des Helm-Charts

- Werte werden zentral in `values.yaml` verwaltet  
- Templates ermöglichen Wiederverwendung & klare Struktur  
- Updates erfolgen sauber über `helm upgrade`  
- Vollständig kompatibel mit ArgoCD & GitOps  
- Produktionsnahe Struktur, ideal für DevOps-Portfolios

Dieses Helm-Setup bildet die Basis für den nächsten Schritt: **GitOps mit ArgoCD**.

---

## GitOps mit ArgoCD – Automatisiertes Deployment des Helm-Charts

Nach der erfolgreichen Erstellung des Helm-Charts wurde das Projekt um **ArgoCD** erweitert, um einen vollständig GitOps-basierten Deployment-Prozess zu ermöglichen.  
GitOps bedeutet: *Der Zustand des Clusters wird ausschließlich durch das Git-Repository definiert.*  
ArgoCD überwacht das Repository und synchronisiert automatisch alle Änderungen in den Kubernetes-Cluster.

---

### Was ist ArgoCD?

ArgoCD ist ein deklaratives GitOps-Tool für Kubernetes.  
Es übernimmt:

- automatisches Anwenden von Konfigurationen aus Git  
- Health-Checks und Statusanzeigen der Ressourcen  
- visuelle Darstellung der Deployments  
- Rollback, Diff, Sync und History  
- automatisches Erkennen von Änderungen im Git-Repo  

Kurz gesagt:

> ArgoCD sorgt dafür, dass der tatsächliche Zustand im Cluster immer dem Zustand im Git-Repository entspricht.

---

### 9.1 Installation von ArgoCD im Kubernetes-Cluster

Zuerst wurde ein eigener Namespace für ArgoCD angelegt:

```bash
kubectl create namespace argocd
```

Danach erfolgte die Installation:

```bash
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Nach der Installation konnten alle Pods überprüft werden:

```bash
kubectl get pods -n argocd
```

### 9.2 Zugriff auf die ArgoCD-Weboberfläche

Die Web-UI von ArgoCD wurde über Port-Forwarding verfügbar gemacht:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Die Oberfläche ist danach erreichbar unter:

- https://localhost:8080

Das Admin-Passwort wurde aus einem Kubernetes-Secret ausgelesen:

Terminal:

```bash
kubectl get pods -n argocd
```

oder PowerShell:

```powershell
$passEncoded = kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}"
[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($passEncoded))
```

Login:
- Benutzername: `admin`
- Passwort: aus Secret

---

### 9.3 Erstellen der ersten ArgoCD Application

In der ArgoCD-UI wurde eine neue Application angelegt, die direkt auf das GitHub-Repository des Projekts zeigt.

**Wichtige Felder:**

- **Aplication Name:** `test-app`
- **Repository URL:** Git-URL des Projekts (https://github.com/mehdiprl/test-app)
- **Revision:** `main`
- **Path:** `test-app-chart` (Pfad zum Helm-Chart im Repository)
- **Cluster:** https://kubernetes.default.svc`
- **Namespace:** `default`

> ArgoCD verwendet nun dieses Helm-Chart als Quelle und erzeugt/aktualisiert die Kubernetes-Ressourcen automatisch.

---

### 9.4 Synchronisation des Deployments mit ArgoCD

Nach dem Erstellen der Application zeigte ArgoCD den Status „OutOfSync“.
Eine manuelle Synchronisation wurde durchgeführt:

- In der UI: **SNYC** klicken
- ArgoCD rendert das Helm-Chart
- Kubernetes-Deployment, Service und Pods werden automatisch erstellt

Die Ergebnisse waren unmittelbar sichtbar:

```bash
kubectl get pods
kubectl get svc
```

Damit wurde die App erfolgreich durch ArgoCD deployed.

---

### 9.5 GitOps in Aktion - Änderungen per Git ausrollen

Um den GitOps-Workflow zu testen, wurde eine Konfigurationsänderung vorgenommen.
Beispiel:

In `test-app-chart/values.yaml` wurde:

```yaml
replicaCount: 2
```

auf:

```yaml
replicaCount: 3
```

geändert.

Dann:

```bash
git add test-app-chart/values.yaml
git commit -m "Increase replicas to 3"
git push
```

ArgoCD erkannte automatisch, dass sich der Zustand im Git geändert hatte.
Nach einem erneuten SYNC (oder automatisch, falls Auto-Sync aktiviert ist):

```bash
kubectl get pods
```

Es liefen jetzt 3 Pods der Anwendung.

---

### 9.6 Optional: Autmatische Synchronisation aktivieren

In ArgoCD kann die Application so konfiguriert werden, dass jede Git-Änderung automatisch ausgerollt wird:

- Application öffnen
- „App Details / Settings“
- Sync Policy → Automatic
  - Optional: Self Heal
  - Optional: Prune

Damit entsteht ein echter GitOps-Workflow:
**Commit → Push → ArgoCD erkennt Änderung → Kubernetes wird automatisch aktualisiert.**

### 9.7 Zusammenfassung – GitOps mit ArgoCD

Durch die Integration von ArgoCD wurde das Projekt auf ein professionelles DevOps-Niveau gehoben:

- Helm-Chart als deklarative Deployment-Basis
- ArgoCD überwacht das GitHub-Repository
- Änderungen werden automatisch erkannt
- Manuelles Deployen entfällt
- Cluster-Zustand = Git-Zustand
- Visuelle Oberfläche für Health, Sync, Logs, History und Rollbacks

GitOps ist heute Standard in Kubernetes-Teams und dieses Projekt bildet einen vollständigen, realistischen GitOps-Workflow ab.


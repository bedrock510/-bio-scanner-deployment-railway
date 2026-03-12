# BioSignal Intelligence Scanner

Full-stack web application for White Glove Wellness® that analyzes a user's photo and voice recording, cross-references the signals, and generates a personalized non-diagnostic wellness report using the Claude API.

## Tech Stack

- **Frontend**: React + Tailwind CSS (Vite)
- **Backend**: Python + FastAPI
- **AI Report**: Anthropic Claude API (claude-opus-4-6)
- **Analysis**: DeepFace, OpenCV, librosa

---

## Docker Quick Start (Recommended)

The fastest way to run this anywhere. Requires only Docker Desktop — no Python or Node install needed.

```bash
cp .env.example .env
# Open .env and set ANTHROPIC_API_KEY=sk-ant-...

./start.sh      # Mac / Linux
start.bat       # Windows
```

App opens at **http://localhost:3000**. API runs at **http://localhost:8000**.

> **First build takes 5–10 minutes** — Docker downloads TensorFlow and DeepFace (~2GB). Subsequent starts take ~30 seconds from cache.

For a minimal one-page version of these instructions, see **HANDOFF.md**.

---

## Docker — Production Server

To run on a server, set `VITE_API_URL` in `.env` to the server's public address before building:

```
VITE_API_URL=https://biosignal.yourcompany.com
```

Then start in detached (background) mode:

```bash
docker compose up --build -d
```

Logs:
```bash
docker compose logs -f
```

---

## Prerequisites (running without Docker)

| Requirement | Version |
|---|---|
| Python | 3.11 |
| Node.js | 18 |
| npm | 9+ |
| Disk space | ~2GB (TensorFlow + model downloads) |
| Anthropic API key | Required — get one at console.anthropic.com |

---

## Local Development (without Docker)

### 1. Clone / unzip the project

Place this folder anywhere on your machine. No path-specific configuration needed.

### 2. Set up environment variables

```bash
cp .env.example .env
```

Open `.env` and fill in your Anthropic API key:

```
ANTHROPIC_API_KEY=sk-ant-...
```

Leave `VITE_API_URL` commented out for local development — it defaults to `http://localhost:8000`.

### 3. Start the backend (Terminal 1)

```bash
chmod +x start-backend.sh
./start-backend.sh
```

This script will:
- Create a Python virtual environment in `.venv/` (first run only)
- Install all Python dependencies from `backend/requirements.txt`
- Start the FastAPI server at `http://localhost:8000`

> **Note:** The first run may take 1–2 minutes while TensorFlow initializes. DeepFace will also download ~200MB of pre-trained models on first use — an internet connection is required for this.

### 4. Start the frontend (Terminal 2)

```bash
chmod +x start-frontend.sh
./start-frontend.sh
```

This script will:
- Install Node dependencies from `frontend/package.json` (first run only)
- Start the Vite dev server at `http://localhost:5173`

The app will be available at **http://localhost:5173**.

---

## Manual Setup (without scripts)

### Backend

```bash
# From the project root
python3 -m venv .venv
source .venv/bin/activate          # macOS/Linux
# .venv\Scripts\activate           # Windows

pip install -r backend/requirements.txt

cp .env.example .env
# Edit .env and add ANTHROPIC_API_KEY

cd backend
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

### Frontend

```bash
cd frontend
npm install
npm run dev
```

---

## Deployment — Railway (Backend) + Vercel/Netlify (Frontend)

This is the recommended production setup: backend on Railway, frontend on a static host.

### Deploy the Backend to Railway

1. Create a free account at [railway.app](https://railway.app)
2. Install the Railway CLI:
   ```bash
   npm install -g @railway/cli
   railway login
   ```
3. From the project root, initialise and deploy:
   ```bash
   cd backend
   railway init
   railway up
   ```
4. In the Railway dashboard, go to your service → **Variables** and add:
   ```
   ANTHROPIC_API_KEY=sk-ant-...
   ```
5. Railway will expose a public URL like `https://your-app.up.railway.app`. Copy it — you'll need it for the frontend.

> The `railway.json` and `Procfile` in `backend/` are already configured. Railway uses NIXPACKS and runs `uvicorn main:app --host 0.0.0.0 --port $PORT` automatically.

---

### Deploy the Frontend to Vercel

1. Create a free account at [vercel.com](https://vercel.com)
2. Install the Vercel CLI:
   ```bash
   npm install -g vercel
   ```
3. Set your backend URL in the frontend environment:
   ```bash
   cd frontend
   ```
   Create a `.env` file (do not commit this):
   ```
   VITE_API_URL=https://your-app.up.railway.app
   ```
4. Build and deploy:
   ```bash
   npm run build
   vercel --prod
   ```
   When prompted, set the **Root Directory** to `frontend` and the **Build Command** to `npm run build`.

5. In the Vercel dashboard → Project → Settings → Environment Variables, add:
   ```
   VITE_API_URL = https://your-app.up.railway.app
   ```

---

### Deploy the Frontend to Netlify

1. Create a free account at [netlify.com](https://netlify.com)
2. Install the Netlify CLI:
   ```bash
   npm install -g netlify-cli
   netlify login
   ```
3. Build the frontend:
   ```bash
   cd frontend
   VITE_API_URL=https://your-app.up.railway.app npm run build
   ```
4. Deploy:
   ```bash
   netlify deploy --prod --dir dist
   ```
5. In the Netlify dashboard → Site → Environment Variables, add:
   ```
   VITE_API_URL = https://your-app.up.railway.app
   ```
   Then trigger a redeploy so the variable takes effect.

---

### Deploy Both on Railway (Monorepo)

You can also run both services on Railway in the same project.

1. In the Railway dashboard, create a **New Project**
2. Add two services: one pointing to the `backend/` folder, one to the `frontend/` folder
3. For the frontend service, set:
   - Build command: `npm run build`
   - Start command: `npx serve dist -l $PORT`
   - Environment variable: `VITE_API_URL=https://<your-backend-service>.up.railway.app`
4. For the backend service, set:
   - Environment variable: `ANTHROPIC_API_KEY=sk-ant-...`

---

## Environment Variable Reference

| Variable | Where | Required | Description |
|---|---|---|---|
| `ANTHROPIC_API_KEY` | Backend `.env` or host dashboard | Yes | Your Anthropic API key |
| `VITE_API_URL` | Frontend `.env` or host dashboard | Only for offsite | Full URL of the deployed backend (no trailing slash) |
| `PORT` | Set by host automatically | No | Port for the backend server — handled by Railway/Heroku/etc. |

---

## Project Structure

```
biosignal-scanner-deploy/
├── .env.example              ← copy to .env and fill in keys
├── .gitignore
├── start-backend.sh          ← run this first (local dev)
├── start-frontend.sh         ← run this second (local dev)
├── README.md
│
├── backend/
│   ├── main.py               ← FastAPI app entry point
│   ├── requirements.txt      ← Python dependencies
│   ├── railway.json          ← Railway deployment config
│   ├── Procfile              ← Heroku/Railway process file
│   ├── analysis/
│   │   ├── facial.py         ← DeepFace + OpenCV face analysis
│   │   ├── audio.py          ← librosa audio analysis
│   │   └── fusion.py         ← combines facial + audio scores
│   └── report/
│       └── generator.py      ← Claude API report generation
│
└── frontend/
    ├── index.html            ← Vite entry point
    ├── package.json
    ├── vite.config.js
    ├── tailwind.config.js
    └── src/
        ├── App.jsx           ← main app (all screens)
        ├── main.jsx
        ├── index.css
        └── components/       ← legacy component files
```

---

## API Reference

### POST /analyze

Accepts `multipart/form-data`:

| Field | Type | Required | Default | Description |
|---|---|---|---|---|
| `photo` | file | Yes | — | JPG or PNG face photo |
| `audio` | file | Yes | — | WAV voice recording (20–30 sec) |
| `symptoms` | string | No | `""` | Free-text symptom description |
| `sleep_hours` | float | No | `7` | Hours of sleep last night |
| `stress_level` | int | No | `5` | Self-reported stress (1–10) |
| `primary_goal` | string | No | `""` | Wellness goal |

**Success response:**
```json
{
  "emergency": false,
  "report": "Generated wellness report text...",
  "scores": {
    "stress_load": 0.45,
    "nervous_system_balance": 0.62,
    "recovery_capacity": 0.38,
    "breath_stability": 0.71,
    "cognitive_fluency": 0.58,
    "emotional_variability": 0.44,
    "vocal_strength_stability": 0.66,
    "facial_tension_load": 0.29
  },
  "flags": {
    "possible_sleep_debt_pattern": false,
    "possible_high_sympathetic_tone": false,
    "possible_low_recovery_pattern": false
  },
  "session_id": "uuid-here"
}
```

**Emergency response** (triggered by red-flag symptom keywords):
```json
{
  "emergency": true,
  "message": "Based on what you've shared, please contact emergency services..."
}
```

---

## Troubleshooting

**Backend won't start — `ModuleNotFoundError`**
Make sure the virtual environment is activated and dependencies are installed:
```bash
source .venv/bin/activate
pip install -r backend/requirements.txt
```

**Backend slow on first request**
Normal. TensorFlow takes 1–2 minutes to initialize on cold start. Subsequent requests are fast.

**Frontend can't reach backend — CORS or network error**
- Local: confirm the backend is running on port 8000
- Deployed: confirm `VITE_API_URL` is set to the correct backend URL (no trailing slash) and the frontend was rebuilt after setting it

**DeepFace model download fails**
The backend requires an internet connection on first use to download ~200MB of pre-trained models. On Railway this happens automatically during the first request.

**`ANTHROPIC_API_KEY` not found**
The backend loads `.env` from the project root. Make sure the file exists and contains the key. On Railway/Vercel/Netlify, set it as an environment variable in the dashboard instead.

---

## Deployment — Company / On-Premises Server

Use this guide when deploying to a Linux server your company controls (Ubuntu 20.04+ or Debian 11+ recommended). The setup uses **nginx** as a reverse proxy and **systemd** to keep the backend running as a managed service.

### Architecture Overview

```
Internet
    │
    ▼
[ nginx :443 ]  ← handles HTTPS, serves frontend static files
    │
    ├── /          → serves frontend/dist/ (static HTML/JS/CSS)
    └── /analyze   → proxies to backend on localhost:8000
```

The backend never faces the internet directly. nginx handles TLS termination and forwards API requests internally.

---

### Step 1 — Server Requirements

Minimum recommended spec:
- 2 vCPU, 4GB RAM (8GB preferred — TensorFlow is memory-hungry)
- 10GB disk (2GB for models + room for logs)
- Ubuntu 22.04 LTS or Debian 12
- Ports 80 and 443 open in your firewall
- A domain name or internal hostname pointing to the server

---

### Step 2 — Install System Dependencies

SSH into the server and run:

```bash
sudo apt update && sudo apt upgrade -y

# Python, pip, venv
sudo apt install -y python3 python3-pip python3-venv

# Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# nginx
sudo apt install -y nginx

# Optional: system libs needed by OpenCV and librosa
sudo apt install -y libxcb1 libglib2.0-0 libsm6 libxrender1 libfontconfig1 \
    libsndfile1 ffmpeg
```

Verify:
```bash
python3 --version   # should be 3.9+
node --version      # should be 18+
nginx -v
```

---

### Step 3 — Copy the Project to the Server

From your local machine:

```bash
scp -r /Users/admin/Documents/biosignal-scanner-deploy youruser@your-server-ip:/opt/biosignal-scanner
```

Or use git if you have a repo:
```bash
# On the server
cd /opt
sudo git clone https://your-repo-url biosignal-scanner
sudo chown -R youruser:youruser /opt/biosignal-scanner
```

---

### Step 4 — Configure Environment Variables

```bash
cd /opt/biosignal-scanner
cp .env.example .env
nano .env
```

Set your key:
```
ANTHROPIC_API_KEY=sk-ant-...
```

Lock down the file so only the service user can read it:
```bash
chmod 600 .env
```

---

### Step 5 — Set Up the Python Backend

```bash
cd /opt/biosignal-scanner

# Create virtual environment
python3 -m venv .venv
source .venv/bin/activate

# Install dependencies
pip install -r backend/requirements.txt
```

Test that it starts:
```bash
cd backend
uvicorn main:app --host 127.0.0.1 --port 8000
# Press Ctrl+C once confirmed working
```

---

### Step 6 — Create a systemd Service for the Backend

This keeps the backend running permanently, restarts it on crash, and starts it on server reboot.

```bash
sudo nano /etc/systemd/system/biosignal-backend.service
```

Paste the following (replace `youruser` with your actual Linux username):

```ini
[Unit]
Description=BioSignal Scanner Backend
After=network.target

[Service]
User=youruser
WorkingDirectory=/opt/biosignal-scanner/backend
EnvironmentFile=/opt/biosignal-scanner/.env
ExecStart=/opt/biosignal-scanner/.venv/bin/uvicorn main:app --host 127.0.0.1 --port 8000 --workers 2
Restart=always
RestartSec=5
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

Enable and start the service:

```bash
sudo systemctl daemon-reload
sudo systemctl enable biosignal-backend
sudo systemctl start biosignal-backend

# Verify it's running
sudo systemctl status biosignal-backend
```

View logs at any time:
```bash
sudo journalctl -u biosignal-backend -f
```

---

### Step 7 — Build the Frontend

```bash
cd /opt/biosignal-scanner/frontend

# Install dependencies
npm install

# Set the backend URL — this must be your server's public domain or IP
echo "VITE_API_URL=https://biosignal.yourcompany.com" > .env

# Build static files
npm run build
```

Output goes to `frontend/dist/`. nginx will serve this directory.

---

### Step 8 — Configure nginx

Create a new nginx site config:

```bash
sudo nano /etc/nginx/sites-available/biosignal-scanner
```

**HTTP only (no SSL — use this first to verify it works):**

```nginx
server {
    listen 80;
    server_name biosignal.yourcompany.com;

    # Serve the React frontend
    root /opt/biosignal-scanner/frontend/dist;
    index index.html;

    # Allow this app to be embedded in an iframe on your company domain.
    # Replace https://www.yourcompany.com with the actual parent page URL.
    # Use * to allow any site to embed it (less secure).
    add_header Content-Security-Policy "frame-ancestors 'self' https://www.yourcompany.com";

    # All non-API routes go to React (SPA routing)
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Proxy API calls to the FastAPI backend
    location /analyze {
        proxy_pass http://127.0.0.1:8000/analyze;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

        # Allow large file uploads (photos + audio)
        client_max_body_size 50M;

        # Long timeout — analysis can take 30-60 seconds
        proxy_read_timeout 120s;
        proxy_send_timeout 120s;
    }
}
```

Enable the site and test:

```bash
sudo ln -s /etc/nginx/sites-available/biosignal-scanner /etc/nginx/sites-enabled/
sudo nginx -t          # should print "syntax is ok"
sudo systemctl reload nginx
```

Visit `http://biosignal.yourcompany.com` — the app should load.

---

### Step 9 — Add HTTPS with Let's Encrypt (Certbot)

> Skip this step if you are on an internal network without a public domain. Use a self-signed cert or your company's internal CA instead (see below).

```bash
sudo apt install -y certbot python3-certbot-nginx

sudo certbot --nginx -d biosignal.yourcompany.com
```

Certbot will automatically update your nginx config with SSL settings and redirect HTTP to HTTPS. Certificates auto-renew via a cron job certbot installs.

To test auto-renewal:
```bash
sudo certbot renew --dry-run
```

---

### Step 9 (Internal Network) — Self-Signed Certificate

If the server is on a private network with no public domain:

```bash
sudo mkdir -p /etc/nginx/ssl

sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/nginx/ssl/biosignal.key \
  -out /etc/nginx/ssl/biosignal.crt \
  -subj "/CN=biosignal.internal/O=White Glove Wellness"
```

Update your nginx config:

```nginx
server {
    listen 443 ssl;
    server_name biosignal.internal;

    ssl_certificate     /etc/nginx/ssl/biosignal.crt;
    ssl_certificate_key /etc/nginx/ssl/biosignal.key;

    root /opt/biosignal-scanner/frontend/dist;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location /analyze {
        proxy_pass http://127.0.0.1:8000/analyze;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        client_max_body_size 50M;
        proxy_read_timeout 120s;
        proxy_send_timeout 120s;
    }
}

server {
    listen 80;
    server_name biosignal.internal;
    return 301 https://$host$request_uri;
}
```

```bash
sudo nginx -t && sudo systemctl reload nginx
```

Users will see a browser warning for self-signed certs. You can suppress this by installing your company's internal CA certificate on each client machine, or by using your company's internal certificate authority to sign the cert instead.

---

### Step 10 — Configure the Firewall

Allow only the ports nginx needs. Keep port 8000 closed to the outside — only nginx should talk to it internally.

```bash
sudo ufw allow OpenSSH
sudo ufw allow 'Nginx Full'   # opens 80 and 443
sudo ufw enable
sudo ufw status
```

Verify port 8000 is NOT publicly accessible:
```bash
sudo ufw status | grep 8000   # should return nothing
```

---

### Updating the App

When you push code changes, here is the update sequence:

```bash
# Pull latest code
cd /opt/biosignal-scanner
git pull

# Rebuild frontend
cd frontend
npm install
VITE_API_URL=https://biosignal.yourcompany.com npm run build

# Reinstall backend deps if requirements changed
cd ..
source .venv/bin/activate
pip install -r backend/requirements.txt

# Restart the backend service
sudo systemctl restart biosignal-backend
sudo systemctl status biosignal-backend
```

nginx does not need to restart for frontend changes since it serves files from disk.

---

### Service Management Cheatsheet

| Task | Command |
|---|---|
| Check backend status | `sudo systemctl status biosignal-backend` |
| View live backend logs | `sudo journalctl -u biosignal-backend -f` |
| Restart backend | `sudo systemctl restart biosignal-backend` |
| Stop backend | `sudo systemctl stop biosignal-backend` |
| Reload nginx config | `sudo systemctl reload nginx` |
| Test nginx config | `sudo nginx -t` |
| Renew SSL cert | `sudo certbot renew` |

---

## Embedding as an iframe

The app can be embedded on any page of your company website using a standard `<iframe>`. Two requirements must be met:

1. **Both the parent page and the app must be served over HTTPS.** Browsers block microphone access on mixed or insecure origins.
2. **The iframe must declare `allow="microphone"`** so the browser grants the audio recording permission to the embedded app.

### Basic embed code

Paste this on any page where you want the scanner to appear:

```html
<iframe
  src="https://biosignal.yourcompany.com"
  allow="microphone"
  width="100%"
  height="900"
  frameborder="0"
  style="border: none; border-radius: 8px;"
  title="BioSignal Intelligence Scanner"
></iframe>
```

### Responsive full-height embed

For a seamless look that fills the viewport height:

```html
<style>
  .biosignal-frame-wrap {
    position: relative;
    width: 100%;
    height: 90vh;
    min-height: 700px;
  }
  .biosignal-frame-wrap iframe {
    position: absolute;
    inset: 0;
    width: 100%;
    height: 100%;
    border: none;
  }
</style>

<div class="biosignal-frame-wrap">
  <iframe
    src="https://biosignal.yourcompany.com"
    allow="microphone"
    title="BioSignal Intelligence Scanner"
  ></iframe>
</div>
```

### nginx — allowing iframe embedding

By default browsers block framing unless the server explicitly permits it. The nginx config in Step 8 already includes the required header. If you need to allow multiple parent domains, list them space-separated:

```nginx
add_header Content-Security-Policy "frame-ancestors 'self' https://www.yourcompany.com https://app.yourcompany.com";
```

To allow embedding from **any** domain (e.g. for a public-facing tool):

```nginx
add_header Content-Security-Policy "frame-ancestors *";
```

### What works inside the iframe

| Feature | Works in iframe? | Notes |
|---|---|---|
| Photo upload | Yes | Standard file input |
| Audio file upload | Yes | Standard file input |
| Live audio recording | Yes | Requires `allow="microphone"` on the iframe |
| Report display | Yes | Fully functional |
| Print / download report | Yes | `window.print()` targets the iframe content |

### Troubleshooting iframe issues

**Microphone not working inside iframe**
Make sure the `allow="microphone"` attribute is on the `<iframe>` tag. Without it, the browser silently blocks `getUserMedia()` regardless of what the user clicks.

**App refuses to load in iframe ("refused to connect")**
The `Content-Security-Policy: frame-ancestors` header is missing or set to `'none'`. Check your nginx config and reload: `sudo systemctl reload nginx`.

**Works in Chrome but not Safari**
Safari requires both the parent page and the iframe source to be on HTTPS and the same eTLD+1, or the iframe source must be explicitly listed in `frame-ancestors`. Self-signed certs can cause issues — use a valid certificate (Let's Encrypt or company CA).

**Scroll issues on mobile**
Add `scrolling="yes"` to the iframe tag and ensure the wrapper has a fixed height, not `height: auto`.

---

## License

Proprietary — White Glove Wellness®

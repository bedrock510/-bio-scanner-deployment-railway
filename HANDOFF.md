# BioSignal Scanner — Handoff

## What this is

A wellness intelligence tool built for White Glove Wellness® that:
- Accepts a face photo and a short voice recording
- Analyzes biometric signals using DeepFace and librosa
- Generates a personalized, non-diagnostic wellness report via the Claude AI API

## What you need

- [ ] **Docker Desktop** — https://www.docker.com/products/docker-desktop
- [ ] **Anthropic API key** — https://console.anthropic.com (you pay per report generated)
- [ ] Internet connection on first run (~200MB of AI models download automatically)

That's it. No Python, no Node, no manual installs.

---

## How to run it

**Step 1 — Copy the environment file**
```
cp .env.example .env        (Mac / Linux)
copy .env.example .env      (Windows)
```

**Step 2 — Add your API key**

Open `.env` and replace `your_anthropic_api_key_here` with your real key:
```
ANTHROPIC_API_KEY=sk-ant-...
```

**Step 3 — Start**
```
./start.sh      (Mac / Linux)
start.bat       (Windows)
```

Or directly:
```
docker compose up --build
```

**Step 4 — Open the app**

http://localhost:3000

---

## First run

The first build takes **5–10 minutes**. Docker is downloading and compiling TensorFlow, DeepFace, and other AI libraries. This only happens once. After the first build, starting takes ~30 seconds.

---

## Stopping the app

```
Ctrl+C      — stops containers (keeps data)
docker compose down     — stops and removes containers
```

---

## Restarting after a machine reboot

```
./start.sh
```

Docker will not rebuild — it reuses the cached image. Starts in ~30 seconds.

---

## API billing

Every time a user completes a scan, one Claude API call is made. The cost is charged to the account that owns the `ANTHROPIC_API_KEY` in `.env`.

**API key owner / billing contact:** ___________________________

---

## Deploying to a server instead of running locally

See **README.md → Deployment — Company / On-Premises Server** for the full nginx + systemd guide.

For Docker on a server, set `VITE_API_URL` in your `.env` to the server's public URL before building:

```
VITE_API_URL=https://biosignal.yourcompany.com
```

Then run:
```
docker compose up --build -d
```

The `-d` flag runs in the background.

---

## Troubleshooting

**"Docker is not running"** — Open Docker Desktop and wait for it to finish starting before running the script.

**"ANTHROPIC_API_KEY not set"** — Make sure `.env` exists (not just `.env.example`) and the key is filled in.

**Backend crashes on first request** — Normal. TensorFlow sometimes takes 60–90 seconds to initialize on first use. Wait and retry.

**Port 3000 or 8000 already in use** — Something else is using that port. Stop it, or edit `docker-compose.yml` to change the port mapping (e.g. `"3001:80"`).

---

## Support / handoff contact

**Developer:** ___________________________

**Date handed off:** ___________________________

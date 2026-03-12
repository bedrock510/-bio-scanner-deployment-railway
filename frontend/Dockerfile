# Stage 1 — Build the React app
FROM node:18-alpine AS builder

WORKDIR /app

# Install dependencies (cached layer)
COPY package.json package-lock.json ./
RUN npm ci

# VITE_API_URL is baked into the JS bundle at build time.
# It must be the URL the end-user's browser can reach — not a Docker internal hostname.
# Default: http://localhost:8000 (works when running docker compose locally)
# Override for production: docker build --build-arg VITE_API_URL=https://api.yourcompany.com
ARG VITE_API_URL=http://localhost:8000
ENV VITE_API_URL=$VITE_API_URL

COPY . .
RUN npm run build

# Stage 2 — Serve the built files with nginx
FROM nginx:1.27-alpine

COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

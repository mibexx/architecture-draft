# Build stage
FROM node:20-alpine as builder

WORKDIR /app

# Kopiere package.json und package-lock.json
COPY app/package*.json ./

# Installiere Abhängigkeiten
RUN npm ci

# Kopiere den Rest der Anwendung
COPY app/ .

# Baue die Anwendung
RUN npm run build

# Production stage
FROM node:20-alpine

WORKDIR /app

# Kopiere die gebaute Anwendung vom Builder
COPY --from=builder /app/.output ./

# Exponiere den Port
EXPOSE 3000

# Setze die Umgebungsvariable für die Produktion
ENV NODE_ENV=production

# Starte die Anwendung
CMD ["node", "server/index.mjs"] 
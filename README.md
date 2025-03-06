# Architecture Draft

Eine moderne Web-Applikation basierend auf Nuxt 3 und Vue.js, entwickelt mit TypeScript und dem @nuxt/ui Framework.

## 🚀 Features

- Moderne und responsive Benutzeroberfläche mit @nuxt/ui
- TypeScript Integration für verbesserte Entwicklererfahrung
- PDF-Export Funktionalität mit jspdf und html2canvas
- Docker-Support für einfache Deployment-Prozesse

## 📋 Voraussetzungen

- Node.js (Version 18 oder höher)
- npm oder yarn
- Docker (optional, für Container-Deployment)

## 🛠 Installation

1. Repository klonen:
```bash
git clone git@github.com:mibexx/architecture-draft.git
cd architecture-draft/app
```

2. Abhängigkeiten installieren:
```bash
npm install
# oder
yarn install
```

## 💻 Entwicklung

Starten Sie den Entwicklungsserver:
```bash
npm run dev
# oder
yarn dev
```

Die Anwendung ist dann unter `http://localhost:3000` verfügbar.

## 🏗 Build

Erstellen Sie eine Produktionsversion:
```bash
npm run build
# oder
yarn build
```

## 🐳 Docker

Build und Start mit Docker:
```bash
docker build -t architecture-draft .
docker run -p 3000:3000 architecture-draft
```

## 🔧 Konfiguration

Die Hauptkonfiguration befindet sich in:
- `nuxt.config.ts` - Nuxt Konfiguration
- `tsconfig.json` - TypeScript Konfiguration
- `Dockerfile` - Docker Build-Konfiguration

## 📁 Projektstruktur

```
app/
├── components/     # Wiederverwendbare Vue-Komponenten
├── layouts/        # Layout-Komponenten
├── pages/         # Anwendungsrouten
├── public/        # Statische Assets
├── server/        # Server-seitige Funktionalität
└── app.vue        # Haupt-App-Komponente
```

## 📄 Lizenz

Dieses Projekt ist unter der MIT-Lizenz lizenziert - siehe die [LICENSE](LICENSE) Datei für Details.
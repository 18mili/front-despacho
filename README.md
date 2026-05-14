# 🚚 Front Despacho — Innovatech Chile

Aplicación frontend del sistema de gestión de despachos, construida con **React + Vite + Tailwind CSS**.

## 🏗️ Arquitectura de Contenedorización

| Etapa | Imagen base | Propósito |
|-------|-------------|-----------|
| `builder` | `node:20-alpine` | Instala dependencias y compila el proyecto |
| `production` | `nginx:1.25-alpine` | Sirve los archivos estáticos compilados |

**Buenas prácticas:** multi-stage build · usuario no-root · health check · headers de seguridad

---

## 🚀 Cómo ejecutar localmente

```bash
# 1. Clonar el repositorio
git clone https://github.com/TU_USUARIO/front-despacho.git
cd front-despacho

# 2. Construir y levantar
docker compose up --build -d

# 3. Abrir en el navegador → http://localhost:80

# Detener
docker compose down
```

---

## 🔄 Pipeline CI/CD

Se activa con push a la rama `deploy`. Flujo: **build → push Docker Hub → deploy EC2**

### Secrets requeridos en GitHub:

| Secret | Descripción |
|--------|-------------|
| `DOCKERHUB_USERNAME` | Usuario de Docker Hub |
| `DOCKERHUB_TOKEN` | Token de acceso Docker Hub |
| `EC2_FRONTEND_HOST` | IP pública EC2 frontend |
| `EC2_USER` | Usuario SSH (ec2-user) |
| `EC2_SSH_KEY` | Clave privada SSH (.pem) |

---

## 📁 Estructura

```
frontend/
├── .github/workflows/deploy.yml   ← Pipeline CI/CD
├── src/                           ← Código fuente React
├── Dockerfile                     ← Multi-stage build
├── docker-compose.yml             ← Stack de servicios
├── nginx.conf                     ← Config servidor web
└── README.md
```

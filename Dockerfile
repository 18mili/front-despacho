# ================================
# ETAPA 1: BUILD con Node
# ================================
FROM node:20-alpine AS builder

WORKDIR /app

# Copiar dependencias primero (mejor cache de capas)
COPY package*.json ./
RUN npm ci --only=production=false

# Copiar código fuente y compilar
COPY . .
RUN npm run build

# ================================
# ETAPA 2: PRODUCCIÓN con Nginx
# ================================
FROM nginx:1.25-alpine AS production

# Crear usuario no-root por seguridad
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

# Copiar archivos compilados desde etapa builder
COPY --from=builder /app/dist /usr/share/nginx/html

# Copiar configuración de Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Ajustar permisos para usuario no-root
RUN chown -R appuser:appgroup /usr/share/nginx/html && \
    chown -R appuser:appgroup /var/cache/nginx && \
    chown -R appuser:appgroup /var/log/nginx && \
    touch /var/run/nginx.pid && \
    chown -R appuser:appgroup /var/run/nginx.pid

USER appuser

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget -qO- http://localhost:80/ || exit 1

CMD ["nginx", "-g", "daemon off;"]

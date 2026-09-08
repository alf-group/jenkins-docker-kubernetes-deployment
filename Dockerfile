# Fase 1: Build dell'applicazione
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Fase 2: Server Nginx per servire l'applicazione statica
FROM nginx:alpine-slim
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
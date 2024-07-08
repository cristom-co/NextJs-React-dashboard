# Etapa 1: Construcción
FROM node:20-alpine AS build

# Establece el directorio de trabajo
WORKDIR /app

# Copia los archivos package.json y package-lock.json
COPY package*.json ./

# Instala las dependencias
RUN npm install

# Copia el resto del código de la aplicación
COPY . .

# Construye la aplicación
RUN npm run build

# Etapa 2: Producción
FROM node:20-alpine

# Establece el directorio de trabajo
WORKDIR /app

# Copia las dependencias instaladas desde la etapa de construcción
COPY --from=build /app/node_modules ./node_modules

# Copia el código construido desde la etapa de construcción
COPY --from=build /app/.next ./.next
COPY --from=build /app/public ./public
COPY --from=build /app/package*.json ./

# Expone el puerto en el que se ejecutará la aplicación
EXPOSE 3000

# Comando por defecto para iniciar la aplicación
CMD ["npm", "start"]

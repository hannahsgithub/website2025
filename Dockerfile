# 1. Use Node 20, Alpine for small footprint
FROM node:20-alpine AS deps

WORKDIR /app

# 2. Copy just package manifests and install
COPY package.json package-lock.json ./
RUN npm ci

# 3. Dev image: mount code on top, reuse the deps layer
FROM node:20-alpine AS dev
WORKDIR /app

COPY --from=deps /app/node_modules ./node_modules
EXPOSE 5173

# 4. Default command for dev
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]
# --- Next.js (frontend) multi-stage Dockerfile ---
# Base image for installing dependencies
FROM node:20-alpine AS deps
WORKDIR /app
# Install libc6-compat for some Next.js deps
RUN apk add --no-cache libc6-compat
COPY package.json package-lock.json* ./
# Prefer npm ci when lockfile exists, fallback to npm install
RUN if [ -f package-lock.json ]; then npm ci; else npm install; fi

# Build stage
FROM node:20-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
ENV NEXT_TELEMETRY_DISABLED=1
RUN npm run build

# Production runtime (standalone output)
FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1
# Create a non-root user
RUN addgroup -g 1001 -S nodejs && adduser -S nextjs -u 1001
# Copy the standalone build output
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/public ./public
COPY --from=builder /app/next.config.js ./next.config.js
# Expose Next.js port
EXPOSE 3000
USER 1001
CMD ["node", "server.js"]

# Development stage (hot reload)
FROM node:20-alpine AS dev
WORKDIR /app
RUN apk add --no-cache libc6-compat
COPY package.json package-lock.json* ./
RUN if [ -f package-lock.json ]; then npm ci; else npm install; fi
COPY . .
ENV NEXT_TELEMETRY_DISABLED=1
EXPOSE 3000
CMD ["npm", "run", "dev"]

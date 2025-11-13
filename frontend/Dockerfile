# --- Build Stage -----------------------------------------------------------
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy source code
COPY . .

# Build the application (Next.js)
RUN npm run build

# --- Production Runner Stage -----------------------------------------------
FROM node:20-alpine AS runner

WORKDIR /app

# Create non-root user
RUN addgroup --system --gid 1001 nodejs \
    && adduser --system --uid 1001 nextjs

# Copy Next.js build output
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

# Optional: Copy public folder if it exists
RUN mkdir -p ./public
COPY --from=builder /app/public ./public 2>/dev/null || true

USER nextjs

EXPOSE 3000

ENV PORT=3000
ENV HOSTNAME=0.0.0.0

CMD ["npm", "start"]

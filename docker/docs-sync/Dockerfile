FROM node:22-alpine
WORKDIR /app
COPY package.json ./
RUN npm install --production --no-audit --no-fund
COPY sync.js ./
CMD ["node", "sync.js"]

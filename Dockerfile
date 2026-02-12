# Use the official Puppeteer image (includes Chrome and all dependencies)
FROM ghcr.io/puppeteer/puppeteer:latest

# Switch to root to ensure proper permissions
USER root

WORKDIR /usr/src/app

# Copy package files and install
COPY package*.json ./
RUN npm install

# Copy all your project files
COPY . .

# Set permissions for the WhatsApp session folder
RUN mkdir -p .wwebjs_auth && chmod -R 777 .wwebjs_auth

# Tell Puppeteer exactly where the built-in Chrome is
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-stable

EXPOSE 3001

CMD ["node", "server.js"]
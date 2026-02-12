# Use the official Puppeteer image which includes Chrome and all dependencies
FROM ghcr.io/puppeteer/puppeteer:latest

# Switch to root to ensure we have permissions to run the app
USER root

# Create and set the working directory
WORKDIR /usr/src/app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy your source code
COPY . .

# Set permissions for the auth folder (where WhatsApp saves your login)
RUN mkdir -p .wwebjs_auth && chmod -R 777 .wwebjs_auth

# Tell Puppeteer where the built-in Chrome is located
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-stable

# Start the application
EXPOSE 3001
CMD ["node", "server.js"]
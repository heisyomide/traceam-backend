# Use a version of Node that comes with Chrome dependencies pre-installed
FROM ghcr.io/puppeteer/puppeteer:latest

# Switch to root to handle permissions
USER root

# Set the working directory
WORKDIR /usr/src/app

# Copy package files and install
COPY package*.json ./
RUN npm install

# Copy the rest of your code
COPY . .

# Expose the port
EXPOSE 3001

# Start the application
CMD ["node", "server.js"]
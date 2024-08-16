# Base image for Node-RED
FROM nodered/node-red:4.0.2-debian

# Switch to root user for setup
USER root

# Set working directory for the container
WORKDIR /app

# Copy package.json and package-lock.json for dependency installation
COPY node-red/data/package*.json ./

# Install Node.js dependencies with specific options
RUN npm install --unsafe-perm --no-update-notifier --no-fund --only=production

# Copy application-specific configuration files
COPY node-red/data/settings.js node-red/data/flows.json node-red/data/flows_cred.json ./

# Switch back to the Node-RED user
USER node-red

# Set the working directory for Node-RED
WORKDIR /data

# Expose the port that Node-RED will use
EXPOSE 1880

# Start Node-RED
CMD ["npm", "start"]

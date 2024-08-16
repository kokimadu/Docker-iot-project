#!/bin/bash

# Default configuration flag
CONFIGURE=false

# Parse command-line options
while getopts "c" opt; do
    case $opt in
        c) CONFIGURE=true ;;
        *) echo "Usage: $0 [-c]" && exit 1 ;;
    esac
done

# Start Docker containers
echo "Starting Docker containers..."
docker-compose up -d

# Check if configuration is requested
if $CONFIGURE; then
    echo "Configuring InfluxDB..."

    # Prompt for InfluxDB credentials
    read -p "Administrator username: " kushani
    read -sp "Password: " kushani1
    echo

    # Execute configuration command
    curl -s -XPOST 'http://localhost:8086/query' \
        --data-urlencode "q=CREATE USER $admin_username WITH PASSWORD '$admin_password' WITH ALL PRIVILEGES" \
        && echo "InfluxDB user created successfully." \
        || echo "Failed to create InfluxDB user."
fi

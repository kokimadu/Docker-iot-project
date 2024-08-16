#!/bin/bash

# Define backup directories and container names
BACKUP_DIR=$(pwd)/backups
declare -A CONTAINERS=(
    ["influxdb"]="/var/lib/influxdb"
    ["grafana"]="/var/lib/grafana"
    ["node-red"]="/data"
    ["mosquitto"]="/mosquitto"
)

echo "Restoring backed-up volumes will overwrite current data in Docker volumes."
echo "Containers will be restarted after the restore."

# Prompt user for confirmation
read -r -p "Are you sure you want to continue? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "Ensuring containers are up..."
    docker-compose up -d

    echo "Restoring data from backups..."

    # Function to restore data for a container
    restore_container() {
        local container=$1
        local backup_path="$BACKUP_DIR/$container"
        local container_volume="${CONTAINERS[$container]}"

        if [ -d "$backup_path" ]; then
            echo "Restoring $container..."
            docker run --rm --volumes-from "$container" -v "$backup_path:/backup" ubuntu bash -c "tar xvf /backup/backup.tar -C $container_volume"
        else
            echo "Backup directory for $container not found: $backup_path"
        fi
    }

    # Iterate over containers and restore data
    for container in "${!CONTAINERS[@]}"; do
        restore_container "$container"
    done

    echo "Shutting down containers..."
    docker-compose down

    echo "Restarting containers..."
    ./run.sh

    echo "Restore complete!"
else
    echo "Operation aborted."
    exit 1
fi

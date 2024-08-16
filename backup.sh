#!/bin/bash

# Base directory for backups
BACKUP_BASE_DIR="$(pwd)/backups"

# Define containers and their respective directories to back up
containers=(
    "influxdb:/var/lib/influxdb"
    "grafana:/var/lib/grafana"
    "node-red:/data"
    "mosquitto:/mosquitto"
)

# Function to perform backup
perform_backup() {
    local container_name=$1
    local container_dir=$2
    local backup_dir="${BACKUP_BASE_DIR}/${container_name}"

    # Ensure backup directory exists
    mkdir -p "${backup_dir}"

    # Execute the backup using docker
    docker run --rm --volumes-from "${container_name}" -v "${backup_dir}:/backup" ubuntu tar -cvf "/backup/backup.tar" "${container_dir}"
}

# Loop through each container and back up the specified directories
for container in "${containers[@]}"; do
    IFS=":" read -r name dir <<< "${container}"
    perform_backup "${name}" "${dir}"


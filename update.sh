#!/bin/bash

# Set the directory
DIR="/opt/aethir"
BUILD_DIR="$DIR/build"

# Stop the service
systemctl stop container-aethir-checker-node.service

# Ensure the script is run from the correct directory
cd $DIR || exit 1

# Step 1: Remove the existing build directory
echo "Removing the existing build directory..."
rm -rf $BUILD_DIR

# Step 2: Download the latest version of the build directory from the git repo
echo "Pulling the latest changes from the git repository..."
git fetch origin
git checkout origin/main -- build/

# Step 3: Build the container based on the files in the build directory
echo "Building the container..."
podman-compose -f $BUILD_DIR/podman-compose.yml build

# Start the service
systemctl start container-aethir-checker-node.service

echo "Upgrade process completed, here is the log:"
podman exec -it aethir-checker-node tail -f -n 25 /opt/aethir/log/server.log

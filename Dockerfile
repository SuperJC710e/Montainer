# Use a smaller base image for Python 3.12
FROM python:3.12-slim AS base

# Metadata about the image
LABEL authors="WasinUddy"

# Set the working directory
WORKDIR /app

# Install system dependencies in one layer to reduce image size
RUN apt-get update \
    && apt-get install -y \
    wget \
    unzip \
    libcurl4 \
    zip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies in one layer
RUN pip install --no-cache-dir pydantic_settings fastapi uvicorn[standard]

# Create necessary directories
RUN mkdir -p instance configs
RUN mkdir -p /app/instance/worlds # Create necessary directories for volume mounts
# TODO: Add mount points for behavior_packs, resource_packs, etc.

# Copy only the necessary files to the container
# This should ideally be optimized based on the actual structure of your project
COPY bedrock_server/ /app/instance
COPY backend/ /app/

# Expose the required port
EXPOSE 8000
EXPOSE 19132/udp

# Define the entry point for the container
CMD ["python", "main.py"]
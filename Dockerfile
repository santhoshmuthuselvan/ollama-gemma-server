# Use Ubuntu base image
FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install curl, nodejs, and npm
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Set working directory
WORKDIR /app

# Copy package.json
COPY package.json .

# Install dependencies
RUN npm install

# Copy application files
COPY server.js .
COPY start.sh .

# Make start script executable
RUN chmod +x start.sh

# Environment variables for Ollama
ENV OLLAMA_HOST=0.0.0.0

# Pull model during build (requires starting server temporarily)
RUN ollama serve & sleep 5 && ollama pull gemma:2b && pkill ollama

# Expose the API port
EXPOSE 10000

# Start command
CMD ["./start.sh"]

#!/bin/bash

# Ensure MODEL_NAME is set
MODEL_NAME=${MODEL_NAME:-"gemma:2b"}

echo "Starting Ollama server in background..."
ollama serve &

# Wait for Ollama to be ready with retry logic
echo "Waiting for Ollama to initialize..."
MAX_RETRIES=30
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
  if curl -s http://localhost:11434/api/tags > /dev/null; then
    echo "Ollama is ready."
    break
  fi
  RETRY_COUNT=$((RETRY_COUNT + 1))
  echo "Still waiting for Ollama... ($RETRY_COUNT/$MAX_RETRIES)"
  sleep 2
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
  echo "Error: Ollama failed to start after $MAX_RETRIES retries."
  exit 1
fi

# Pull the model at runtime
echo "Pulling model: $MODEL_NAME (this may take a few minutes)..."
if ollama pull $MODEL_NAME; then
  echo "Model $MODEL_NAME pulled successfully."
else
  echo "Error: Failed to pull model $MODEL_NAME."
  exit 1
fi

# Start the Node.js application
echo "Starting Express server on port ${PORT:-8080}..."
npm start

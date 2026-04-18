#!/bin/bash

# Start Ollama in the background
echo "Starting Ollama server..."
ollama serve &

# Wait for Ollama to be available
echo "Waiting for Ollama to initialize..."
until curl -s http://localhost:11434/api/tags > /dev/null; do
  sleep 2
done

echo "Ollama is ready."

# Determine model name (default to gemma:2b if not set)
MODEL_NAME=${MODEL_NAME:-"gemma:2b"}

# Ensure the model is available (in case build-time pull failed)
echo "Checking for $MODEL_NAME model..."
ollama pull $MODEL_NAME

# Start the Node.js application
echo "Starting Express server..."
npm start

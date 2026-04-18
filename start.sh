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

# Ensure the model is available (in case build-time pull failed)
echo "Checking for gemma:2b model..."
ollama pull gemma:2b

# Start the Node.js application
echo "Starting Express server..."
npm start

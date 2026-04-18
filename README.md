# Ollama Gemma Server

A production-ready Express.js server that wraps the Ollama API to serve the **Gemma 2B** model. Designed specifically for deployment on Render and integration with external agents like OpenClaw.

## 🚀 Features

- **Express.js API**: Clean `/generate` endpoint.
- **Dockerized**: Single container runs both Ollama and the Node server.
- **Gemma 2B**: Optimized for size and performance.
- **Render Ready**: Configured to listen on port `10000`.

## 🛠️ Local Setup

### Using Docker (Recommended)

1. **Build the image**:
   ```bash
   docker build -t ollama-gemma-server .
   ```

2. **Run the container**:
   ```bash
   docker run -p 10000:10000 ollama-gemma-server
   ```

### Without Docker

1. [Install Ollama](https://ollama.com/download) on your machine.
2. Pull the model: `ollama pull gemma:2b`.
3. Install Node.js dependencies: `npm install`.
4. Start the server: `npm start`.

---

## ☁️ Deployment on Render

1. Create a new **Web Service** on Render.
2. Connect your GitHub repository.
3. Select **Docker** as the Runtime.
4. **Important Configuration**:
   - **Port**: `10000` (Render should detect this automatically from `EXPOSE`).
   - **Plan**: Use at least the **Starter** plan (2GB RAM). The Free tier (512MB) will not be able to load the Gemma model.

---

## 📡 API Usage

### Health Check
`GET /`
- Returns: `Ollama Gemma server running`

### Generate Text
`POST /generate`

**Request Body:**
```json
{
  "prompt": "Explain Quantum Physics to a 5-year old."
}
```

**cURL Example:**
```bash
curl -X POST https://your-app-name.onrender.com/generate \
     -H "Content-Type: application/json" \
     -d '{"prompt": "Hello Gemma!"}'
```

**Response:**
```json
{
  "response": "Hello! How can I help you today?..."
}
```

---

## 🧪 Testing with OpenClaw

To use this with OpenClaw, point your agent's LLM configuration to:
`https://your-app-name.onrender.com/generate`

---

## 📝 Error Handling

- **400 Bad Request**: Missing `prompt` in request body.
- **503 Service Unavailable**: Ollama server is still initializing.
- **500 Internal Server Error**: Issues interacting with the local Ollama API.

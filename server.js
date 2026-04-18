import express from 'express';
import fetch from 'node-fetch';
import 'dotenv/config';

const app = express();
const PORT = process.env.PORT || 8080;
const MODEL_NAME = process.env.MODEL_NAME || 'gemma:2b';
const OLLAMA_API = process.env.OLLAMA_URL || 'http://localhost:11434/api/generate';

app.use(express.json());

// Health check endpoint
app.get('/', (req, res) => {
  res.send('Ollama Gemma server running');
});

// Generate endpoint
app.post('/generate', async (req, res) => {
  const { prompt } = req.body;

  if (!prompt) {
    return res.status(400).json({ error: 'Prompt is required' });
  }

  console.log(`Generating response for prompt: "${prompt}"`);

  try {
    const response = await fetch(OLLAMA_API, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        model: MODEL_NAME,
        prompt: prompt,
        stream: false,
      }),
    });

    if (!response.ok) {
      const errorText = await response.text();
      console.error('Ollama API error:', errorText);
      return res.status(500).json({ error: 'Failed to generate response from Ollama' });
    }

    const data = await response.json();
    
    return res.json({
      response: data.response
    });

  } catch (error) {
    console.error('Error calling Ollama API:', error.message);
    
    if (error.code === 'ECONNREFUSED') {
      return res.status(503).json({ error: 'Ollama server is not responding. It might still be starting up.' });
    }
    
    return res.status(500).json({ error: 'Internal server error' });
  }
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server is running on port ${PORT}`);
  console.log(`Internal Ollama API expected at ${OLLAMA_API}`);
});

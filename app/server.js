const express = require('express');
const os = require('os');

const app = express();
const PORT = process.env.PORT || 3000;

// Change this value (v1 -> v2) and push to GitHub to demonstrate continuous deployment.
const APP_VERSION = 'v2';

app.get('/health', (req, res) => res.json({ status: 'ok', version: APP_VERSION }));

app.get('/', (req, res) => {
  res.send(`<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Azure CI/CD Demo</title>
  <style>
    body { font-family: system-ui, sans-serif; background: #0f172a; color: #e2e8f0;
           display: flex; align-items: center; justify-content: center; height: 100vh; margin: 0; }
    .card { background: #1e293b; padding: 2.5rem 3rem; border-radius: 16px; text-align: center;
            box-shadow: 0 10px 30px rgba(0,0,0,.4); }
    h1 { margin: 0 0 .5rem; color: #2b56b3; }
    .ver { font-size: 2.5rem; font-weight: 700; color: #4ade80; }
    p { color: #94a3b8; margin: .25rem 0; }
  </style>
</head>
<body>
  <div class="card">
    <h1>Vasuki The GMS Owner</h1>
    <div class="ver">${APP_VERSION}</div>
    <p>Deployed automatically with Terraform + Jenkins</p>
    <p>Host: ${os.hostname()}</p>
    <p>Served at: ${new Date().toISOString()}</p>
  </div>
</body>
</html>`);
});

app.listen(PORT, () => console.log(`App ${APP_VERSION} listening on port ${PORT}`));

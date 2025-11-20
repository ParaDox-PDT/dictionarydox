#!/usr/bin/env node

/**
 * Script to inject PEXELS_API_KEY into index.html during build
 * This reads the API key from .env file or environment variable
 * and injects it into window.flutterEnv in index.html
 */

const fs = require('fs');
const path = require('path');

// Read .env file if it exists
function readEnvFile() {
  const envPath = path.join(__dirname, '..', '.env');
  if (fs.existsSync(envPath)) {
    const envContent = fs.readFileSync(envPath, 'utf8');
    const env = {};
    envContent.split('\n').forEach(line => {
      const match = line.match(/^([^=:#]+)=(.*)$/);
      if (match) {
        const key = match[1].trim();
        const value = match[2].trim().replace(/^["']|["']$/g, '');
        env[key] = value;
      }
    });
    return env;
  }
  return {};
}

// Get API key from environment or .env file
function getApiKey() {
  // First try environment variable (from GitHub Actions secrets or Netlify)
  if (process.env.PEXELS_API_KEY) {
    return process.env.PEXELS_API_KEY;
  }
  
  // Then try .env file
  const env = readEnvFile();
  if (env.PEXELS_API_KEY) {
    return env.PEXELS_API_KEY;
  }
  
  return null;
}

// Inject API key into index.html
function injectApiKey() {
  const indexPath = path.join(__dirname, '..', 'web', 'index.html');
  
  if (!fs.existsSync(indexPath)) {
    console.error('index.html not found at:', indexPath);
    process.exit(1);
  }
  
  let indexContent = fs.readFileSync(indexPath, 'utf8');
  const apiKey = getApiKey();
  
  if (!apiKey) {
    console.warn('Warning: PEXELS_API_KEY not found in environment or .env file');
    console.warn('Image search will not work on web without API key');
    return;
  }
  
  // Inject API key into window.flutterEnv
  // Find the section where window.flutterEnv is initialized
  const envInitPattern = /window\.flutterEnv\s*=\s*window\.flutterEnv\s*\|\|\s*\{\};/;
  const apiKeyPattern = /window\.flutterEnv\.PEXELS_API_KEY\s*=/;
  
  if (apiKeyPattern.test(indexContent)) {
    // Replace existing API key
    indexContent = indexContent.replace(
      /window\.flutterEnv\.PEXELS_API_KEY\s*=\s*[^;]+;/,
      `window.flutterEnv.PEXELS_API_KEY = '${apiKey}';`
    );
  } else {
    // Add API key after window.flutterEnv initialization
    indexContent = indexContent.replace(
      envInitPattern,
      `window.flutterEnv = window.flutterEnv || {};\n    window.flutterEnv.PEXELS_API_KEY = '${apiKey}';`
    );
  }
  
  fs.writeFileSync(indexPath, indexContent, 'utf8');
  console.log('✓ PEXELS_API_KEY injected into index.html');
}

// Run the injection
try {
  injectApiKey();
} catch (error) {
  console.error('Error injecting API key:', error);
  process.exit(1);
}


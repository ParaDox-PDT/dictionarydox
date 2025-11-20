#!/bin/bash

# Script to inject PEXELS_API_KEY into index.html during build
# This reads the API key from .env file or environment variable
# and injects it into window.flutterEnv in index.html

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
INDEX_HTML="$PROJECT_ROOT/web/index.html"

# Get API key from environment or .env file
get_api_key() {
  # First try environment variable (from GitHub Actions secrets or Netlify)
  if [ -n "$PEXELS_API_KEY" ]; then
    echo "$PEXELS_API_KEY"
    return 0
  fi
  
  # Then try .env file
  if [ -f "$PROJECT_ROOT/.env" ]; then
    # Extract PEXELS_API_KEY from .env file
    API_KEY=$(grep -E "^PEXELS_API_KEY=" "$PROJECT_ROOT/.env" | cut -d '=' -f2- | sed 's/^["'\'']//;s/["'\'']$//' | tr -d '\r\n')
    if [ -n "$API_KEY" ]; then
      echo "$API_KEY"
      return 0
    fi
  fi
  
  return 1
}

# Check if index.html exists
if [ ! -f "$INDEX_HTML" ]; then
  echo "Error: index.html not found at $INDEX_HTML" >&2
  exit 1
fi

# Get API key
API_KEY=$(get_api_key)

if [ -z "$API_KEY" ]; then
  echo "Warning: PEXELS_API_KEY not found in environment or .env file" >&2
  echo "Warning: Image search will not work on web without API key" >&2
  exit 0
fi

# Escape special characters for sed
ESCAPED_KEY=$(echo "$API_KEY" | sed 's/[[\.*^$()+?{|]/\\&/g')

# Inject API key into index.html
# Check if API key is already set
if grep -q "window.flutterEnv.PEXELS_API_KEY" "$INDEX_HTML"; then
  # Replace existing API key
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS uses BSD sed
    sed -i '' "s|window\.flutterEnv\.PEXELS_API_KEY = '[^']*';|window.flutterEnv.PEXELS_API_KEY = '$ESCAPED_KEY';|g" "$INDEX_HTML"
  else
    # Linux uses GNU sed
    sed -i "s|window\.flutterEnv\.PEXELS_API_KEY = '[^']*';|window.flutterEnv.PEXELS_API_KEY = '$ESCAPED_KEY';|g" "$INDEX_HTML"
  fi
else
  # Add API key after window.flutterEnv initialization
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS uses BSD sed
    sed -i '' "s|window\.flutterEnv = window\.flutterEnv || {};|window.flutterEnv = window.flutterEnv || {};\n    window.flutterEnv.PEXELS_API_KEY = '$ESCAPED_KEY';|g" "$INDEX_HTML"
  else
    # Linux uses GNU sed
    sed -i "s|window\.flutterEnv = window\.flutterEnv || {};|window.flutterEnv = window.flutterEnv || {};\n    window.flutterEnv.PEXELS_API_KEY = '$ESCAPED_KEY';|g" "$INDEX_HTML"
  fi
fi

echo "✓ PEXELS_API_KEY injected into index.html"


#!/bin/sh
# With PIGI_MCP_TOKEN: static Bearer auth, no OAuth. Without it: OAuth on a
# fixed callback port so the redirect URI is stable across runs; 120 s gives a
# human time to complete the sign-in.
set -e
if [ -n "$PIGI_MCP_TOKEN" ]; then
  exec mcp-remote "$PIGI_MCP_URL" --header "Authorization:Bearer $PIGI_MCP_TOKEN"
fi
exec mcp-remote "$PIGI_MCP_URL" "$OAUTH_CALLBACK_PORT" --auth-timeout 120

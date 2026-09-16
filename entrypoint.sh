#!/bin/sh
# Starts the stdio bridge to the hosted pigi.finance MCP server.
#
# Self-contained: works from the Dockerfile image AND from directory runners
# (Glama) that clone this repo into their own image and run the script directly,
# so every setting has a default here.
#
# With PIGI_MCP_TOKEN: static Bearer auth, no OAuth. Without it: OAuth on a
# fixed callback port so the redirect URI is stable across runs; 120 s gives a
# human time to complete the sign-in.
set -e
: "${PIGI_MCP_URL:=https://mcp.pigi.finance/api/mcp}"
: "${OAUTH_CALLBACK_PORT:=3334}"
if [ -n "$PIGI_MCP_TOKEN" ]; then
  exec mcp-remote "$PIGI_MCP_URL" --header "Authorization:Bearer $PIGI_MCP_TOKEN"
fi
exec mcp-remote "$PIGI_MCP_URL" "$OAUTH_CALLBACK_PORT" --auth-timeout 120

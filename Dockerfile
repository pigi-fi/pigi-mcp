# pigi.finance MCP — stdio bridge to the hosted server.
#
# The server itself runs at https://mcp.pigi.finance/api/mcp (Streamable HTTP,
# OAuth 2.1). This image wraps it with mcp-remote so stdio-only clients and
# directory runners (Glama, Docker MCP) can start it as a local process.
#
# Interactive (a person signs in):
#   docker build -t pigi-mcp .
#   docker run -i --rm -p 3334:3334 -v pigi-mcp-auth:/home/node/.mcp-auth pigi-mcp
#   First run prints a sign-in URL; open it on the host. The OAuth callback
#   lands on localhost:3334, which -p publishes into the container. Tokens are
#   cached in the named volume so later runs skip sign-in.
#
# Non-interactive (a directory inspector or a service):
#   docker run -i --rm -e PIGI_MCP_TOKEN=<service token> pigi-mcp
#   The token is sent as a Bearer header and OAuth is skipped. Service tokens
#   are issued by pigi.finance for specific integrations; there is no
#   self-service issuance.

FROM node:22-alpine

ENV MCP_REMOTE_VERSION=0.14.2 \
    PIGI_MCP_URL=https://mcp.pigi.finance/api/mcp \
    OAUTH_CALLBACK_PORT=3334

RUN npm install -g "mcp-remote@${MCP_REMOTE_VERSION}" && npm cache clean --force

# Entrypoint is a committed script copied with plain COPY + chmod: some
# directory builders (Glama included) run a non-BuildKit build, which rejects
# heredocs and COPY --chmod.
COPY entrypoint.sh /usr/local/bin/pigi-mcp
RUN chmod 755 /usr/local/bin/pigi-mcp

USER node
WORKDIR /home/node
RUN mkdir -p /home/node/.mcp-auth
VOLUME ["/home/node/.mcp-auth"]
EXPOSE 3334

ENTRYPOINT ["/usr/local/bin/pigi-mcp"]

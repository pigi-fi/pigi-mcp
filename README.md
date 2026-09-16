<p align="center">
  <img src="https://pigi.finance/favicon-512x512.png" width="96" alt="pigi.finance" />
</p>

# pigi.finance — DeFi Vault Intelligence MCP

Query 2,000+ DeFi vaults across 25+ protocols and 14 EVM chains. Get vault risk scores, APR/APY and TVL history, risk-adjusted yield, DeFi base rates and hack/exploit data — for Claude, Cursor, Codex, Gemini CLI and any other MCP client.

- **Remote server, no install.** Point your client at one URL, sign in with OAuth. No API key to copy, no environment variables.
- **Cross-protocol.** One tool surface over Aave, Morpho, Euler, Uniswap, Fluid, SparkLend, Yearn and more — compare vaults *across* protocols instead of one at a time.
- **Risk-rated.** Each assessed vault carries pigi's published `risk_band` (A safest … F) and `risk_score` (0–100), so an agent can rank by safety, not just yield.
- **Free tier.** 1,000 requests/month, all vault metrics and history. Pro raises the limit and adds holder analytics. See [pigi.finance/api-keys](https://pigi.finance/api-keys).

Listed in the [official MCP registry](https://registry.modelcontextprotocol.io/?q=pigi-mcp) as `io.github.pigi-fi/pigi-mcp`.

**Endpoint:** `https://mcp.pigi.finance/api/mcp` (Streamable HTTP)

## Install

The fastest path is to paste this into your agent and let it do the setup:

```
Read https://raw.githubusercontent.com/pigi-fi/pigi-skills/refs/heads/main/pigi-setup/SKILL.md and follow the instructions to connect to pigi.finance MCP
```

Or add the server by hand.

**Claude Code**

```bash
claude mcp add pigi --transport http https://mcp.pigi.finance/api/mcp
```

**Codex**

```bash
codex mcp add pigi --url https://mcp.pigi.finance/api/mcp
```

**Claude Desktop / Cursor / Windsurf** (MCP config file)

```json
{
  "mcpServers": {
    "pigi": { "url": "https://mcp.pigi.finance/api/mcp" }
  }
}
```

**Gemini CLI**

```json
{
  "mcpServers": {
    "pigi": { "httpUrl": "https://mcp.pigi.finance/api/mcp" }
  }
}
```

**OpenCode**

```json
{
  "mcp": {
    "pigi": { "type": "remote", "url": "https://mcp.pigi.finance/api/mcp" }
  }
}
```

**Stdio-only clients** (bridge through `mcp-remote`)

```json
{
  "mcpServers": {
    "pigi": {
      "command": "npx",
      "args": ["-y", "mcp-remote", "https://mcp.pigi.finance/api/mcp"]
    }
  }
}
```

### Authenticate

On first connect the client opens an OAuth 2.1 sign-in (WorkOS AuthKit). A free account is provisioned on first login. If you already use the pigi.finance REST API, sign in with the same email: the MCP shares that account's plan and quota.

Headless environments: `mcp-remote` prints the sign-in URL; open it anywhere, then pass the callback URL back.

### Skills (optional)

[pigi-fi/pigi-skills](https://github.com/pigi-fi/pigi-skills) teaches an agent when and how to use the tools:

```bash
npx skills add pigi-fi/pigi-skills --yes
```

## What you can ask

- "Find USDC lending vaults on Ethereum with APR above 10% and TVL over $10M, then rank them by risk score."
- "Compare the top Morpho and Euler USDC vaults on risk-adjusted yield over the last 90 days."
- "Which vaults in Morpho had net outflows this month?"
- "How does the DeFi base rate compare with the 3-month T-bill right now?"
- "How much was lost to bridge exploits in 2025?"

## Tools

| Tool | What it returns | Key arguments |
|---|---|---|
| `list_vaults` | A page of vaults with TVL, APR/APY, age, protocol, chain and (where assessed) `risk_band` / `risk_score`. Returns `id` (for `get_vault`) and `strategy_id` (for history/stats). | `protocol_name`, `chain_id`, `tvl_filter` (`gte_1m` … `gte_10m`), `apr_filter` (`gt_5` … `gt_20`, `lte_10`), `age_filter`, `limit`, `offset` |
| `get_vault` | Full record for one vault by pool `id`. | `id` |
| `get_vault_history` | Daily series: TVL, APR, APY, risk-adjusted APR (APR minus a penalty derived from the risk score) and 30-day moving averages. | `strategy_id`, `range` (`7D` / `30D` / `90D` / `180D`) |
| `get_vault_stats` | Windowed aggregates: TVL low/high, APR, APY and net inflows for weekly / monthly / quarterly / yearly. | `strategy_id`, `period` |
| `get_rates` | DeFi Base Rate (stablecoin and ETH vault-set mean yield) and the 3-month U.S. T-bill rate, last ~30 daily points. | — |
| `get_hacks` | DeFi hack / exploit loss events plus major TradFi losses, with a `summary` totalling the whole filtered set. | `category`, `type` (DeFi / Dexes / Bridges), `from`, `to`, `min_amount`, `sort`, `limit`, `offset` |
| `get_usage` | Your request count this month and plan limit. | — |

`list_vaults` filters by protocol, chain, TVL band, APR band and age. Filtering by asset (e.g. USDC) or risk band is done by the agent on the returned page; narrow with the server-side filters first.

## Coverage

2,000+ vaults · 25+ protocols · 14 EVM chains · lending markets, ERC-4626 vaults, AMM pools and stability pools. Data is refreshed daily. Risk ratings are published for the vaults pigi has assessed; the live count is on [pigi.finance](https://pigi.finance).

## About this repo

This repo is the public listing for the pigi.finance MCP server: the registry manifest (`server.json`), the publish workflow, and this README. The server itself is a hosted service; its code is not published here.

Releases: bump `version` in `server.json`, commit, tag `vX.Y.Z` and push the tag. The workflow validates the manifest and publishes to the registry with GitHub OIDC. The registry never overwrites a published version.

## Links

- Setup page: [app.pigi.finance/defi-mcp](https://app.pigi.finance/defi-mcp)
- REST API docs: [app.pigi.finance/defi-api-docs](https://app.pigi.finance/defi-api-docs)
- Skills: [github.com/pigi-fi/pigi-skills](https://github.com/pigi-fi/pigi-skills)
- Registry entry: [registry.modelcontextprotocol.io/?q=pigi-mcp](https://registry.modelcontextprotocol.io/?q=pigi-mcp)

Tags: DeFi · Finance · Cryptocurrency · Blockchain · Web3 · Yield · Vaults · Risk · Risk Analytics · On-chain Data · Aave · Morpho · Euler · Uniswap · EVM

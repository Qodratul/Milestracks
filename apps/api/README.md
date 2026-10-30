# Milestracks API

TypeScript/Express API for the Milestracks Flutter app. It owns accounts, route-generation jobs, route/run state, milestones, game rewards, inventory/shop records, and history. PostgreSQL with PostGIS stores application data and route geometry.

## Requirements

- Node.js compatible with this package and pnpm.
- Docker Compose for the local PostGIS service, or a compatible PostgreSQL/PostGIS database.
- Nebius Token Factory credentials for live Nemotron inference; a GraphHopper API key for external road routing. Mock routing is available for development.

## Local setup

From the repository root, start PostGIS:

```powershell
docker compose -f infra/docker-compose.yml up -d
```

Then from `apps/api`:

```powershell
Copy-Item .env.example .env
pnpm install
pnpm prisma:generate
pnpm db:deploy
pnpm dev
```

The API listens on `http://localhost:3000` by default. Interactive API docs are served at `/api/docs`. `DIRECT_URL` is used by Prisma migrations; for local setup it may point to the same database as `DATABASE_URL`.

Set a private `JWT_SECRET` of at least 32 characters in `.env`. The supplied example uses `ROUTING_PROVIDER=mock`; set `DEMO_MODE=true` only when intentionally using deterministic demo routing/data. Never commit `.env`, database passwords, Nebius keys, OAuth secrets, or provider credentials.

## Providers and environment

See [`.env.example`](./.env.example) for all supported variables. Main settings:

- `DATABASE_URL`, `DIRECT_URL`: application and migration database connections.
- `JWT_SECRET`, optional `GOOGLE_CLIENT_ID`: token signing key and Google token audience.
- `ROUTING_PROVIDER=mock|graphhopper`, `GRAPHOPPER_API_KEY`, `GRAPHOPPER_PROFILE`, and request credit/time limits.
- `LLM_API_KEY`, `LLM_FAST_BASE_URL`, `LLM_MODEL_FAST`: Nebius Token Factory fast model for route-candidate selection and narrative.
- `LLM_REASONING_BASE_URL`, `LLM_MODEL_REASONING`: optional separate model for runner-safety evaluation. It does not provide route geometry.
- `OSM_TAGS_PROVIDER`, `OVERPASS_API_URL`, `OVERPASS_FALLBACK_API_URL`: road tags and fallback Overpass service.
- Open-Meteo elevation settings, optional `UPSTASH_REDIS_URL` and `SENTRY_DSN`.

The checked-in `.env.example` model IDs are examples and may differ from the models used in a deployed environment. Configure the model IDs and base URLs for your Nebius account. Empty LLM settings, unavailable inference, or invalid model output cause deterministic fallback behavior. A successful HTTP response alone does not prove the LLM selected a route; inspect logs for the selection source and fallback messages.

## Route-generation flow

1. A mystery-route request enqueues a background job and responds with HTTP `202`.
2. The routing provider creates candidate geometries. GraphHopper follows mapped roads; mock mode is for local development/demo.
3. Elevation and road tags enrich candidates. Deterministic safety and validity checks run before route selection.
4. Nemotron fast-tier inference selects among eligible candidates and generates narrative when configured and valid. Existing safe templates may be reused when appropriate.
5. The mobile client polls route status and loads a ready route. Run endpoints record activity and finalize rewards using server-side domain rules.

The AI does not invent road geometry or replace the deterministic route-safety checks. Safety scores depend on external data coverage and are not a guarantee that a route is safe.

## Database maintenance

```powershell
pnpm db:deploy        # apply committed migrations
pnpm db:seed          # seed development data
pnpm prisma:generate  # regenerate Prisma client
```

Use a disposable development database for seed/reset work. Do not run development migrations against production; use the deployment migration command and an appropriate reviewed backup/rollout process.

## Development checks

```powershell
pnpm typecheck
pnpm lint
pnpm test
pnpm build
```

`pnpm dev` runs the API in watch mode. `STUB_MODE` is for explicitly enabled contract/stub work and must not be used in production. Route-generation jobs run in-process; review job recovery/concurrency settings before deploying multiple API instances.

## API reference

The generated OpenAPI specification is [`openapi.json`](./openapi.json); interactive docs are served at `/api/docs`. Keep the API documentation aligned with implementation when contracts change.

## License

Project source code is licensed under Apache-2.0; see the repository [LICENSE](../../LICENSE). Dependencies, model APIs, routing/elevation/map providers, and their data remain governed by their own licenses and service terms.

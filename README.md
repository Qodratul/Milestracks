# Milestracks

Milestracks turns a run into a story-driven route adventure. It is a Flutter running app backed by a TypeScript API. Runners receive a route suited to their level, track progress through milestones, and earn experience for completed activity.

This repository is the project submission for the **Nebius × NVIDIA Global AI Hackathon**, in the **Best Apps and Agents** track. The API makes runtime inference calls to Nebius Token Factory using NVIDIA Nemotron models.

## What it does

- Generates street-following route candidates around a privacy-offset start location, then checks available route data and deterministic safety rules.
- Uses **Nemotron 3 Nano 30B A3B** through Nebius Token Factory to select among eligible routes and write route and milestone narrative. Unavailable or invalid model output uses deterministic fallback behavior.
- Provides a separate **Nemotron 3 Ultra 550B A55B** runner-safety evaluation path when configured. Deterministic rules remain the fallback; this model does not generate route geometry.
- Tracks runs, milestones, pause/resume, Safe Stop, results, EXP, levels, coins, inventory, and history.
- Includes Kila, the virtual running companion, plus English and Indonesian localization.

Model IDs are deployment configuration and can differ between environments. Configure the model IDs and endpoints for your Nebius account; do not commit API credentials.

## Repository layout

| Directory | Description |
| --- | --- |
| [`apps/mobile`](./apps/mobile/README.md) | Flutter Android/iOS client and local run engine |
| [`apps/api`](./apps/api/README.md) | Express/TypeScript API, route generation, game logic, persistence |
| [`apps/remotion-video`](./apps/remotion-video/README.md) | Remotion demo source and rendered video |
| [`infra`](./infra) | Local PostGIS service configuration |

## Quick start

Start the database from the repository root:

```powershell
docker compose -f infra/docker-compose.yml up -d
```

Then follow the [API setup](./apps/api/README.md) and [mobile setup](./apps/mobile/README.md). Start the API, configure the mobile app's API URL, then launch Flutter on an Android emulator or iOS Simulator.

## AI and routing architecture

GraphHopper (or the development mock provider) produces road-following route geometry. The API enriches candidates with available routing, elevation, and OpenStreetMap data and applies deterministic eligibility checks. Nemotron 3 Nano selects among eligible candidates and creates narrative text. The LLM is not the routing engine or safety gate. Invalid or unavailable LLM output has a deterministic fallback.

The separate runner-safety evaluation uses the configured reasoning model when enabled. It is distinct from route selection. Both model calls use the OpenAI-compatible Nebius Token Factory API.

## Hackathon submission notes

- **Track:** Best Apps and Agents.
- **Nebius requirement:** the API calls Nebius Token Factory at runtime when model credentials and model settings are configured.
- **NVIDIA model:** Nemotron is used for route selection/narrative and, separately, runner-safety evaluation.
- **Platform:** Flutter Android/iOS client with a separately hosted TypeScript API.
- **Third-party services:** Nebius Token Factory, GraphHopper, Open-Meteo, OpenStreetMap/Overpass, Google Sign-In, and optional Upstash Redis/Sentry. Follow each service's terms, API limits, and attribution requirements.
- **Demo video:** the supplied rules require a public YouTube demonstration shorter than three minutes showing the app or key modules in operation. Upload the final compliant video and include its public URL in the Devpost submission.
- **Testing access:** provide a working demo/test build and any necessary test credentials through the submission form. Do not put secrets in this repository.
- **Project history:** if the project existed before the submission period, explain the substantial work completed during the period in the submission text.

The official rules govern eligibility, judging, required submission materials, third-party rights, and video requirements. This README does not replace those rules.

## License

Project source code is licensed under the MIT License; see [`LICENSE`](./LICENSE). This is an OSI-approved open-source license and meets the example license requirement in the supplied hackathon rules. Third-party libraries, services, map data, fonts, and assets remain subject to their own licenses, terms, and attribution requirements. This license does not grant rights to Nebius, NVIDIA, GraphHopper, Google, OpenStreetMap contributors, or other third-party marks or materials.

## Known scope and limitations

Some screens and navigation areas are placeholders or preview-only and are not backed by complete production workflows. Consult app-specific READMEs for current scope. Route safety scores depend on external map and elevation data coverage; they are informational and cannot guarantee a route is safe.

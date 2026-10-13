# Titan System

<p align="center">
  <img src="docs/serverpod-hackathon.png" alt="Serverpod Hackathon - Build a full-stack app" width="320">
</p>

## Serverpod Hackathon

This project is a submission to the **Serverpod Hackathon** ("Build a full-stack app", $20,000 worth of prizes).

- **Project:** Titan System
- **Team:** Titan Team
- **Author:** Wellington Carlos de Lacerda - SP - Brazil

---

## Police Dispatch System

Real-time urban police dispatch platform built with **Serverpod** (Dart), **Flutter**, and **PostgreSQL**.

The system models patrol dispatch across the municipality of São Paulo, using a sampled geographic coverage target to spread available units as incidents are handled.

## Repository

Source code: [github.com/wellingtonb3/serverpod](https://github.com/wellingtonb3/serverpod)

## Project Description

Titan System is a real-time emergency-dispatch demonstration for São Paulo.
Dispatchers report incidents by address, choose police, firefighters, or both,
and follow simulated units as they travel to the incident. The dashboard shows
live vehicle positions and statuses, plays distinct periodic alerts while units
are en route, and records completed incidents with their requested address,
assigned units, and response duration.

The application was built with a Flutter web dashboard, a Dart Serverpod API
and WebSocket streams for live updates, PostgreSQL for persistent dispatch
data, and Redis for message broadcasting. Docker Compose runs the backend
services locally. The simulation uses the IBGE municipality boundary and
OpenStreetMap map and fire-station data for demonstration purposes.

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│  Flutter Dashboard (police_dispatch_dashboard)                       │
│  ┌──────────────────────────┐  ┌──────────────────────────────────┐ │
│  │  DispatchMap             │  │  StatsPanel                      │ │
│  │  flutter_map / OSM tiles │  │  Vehicle list, sector coverage   │ │
│  │  Live vehicle markers    │  │  Available / En Route / Returning │ │
│  └──────────────────────────┘  └──────────────────────────────────┘ │
└──────────────────────────────┬──────────────────────────────────────┘
                               │  WebSocket stream (Serverpod)
┌──────────────────────────────▼──────────────────────────────────────┐
│  Serverpod Server (police_dispatch_server)                           │
│  ┌────────────────────┐  ┌──────────────────────────────────────┐   │
│  │  DispatchEndpoint  │  │  SimulationTask (background timer)   │   │
│  │  - monitorVehicles │  │  Moves vehicles 5% closer per second │   │
│  │  - requestDispatch │  │  Broadcasts 'map-update' on tick     │   │
│  │  - getAllSectors    │  └──────────────────────────────────────┘   │
│  └────────────────────┘                                              │
│  ┌────────────────────┐  ┌──────────────────────────────────────┐   │
│  │  CoverageChecker   │  │  HaversineCalculator                 │   │
│  │  Municipal coverage│  │  GPS distance & ETA calculation      │   │
│  │  and patrol planner│  └──────────────────────────────────────┘   │
│  └────────────────────┘                                              │
└──────────────────────────────┬──────────────────────────────────────┘
                               │
┌──────────────────────────────▼──────────────────────────────────────┐
│  PostgreSQL 16                                                        │
│  Tables: vehicle, incident, sector, fire_station, fire_vehicle          │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Intelligent Dispatch Algorithm

The server samples the official IBGE municipality boundary at approximately 1 km
spacing and uses straight-line Haversine distance as an estimate of coverage.
Patrol posts are selected with a farthest-point strategy. For each incident,
the dispatcher first chooses the unit whose removal creates the smallest
increase in the fleet's maximum sampled distance to an available unit; distance
to the call breaks ties. The remaining available units are then reassigned to
citywide posts and visibly move with status **Repositioning**. Units returning
from a resolved incident join the same rebalancing.

The dashboard shows the current maximum sampled distance against the 5 km
target. The earlier 18-unit layout measured about 10.4 km, and the 30-unit
layout did not meet the target. The current 75-unit planned layout is below 5 km
for the sampled municipality boundary. These are approximate straight-line
distances, not road travel-time coverage or a guarantee for every unsampled
point; live coverage can also change as units respond to incidents. The planner
is heuristic, so the result is not a mathematical lower bound on fleet size.
The system still dispatches emergency calls and displays the current coverage
shortfall. The municipal boundary is IBGE's GeoJSON malha for municipality code 3550308.

The demo seeds 75 police units spread across the municipal boundary rather than
in three-unit clusters. When a vehicle arrives at an incident, its status
changes to **On Scene**. Use the completion control beside that unit in the
dashboard when its response is complete; it returns to its saved patrol
position.

Incident descriptions are separate from incident locations. In the dashboard,
search for an address to resolve it through the OpenStreetMap Nominatim service,
select the correct match, and then dispatch. The selected incident location is
shown on the map; coordinates are handled internally and are not entered by the
user. Dispatch requests outside the official São Paulo municipal boundary are
rejected with an explanatory message. The lookup sends only the address field
(not the incident description) to Nominatim. The public geocoder is intended
for low-volume demonstrations and is subject to OpenStreetMap's usage policy.

The demo also maps 35 OpenStreetMap `amenity=fire_station` locations inside the
São Paulo municipal relation, with two simulated fire-response units per
station. OpenStreetMap records are community-maintained demonstration data,
not an official or verified fire-department station roster. Incident reporting
can request police, firefighters, or both; a fire request dispatches
one available unit from the station nearest to the incident. A later fire
request dispatches the next nearest available unit instead of sending a pair
automatically. Police dispatch selects the nearest available patrol vehicle.
Combined incidents remain active until every assigned service unit completes
its response. Units return to their patrol position or station and become
**Available** again after arriving there. All simulated units travel by
straight-line interpolation, not along roads. Map and fire-station data
attribution: © OpenStreetMap contributors, ODbL 1.0.

---

## Data Models

### Vehicle
| Field | Type | Description |
|-------|------|-------------|
| `code` | String | Unit code, e.g. `RP-01` |
| `latitude` / `longitude` | double | Current GPS position |
| `status` | String | `available` \| `dispatched` \| `on_scene` \| `returning` \| `repositioning` |
| `currentSector` | String | Sector the vehicle is patrolling |
| `targetLatitude` / `targetLongitude` | double? | Destination when dispatched |
| `patrolLatitude` / `patrolLongitude` | double? | Patrol position restored after an incident |
| `assignedIncidentId` | int? | Active incident FK |

### Incident
| Field | Type | Description |
|-------|------|-------------|
| `description` | String | Free-text incident description |
| `address` | String? | Address selected when the incident was reported |
| `latitude` / `longitude` | double | GPS location of the incident |
| `status` | String | `open` \| `dispatched` \| `closed` |
| `sectorId` | String | Sector where the incident occurred |
| `assignedVehicleId` | int? | Vehicle responding |
| `requestedServices` | String? | `police`, `firefighters`, or both |
| `assignedFireVehicleOneId` / `assignedFireVehicleTwoId` | int? | Fire unit responding (one per dispatch request) |
| `createdAt` / `closedAt` | DateTime | Lifecycle timestamps |

### Fire station and fire vehicle
Each mapped station has a unique code and coordinates from the OSM demo
catalogue. Two simulated fire vehicles are seeded per station; each tracks its
station, current position, status, destination, and assigned incident.

### Sector
| Field | Type | Description |
|-------|------|-------------|
| `sectorCode` | String | Unique code, e.g. `ZONE_CENTRAL` |
| `name` | String | Human-readable name |
| `centerLatitude` / `centerLongitude` | double | Sector centre point |
| `minimumVehicles` | int | Minimum required patrol vehicles |
| `boundaryGeoJson` | String | GeoJSON polygon for map rendering |

---

## Project Structure

```
.
├── police_dispatch_server/          # Serverpod backend
│   ├── bin/
│   │   ├── main.dart                # Server entry point
│   │   ├── seed.dart                # Municipality and fleet seeder
│   │   └── rebalance_fleet.dart     # Safe one-time fleet repositioning
│   ├── lib/src/
│   │   ├── endpoints/
│   │   │   └── dispatch_endpoint.dart
│   │   ├── models/
│   │   │   ├── vehicle.spy.yaml
│   │   │   ├── incident.spy.yaml
│   │   │   ├── fire_station.spy.yaml
│   │   │   ├── fire_vehicle.spy.yaml
│   │   │   ├── sector.spy.yaml
│   │   │   └── dispatch_result.spy.yaml
│   │   ├── tasks/
│   │   │   └── simulation_task.dart
│   │   └── utils/
│   │       ├── haversine_calculator.dart
│   │       ├── coverage_checker.dart
│   │       ├── municipal_coverage_planner.dart
│   │       └── fire_station_catalog.dart
│   ├── assets/
│   │   ├── sao_paulo_municipality.geojson # IBGE municipality boundary
│   │   └── sao_paulo_fire_stations.json   # OSM demonstration catalogue
│   ├── migrations/
│   │   └── 20240101000000_initial.sql
│   ├── config/
│   │   ├── development.yaml
│   │   └── production.yaml
│   ├── test/
│   │   └── haversine_calculator_test.dart
│   └── Dockerfile
│
├── police_dispatch_client/          # Generated client (Serverpod)
│   └── pubspec.yaml
│
├── police_dispatch_dashboard/       # Flutter web/desktop dashboard
│   ├── lib/
│   │   ├── main.dart
│   │   ├── screens/
│   │   │   └── dashboard_screen.dart
│   │   ├── widgets/
│   │   │   ├── dispatch_map.dart
│   │   │   ├── stats_panel.dart
│   │   │   └── incident_form.dart
│   │   └── providers/
│   │       └── dispatch_providers.dart
│   └── pubspec.yaml
│
├── docker-compose.yml
└── README.md
```

---

## Getting Started

The following steps use Docker for all backend services, migrations, and demo
data. They are the recommended path for local testing on Windows, macOS, or
Linux.

### Prerequisites

- [Docker Desktop](https://docs.docker.com/get-docker/) with Docker Compose running
- [Flutter SDK](https://flutter.dev/docs/get-started/install) ≥ 3.19, including Dart ≥ 3.12.2
- Google Chrome for the web dashboard

`serverpod generate` is only required when changing Serverpod `.spy.yaml`
models or endpoint signatures; generated code is already included in the
repository, so it is not required to run the product locally.

### 1 — Configure local secrets

From the repository root, create `.env` from the template and replace every
placeholder value with a unique local value. The file is ignored by Git and
must not be committed.

```powershell
Copy-Item .env.example .env
```

### 2 — Build and start dependencies

```powershell
docker compose build server
docker compose up -d postgres redis
```

Confirm both services are healthy before continuing:

```powershell
docker compose ps
```

### 3 — Apply migrations and seed demo data

Run the database migration and seed commands inside the Compose network. This
uses the checked-in production configuration and the passwords from `.env`.

```powershell
docker compose run --rm server dart run bin/main.dart --mode production --apply-migrations --role maintenance
docker compose run --rm server dart run bin/seed.dart --mode production --apply-migrations
```

The seed is safe to repeat and creates the São Paulo boundary, 75 simulated
police units, fire stations, and fire-response units when they are missing.

### 4 — Start the API

```powershell
docker compose up -d server
```

The Serverpod API and WebSocket endpoint are available locally at
`http://localhost:8080`.

### 5 — Start the dashboard

Open a second PowerShell terminal:

```powershell
cd police_dispatch_dashboard
flutter pub get
flutter run -d chrome --web-port 3000
```

Open [http://localhost:3000](http://localhost:3000). The dashboard connects to
the local Serverpod API at `http://localhost:8080`.

### 6 — Test the product

1. Click **Report Incident**.
2. Enter a description, select police, firefighters, or both, and search for
   an address inside São Paulo.
3. Select the address result and submit the dispatch.
4. Confirm the assigned units move toward the incident. The police and fire
   alert tones repeat every five seconds while their units are en route.
5. When a unit reaches the incident, use the completion control to complete its
   response. The unit returns without an alert tone.
6. Click the history button beside **Report Incident** to verify the completed
   incident, requested address, dispatched units, and duration.

### 7 — Run backend tests

```powershell
cd police_dispatch_server
dart test
```

### Stop the local stack

```powershell
cd ..
docker compose down
```

---

## Configuration

The Compose stack uses `.env` for local secrets and
[production.yaml](./police_dispatch_server/config/production.yaml) for service
hosts. For a non-Docker deployment, replace the service hosts and public URLs
in that configuration and provide the three `SERVERPOD_PASSWORD_*` values using
your deployment platform's secret manager.

---

## Extending the System

| Feature | Where to add |
|---------|-------------|
| Sector-aware automatic reassignment | `CoverageChecker.canDispatch()` |
| Push notifications to field officers | New `NotificationEndpoint` + FCM |
| Officer mobile app (real GPS) | New Flutter app consuming the same `DispatchEndpoint` stream |
| PostGIS spatial queries | Replace `HaversineCalculator` with `Vehicle.db.unsafeQuery(ST_Distance)` |
| Authentication & roles | Serverpod `AuthenticationHandler` middleware |

---

## License

MIT — for demonstration and educational purposes.

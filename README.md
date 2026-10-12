# Police Dispatch System

Real-time urban police dispatch platform built with **Serverpod** (Dart), **Flutter**, and **PostgreSQL**.

The system models patrol dispatch across the municipality of São Paulo, using a sampled geographic coverage target to spread available units as incidents are handled.

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
│  Tables: vehicle, incident, sector                                    │
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
target. The 18-unit layout measured about 10.4 km, so it did not meet the
target; the 30-unit layout is spread across the city and reduces that distance,
but still does not meet 5 km. This is an approximate straight-line simulation, not road
travel-time coverage or a guarantee for every unsampled point; the planner is
heuristic, so the result is not a mathematical lower bound on the fleet size.
The system still dispatches emergency calls and displays the coverage shortfall.
The municipal boundary is IBGE's GeoJSON malha for municipality code 3550308.

The demo seeds 30 units spread across the municipal boundary rather than in
three-unit clusters. When a vehicle arrives at an incident, its status changes
to **On Scene**.
Use **Concluir** beside that unit in the dashboard when the incident is resolved;
the incident closes and the unit visibly returns to its saved patrol position.

Incident descriptions are separate from incident locations. In the dashboard,
search for a São Paulo street address to resolve it to coordinates through the
OpenStreetMap Nominatim service, select the correct match, and then dispatch.
The selected incident location is shown on the map. The lookup sends the address
field (not the incident description) to Nominatim; manual coordinates can also
be entered. The public geocoder is intended for low-volume demonstrations and
is subject to OpenStreetMap's usage policy.
It becomes **Available** again after arriving there.

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
| `latitude` / `longitude` | double | GPS location of the incident |
| `status` | String | `open` \| `dispatched` \| `closed` |
| `sectorId` | String | Sector where the incident occurred |
| `assignedVehicleId` | int? | Vehicle responding |
| `createdAt` / `closedAt` | DateTime | Lifecycle timestamps |

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
│   │   │   ├── vehicle.yaml
│   │   │   ├── incident.yaml
│   │   │   ├── sector.yaml
│   │   │   └── dispatch_result.yaml
│   │   ├── tasks/
│   │   │   └── simulation_task.dart
│   │   └── utils/
│   │       ├── haversine_calculator.dart
│   │       ├── coverage_checker.dart
│   │       └── municipal_coverage_planner.dart
│   ├── assets/
│   │   └── sao_paulo_municipality.geojson # IBGE municipality boundary
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

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) ≥ 3.10
- [Dart SDK](https://dart.dev/get-dart) ≥ 3.0 (bundled with Flutter)
- [Docker](https://docs.docker.com/get-docker/) & Docker Compose
- [Serverpod CLI](https://docs.serverpod.dev/get-started)

```bash
dart pub global activate serverpod_cli
```

### 1 — Start the database

Create a local environment file from the template and replace the placeholder
values with unique credentials. `.env` is ignored by Git and must not be
committed:

```bash
cp .env.example .env
```

On PowerShell, use `Copy-Item .env.example .env` instead.

```bash
docker compose up -d postgres redis
```

### 2 — Generate Serverpod code

```bash
cd police_dispatch_server
serverpod generate
```

This generates the `lib/src/generated/` folder with typed model classes and endpoint clients.

### 3 — Apply migrations and seed data

```bash
dart run bin/main.dart --apply-migrations --role maintenance
dart run bin/seed.dart --apply-migrations
```

To spread an existing fleet across the municipality, run the guarded rebalance
command. It repositions available units and preserves the current location and
return destination of dispatched, on-scene, or returning units:

```bash
dart run bin/rebalance_fleet.dart --role maintenance --apply
# For the Docker stack:
docker compose exec server dart run bin/rebalance_fleet.dart --mode production --role maintenance --apply
```

### 4 — Start the server

```bash
dart run bin/main.dart
```

The server is now running on `http://localhost:8080`.

To run the server in Docker instead, after applying migrations and seeding:

```bash
docker compose up -d --build server
```

The container uses the production run mode and connects to the Compose
`postgres` and `redis` services. The API is available at `http://localhost:8080`.
The checked-in production config is tailored to this local Compose stack; replace
its service hosts and public URLs when deploying outside Docker Compose.

### 5 — Run the Flutter dashboard

```bash
cd ../police_dispatch_dashboard
flutter pub get
flutter run -d chrome          # Web
# or
flutter run -d macos           # macOS desktop
```

### 6 — Run tests

```bash
cd police_dispatch_server
dart test
```

---

## Configuration

Edit `police_dispatch_server/config/development.yaml` to match your local Postgres credentials.

For production deployment, use environment variables as shown in `config/production.yaml` and deploy with Docker Compose or Kubernetes.

---

## Extending the System

| Feature | Where to add |
|---------|-------------|
| Sector-aware automatic reassignment | `CoverageChecker.canDispatch()` |
| Push notifications to field officers | New `NotificationEndpoint` + FCM |
| Officer mobile app (real GPS) | New Flutter app consuming the same `DispatchEndpoint` stream |
| PostGIS spatial queries | Replace `HaversineCalculator` with `Viatura.db.unsafeQuery(ST_Distance)` |
| Authentication & roles | Serverpod `AuthenticationHandler` middleware |

---

## License

MIT — for demonstration and educational purposes.

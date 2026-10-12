-- Police Dispatch System — initial database migration
-- Generated for Serverpod. Apply with: dart run bin/main.dart --apply-migrations

-- ─── Sectors ──────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS "sector" (
    "id"                SERIAL      PRIMARY KEY,
    "name"              TEXT        NOT NULL,
    "sectorCode"        TEXT        NOT NULL UNIQUE,
    "centerLatitude"    FLOAT8      NOT NULL,
    "centerLongitude"   FLOAT8      NOT NULL,
    "minimumVehicles"   INT         NOT NULL DEFAULT 1,
    "boundaryGeoJson"   TEXT        NOT NULL DEFAULT '{}'
);

CREATE UNIQUE INDEX IF NOT EXISTS sector_code_idx ON "sector" ("sectorCode");

-- ─── Vehicles ─────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS "vehicle" (
    "id"                    SERIAL      PRIMARY KEY,
    "code"                  TEXT        NOT NULL,
    "latitude"              FLOAT8      NOT NULL,
    "longitude"             FLOAT8      NOT NULL,
    "status"                TEXT        NOT NULL DEFAULT 'available',
    "currentSector"         TEXT        NOT NULL,
    "targetLatitude"        FLOAT8,
    "targetLongitude"       FLOAT8,
    "assignedIncidentId"    INT
);

CREATE INDEX IF NOT EXISTS vehicle_status_idx  ON "vehicle" ("status");
CREATE INDEX IF NOT EXISTS vehicle_sector_idx  ON "vehicle" ("currentSector");

-- ─── Incidents ────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS "incident" (
    "id"                    SERIAL      PRIMARY KEY,
    "description"           TEXT        NOT NULL,
    "latitude"              FLOAT8      NOT NULL,
    "longitude"             FLOAT8      NOT NULL,
    "status"                TEXT        NOT NULL DEFAULT 'open',
    "sectorId"              TEXT        NOT NULL,
    "assignedVehicleId"     INT,
    "createdAt"             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    "closedAt"              TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS incident_status_idx  ON "incident" ("status");
CREATE INDEX IF NOT EXISTS incident_sector_idx  ON "incident" ("sectorId");

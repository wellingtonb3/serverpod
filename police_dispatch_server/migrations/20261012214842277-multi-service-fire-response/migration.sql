BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "fire_station" (
    "id" bigserial PRIMARY KEY,
    "stationCode" text NOT NULL,
    "name" text NOT NULL,
    "latitude" double precision NOT NULL,
    "longitude" double precision NOT NULL,
    "osmType" text NOT NULL,
    "osmId" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "fire_station_code_idx" ON "fire_station" USING btree ("stationCode");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "fire_vehicle" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "stationCode" text NOT NULL,
    "latitude" double precision NOT NULL,
    "longitude" double precision NOT NULL,
    "status" text NOT NULL,
    "targetLatitude" double precision,
    "targetLongitude" double precision,
    "assignedIncidentId" bigint
);

-- Indexes
CREATE INDEX "fire_vehicle_status_idx" ON "fire_vehicle" USING btree ("status");
CREATE INDEX "fire_vehicle_station_idx" ON "fire_vehicle" USING btree ("stationCode");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "incident" ADD COLUMN "requestedServices" text;
ALTER TABLE "incident" ADD COLUMN "assignedFireVehicleOneId" bigint;
ALTER TABLE "incident" ADD COLUMN "assignedFireVehicleTwoId" bigint;

--
-- MIGRATION VERSION FOR police_dispatch
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('police_dispatch', '20261012214842277-multi-service-fire-response', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261012214842277-multi-service-fire-response', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();


COMMIT;

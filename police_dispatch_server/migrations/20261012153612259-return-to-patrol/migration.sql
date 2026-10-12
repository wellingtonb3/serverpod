BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "vehicle" ADD COLUMN "patrolLatitude" double precision;
ALTER TABLE "vehicle" ADD COLUMN "patrolLongitude" double precision;

--
-- MIGRATION VERSION FOR police_dispatch
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('police_dispatch', '20261012153612259-return-to-patrol', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261012153612259-return-to-patrol', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();


COMMIT;

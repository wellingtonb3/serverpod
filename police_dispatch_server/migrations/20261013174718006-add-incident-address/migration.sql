BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "incident" ADD COLUMN "address" text;

--
-- MIGRATION VERSION FOR police_dispatch
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('police_dispatch', '20261013174718006-add-incident-address', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261013174718006-add-incident-address', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();


COMMIT;

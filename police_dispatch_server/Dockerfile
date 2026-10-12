# Server Dockerfile
# Run the Serverpod app directly in the Dart runtime so build hooks supported by
# the framework are executed correctly during startup.

FROM dart:3.13-sdk

WORKDIR /app

# Copy the client package first (dependency of the server)
COPY police_dispatch_client /police_dispatch_client

# Copy server source
COPY police_dispatch_server /app

# Install dependencies and use the normal Serverpod runtime flow.
RUN dart pub get

# Expose all Serverpod ports
EXPOSE 8080 8081 8082

CMD ["dart", "run", "bin/main.dart", "--mode", "production"]

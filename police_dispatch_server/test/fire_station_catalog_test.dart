import 'package:police_dispatch_server/src/utils/fire_station_catalog.dart';
import 'package:test/test.dart';

void main() {
  test('loads distinct São Paulo fire stations from OpenStreetMap', () async {
    final stations = await FireStationCatalog.readStations();

    expect(stations, hasLength(35));
    expect(stations.map((station) => station.code).toSet(), hasLength(35));
    expect(
      stations.every(
        (station) =>
            station.latitude >= -24.01 &&
            station.latitude <= -23.35 &&
            station.longitude >= -46.83 &&
            station.longitude <= -46.36,
      ),
      isTrue,
    );
    expect(FireStationCatalog.unitsPerStation, 2);
  });
}

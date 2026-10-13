import 'dart:convert';
import 'dart:io';

typedef FireStationPoint = ({
  String code,
  String name,
  double latitude,
  double longitude,
  String osmType,
  String osmId,
});

class FireStationCatalog {
  static const unitsPerStation = 2;
  static const assetPath = 'assets/sao_paulo_fire_stations.json';

  static Future<List<FireStationPoint>> readStations() async {
    final catalog =
        jsonDecode(await File(assetPath).readAsString())
            as Map<String, dynamic>;
    final rawStations = catalog['stations'];
    if (rawStations is! List) {
      throw const FormatException('Fire station catalog has no station list.');
    }

    return rawStations.map((rawStation) {
      if (rawStation is! Map<String, dynamic>) {
        throw const FormatException('Invalid fire station catalog entry.');
      }
      final code = rawStation['code'];
      final name = rawStation['name'];
      final latitude = rawStation['latitude'];
      final longitude = rawStation['longitude'];
      final osmType = rawStation['osmType'];
      final osmId = rawStation['osmId'];
      if (code is! String ||
          name is! String ||
          latitude is! num ||
          longitude is! num ||
          osmType is! String ||
          osmId is! String) {
        throw const FormatException('Invalid fire station catalog fields.');
      }
      return (
        code: code,
        name: name,
        latitude: latitude.toDouble(),
        longitude: longitude.toDouble(),
        osmType: osmType,
        osmId: osmId,
      );
    }).toList();
  }
}

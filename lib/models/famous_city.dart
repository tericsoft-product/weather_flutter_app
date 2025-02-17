class FamousCity {
  final String name;
  final double lat;
  final double lon;

  const FamousCity({
    required this.name,
    required this.lat,
    required this.lon,
  });
}
List<FamousCity> famousCities = const [
FamousCity(name: 'Berlin', lat: 52.52, lon: 13.4050),
FamousCity(name: 'Sydney', lat: -33.8688, lon: 151.2093),
FamousCity(name: 'Dubai', lat: 25.276987, lon: 55.296249),
FamousCity(name: 'Moscow', lat: 55.7558, lon: 37.6176),
// FamousCity(name: 'Los Angeles', lat: 34, lon: 118),
// FamousCity(name: 'Hong Kong', lat: 22, lon: 114),
FamousCity(name: 'Cape Town', lat: -33.9249, lon: 18.4241),
];

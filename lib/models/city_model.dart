class City {
  final String name;
  final double lon;
  final double lat;

  City({
    required this.name,
    required this.lon,
    required this.lat,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'],
      lon: json['coord']['lon'],
      lat: json['coord']['lat'],
    );
  }
}
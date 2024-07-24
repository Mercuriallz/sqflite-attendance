class Locations {
  final int? id;
  final String name;
  final double latitude;
  final double longitude;

  Locations({this.id, required this.name, required this.latitude, required this.longitude});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
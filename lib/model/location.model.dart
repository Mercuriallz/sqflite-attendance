class Locations {
  final int? id;
  final String name;
  final double latitude;
  final double longitude;
  final String street;
  final String state;

  Locations({this.id, required this.name, required this.latitude, required this.longitude, required this.street, required this.state});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'street': street,
      'state': state
    };
  }
}
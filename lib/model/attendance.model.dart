class Attendance {
  final int? id;
  final int locationId;
  final DateTime timestamp;
  final DateTime? checkoutTimestamp;
  final double latitude;
  final double longitude;
  final String street;
  final String state;


  Attendance({this.id, required this.locationId, required this.timestamp, required this.checkoutTimestamp, required this.latitude, required this.longitude, required this.street, required this.state});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'locationId': locationId,
      'timestamp': timestamp.toIso8601String(),
      'checkoutTimestamp': checkoutTimestamp?.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'street': street,
      'state': state
    };
  }
}
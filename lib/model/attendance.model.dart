class Attendance {
  final int? id;
  final int locationId;
  final DateTime timestamp;
  final double latitude;
  final double longitude;


  Attendance({this.id, required this.locationId, required this.timestamp, required this.latitude, required this.longitude});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'locationId': locationId,
      'timestamp': timestamp.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
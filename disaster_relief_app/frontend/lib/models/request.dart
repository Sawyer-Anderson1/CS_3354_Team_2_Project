// getting info from json file 
class Request {
  final String name;
  final String type;
  final String description;
  final double latitude;
  final double longitude;

  Request({
    required this.name,
    required this.type,
    required this.description,
    required this.latitude,
    required this.longitude,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      name: json['name'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}









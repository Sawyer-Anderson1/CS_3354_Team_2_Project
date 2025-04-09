// lib/models/resource.dart
class Resource {
  // Add the ID field, make it nullable if creating new resources client-side before sending
  final String id;
  final String name;
  final int quantity;
  final String location;
  // Add other fields corresponding to your Pydantic model (description, unit, etc.)

  Resource({
    required this.id, // ID is now required when creating from JSON
    required this.name,
    required this.quantity,
    required this.location,
    // Add others here
  });

  // Factory method to create a Resource from JSON coming from the backend API
  factory Resource.fromJson(Map<String, dynamic> json) {
    // Validate required fields exist in the JSON
    if (json['id'] == null ||
        json['name'] == null ||
        json['quantity'] == null ||
        json['location'] == null) {
      throw FormatException("Missing required fields in Resource JSON: $json");
    }
    return Resource(
      id: json['id'] as String, // Get the ID from the JSON
      name: json['name'] as String,
      // Ensure quantity is parsed correctly, handle potential type mismatches
      quantity:
          (json['quantity'] as num)
              .toInt(), // Cast to num first for flexibility
      location: json['location'] as String,
      // Add others here
    );
  }

  // Method to convert a Resource instance to JSON for sending to the backend (e.g., for POST/PUT)
  // Note: 'id' is typically NOT included when *creating* a resource (POST)
  // but IS needed for identifying which resource to *update* (PUT) or *delete* (DELETE)
  Map<String, dynamic> toJsonForCreate() {
    return {
      'name': name,
      'quantity': quantity,
      'location': location,
      // Add others here
    };
  }

  // Example for update (might only send changed fields, depends on backend PUT logic)
  Map<String, dynamic> toJsonForUpdate({
    String? newName,
    int? newQuantity,
    String? newLocation,
  }) {
    final Map<String, dynamic> data = {};
    if (newName != null) data['name'] = newName;
    if (newQuantity != null) data['quantity'] = newQuantity;
    if (newLocation != null) data['location'] = newLocation;
    // Add others here
    return data;
  }
}

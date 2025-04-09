// gettng info from json file 
class Resource {
  final String name;
  final int quantity;
  final String location;

  Resource({required this.name, required this.quantity, required this.location});

  // Factory method to create a Resource from JSON
  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      location: json['location'] as String,
    );
  }
}



// defines a model for the donation function 
// takes and sets a name, a type of donation either money or a resource, and the the detail (how much or what resource)
// easy access and model for backend integration and local data handling. Also in use with json. 
// All three access points should be useful in either the final integration or during testing 

class Donation {
  final String name;
  final String type;
  final String detail;

  Donation({
    required this.name,
    required this.type,
    required this.detail,
  });

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      name: json['name'],
      type: json['type'],
      detail: json['detail'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'detail': detail,
      };
}



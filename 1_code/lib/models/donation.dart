// getting info from json file 
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



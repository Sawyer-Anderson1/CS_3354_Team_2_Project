// getting info from json file 
class User {
  final String email;
  final String password;

  User({required this.email, required this.password});

  // Convert User to JSON format
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  // Convert JSON to User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      password: json['password'],
    );
  }
}

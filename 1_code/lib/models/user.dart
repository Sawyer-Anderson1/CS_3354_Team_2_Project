// sets the model for the user auth system
// takes an email and password 
// also converts user data that has been stored 
// this is good for the database and local data storage 
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

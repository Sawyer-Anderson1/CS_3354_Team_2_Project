// this file and model screen "models" how the data should be read from the user and stored as a json file in the local database 
// takes the alert title, description and the date of the emergency alert 
// returns an Aert Object with these 3 things 
class Alert {
  final String alertTitle;
  final String alertDescription;
  final String alertLocation ;
  final String alertDate;

  Alert({required this.alertTitle, required this.alertDescription, required this.alertLocation, required this.alertDate});

  // From JSON to Alert object
  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      alertTitle: json['alertTitle'],
      alertDescription: json['alertDescription'],
      alertLocation: json['alertLocation'] ,
      alertDate: json['alertDate'],
    );
  }
}

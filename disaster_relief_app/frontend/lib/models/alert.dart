class Alert {
  final String alertTitle;
  final String alertDescription;
  final String alertDate;

  Alert({required this.alertTitle, required this.alertDescription, required this.alertDate});

  // From JSON to Alert object
  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      alertTitle: json['alertTitle'],
      alertDescription: json['alertDescription'],
      alertDate: json['alertDate'],
    );
  }
}

import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/alert.dart';

class EmergencyAlertService {
  static Future<List<Alert>> fetchEmergencyAlerts() async {
    try {
      // Load the local JSON data using rootBundle
      final String response = await rootBundle.loadString('assets/json_files/emergency_alerts.json');
      final data = jsonDecode(response);

      // Convert the JSON data to a list of Alert objects
      return (data as List).map((alert) => Alert.fromJson(alert)).toList();
    } catch (e) {
      rethrow;  // Re-throw the error after logging it
    }
  }
}

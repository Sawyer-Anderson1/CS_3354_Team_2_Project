// UI for emergency alerts 
// Creates a basics screen and imports the model and service darts for this specific function
// displays emergency alerts 
// takes in the json data that is preloaded for delieverable 1 
// in deliberable 2, will implemented a rotating emergency alerts that is randomized and displayed 
// will be updated to stay on while emergency is active and for ones that are outdated/ dealt with, will say so

import 'package:flutter/material.dart';
import '../models/alert.dart';
import '../services/emergency_alert_service.dart';

class EmergencyAlertsScreen extends StatefulWidget {
  const EmergencyAlertsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EmergencyAlertsScreenState createState() => _EmergencyAlertsScreenState();
}

class _EmergencyAlertsScreenState extends State<EmergencyAlertsScreen> {
  late Future<List<Alert>> alerts;

  @override
  void initState() {
    super.initState();
    alerts = EmergencyAlertService.fetchEmergencyAlerts(); // Fetching alerts from local JSON
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Emergency Alerts',
          style: TextStyle(
            fontSize: 26, // Larger text size
            fontWeight: FontWeight.bold, // Make the text bold
            color: Colors.black, // Set text color to black
          ),
        ),
      ),
      body: FutureBuilder<List<Alert>>(
        future: alerts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No emergency alerts available.'));
          }

          final alertsList = snapshot.data!;

          return ListView.builder(
            itemCount: alertsList.length,
            itemBuilder: (context, index) {
              final alert = alertsList[index];
              return ListTile(
                title: Text(alert.alertTitle),
                subtitle: Text("${alert.alertDescription}\nDate: ${alert.alertDate}"),
              );
            },
          );
        },
      ),
    );
  }
}


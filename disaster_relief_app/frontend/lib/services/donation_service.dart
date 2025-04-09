// fetching data in the try catch block
// catches any errors 
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/donation.dart';

Future<List<Donation>> fetchDonations() async {
  try {
    final String response = await rootBundle.loadString('assets/donations.json');
    final List<dynamic> data = jsonDecode(response);
    return data.map((json) => Donation.fromJson(json)).toList();
  } catch (e) {
    // ignore: avoid_print
    print("Error loading donations: $e");
    rethrow;
  }
}


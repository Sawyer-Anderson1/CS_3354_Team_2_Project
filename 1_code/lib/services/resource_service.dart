import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/resource.dart';

Future<List<Resource>> fetchResources() async {
  try {
    final String response = await rootBundle.loadString('assets/json_files/resources.json');
    final data = jsonDecode(response);
    
    // ignore: avoid_print
    print("Loaded data: $data");  // Log the raw JSON data
    
    return (data as List).map((resource) => Resource.fromJson(resource)).toList();
  } catch (e) {
    // ignore: avoid_print
    print("Error loading data: $e");  // Log any errors
    rethrow;
  }
}






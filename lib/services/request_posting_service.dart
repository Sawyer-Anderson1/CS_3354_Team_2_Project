// try catches data from request.dart 
// maps the fetched data
// catches any errors 
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/request.dart';

final List<Request> _currentRequests = [];

Future<List<Request>> fetchCurrentRequests() async {
  try {
    final String response = await rootBundle.loadString('assets/json_files/current_requests.json');
    final List<dynamic> data = jsonDecode(response);
    _currentRequests.clear();
    _currentRequests.addAll(data.map((json) => Request.fromJson(json)));
    return _currentRequests;
  } catch (e) {
    // ignore: avoid_print
    print("Error loading donations: $e");
    rethrow;
  }
}

void submitRequest(Request request) {
  _currentRequests.add(request);
}











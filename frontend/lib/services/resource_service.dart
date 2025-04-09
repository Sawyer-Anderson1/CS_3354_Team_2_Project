// lib/services/resource_service.dart
import 'dart:convert'; // For jsonDecode and jsonEncode
import 'package:http/http.dart' as http; // Import the http package
import '../models/resource.dart'; // Import your Resource model

// --- Configuration ---
// Replace with your actual backend URL when deployed
// For local development with emulator/device:
// - Android Emulator: 'http://10.0.2.2:8000'
// - iOS Simulator / Physical Device on same Wi-Fi: Your machine's local IP address (e.g., 'http://192.168.1.100:8000')
// - Web: 'http://localhost:8000' (or wherever your backend runs)
const String _baseUrl = 'http://10.0.2.2:8000'; // Example for Android Emulator

// --- API Client Functions ---

/// Fetches all resources from the backend API.
Future<List<Resource>> fetchResources() async {
  final response = await http.get(Uri.parse('$_baseUrl/resources/'));

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, parse the JSON.
    List<dynamic> data = jsonDecode(response.body);
    try {
      // Map the JSON list to a list of Resource objects
      return data.map((json) => Resource.fromJson(json)).toList();
    } catch (e) {
      // Handle potential parsing errors if the backend response doesn't match the model
      print("Error parsing resources: $e");
      throw Exception('Failed to parse resources from API response.');
    }
  } else {
    // If the server did not return a 200 OK response, throw an exception.
    print('Failed to load resources: ${response.statusCode} ${response.body}');
    throw Exception(
      'Failed to load resources. Status code: ${response.statusCode}',
    );
  }
}

/// Fetches a single resource by its ID.
Future<Resource> fetchResourceById(String id) async {
  final response = await http.get(Uri.parse('$_baseUrl/resources/$id'));

  if (response.statusCode == 200) {
    try {
      return Resource.fromJson(jsonDecode(response.body));
    } catch (e) {
      print("Error parsing resource $id: $e");
      throw Exception('Failed to parse resource from API response.');
    }
  } else if (response.statusCode == 404) {
    throw Exception('Resource with id $id not found.');
  } else {
    print(
      'Failed to load resource $id: ${response.statusCode} ${response.body}',
    );
    throw Exception(
      'Failed to load resource. Status code: ${response.statusCode}',
    );
  }
}

/// Adds a new resource via the backend API.
/// Takes the data needed to create a resource (excluding ID).
Future<Resource> addResource({
  required String name,
  required int quantity,
  required String location,
  // Add other required fields from ResourceCreate model
}) async {
  // Create a map matching the ResourceCreate Pydantic model
  final Map<String, dynamic> resourceData = {
    'name': name,
    'quantity': quantity,
    'location': location,
    // Add others
  };

  final response = await http.post(
    Uri.parse('$_baseUrl/resources/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      // Add Authorization header if needed: 'Authorization': 'Bearer YOUR_TOKEN',
    },
    body: jsonEncode(resourceData), // Encode the data map to JSON
  );

  if (response.statusCode == 201) {
    // 201 Created
    // If the server returns a 201 Created response, parse the created resource (including ID)
    try {
      return Resource.fromJson(jsonDecode(response.body));
    } catch (e) {
      print("Error parsing created resource: $e");
      throw Exception('Failed to parse created resource from API response.');
    }
  } else {
    // Handle errors (e.g., validation errors, server errors)
    print('Failed to add resource: ${response.statusCode} ${response.body}');
    throw Exception(
      'Failed to add resource. Status code: ${response.statusCode}',
    );
  }
}

/// Updates an existing resource by its ID.
/// Only sends the fields that are provided (not null).
Future<Resource> updateResource(
  String id, {
  String? name,
  int? quantity,
  String? location,
  // Add other optional fields from ResourceUpdate
}) async {
  // Create a map containing only the fields to be updated
  final Map<String, dynamic> updateData = {};
  if (name != null) updateData['name'] = name;
  if (quantity != null) updateData['quantity'] = quantity;
  if (location != null) updateData['location'] = location;
  // Add others

  if (updateData.isEmpty) {
    // Optionally, fetch and return the current resource if no updates are provided
    // Or throw an error/return null, depending on desired behavior
    print('No update data provided for resource $id.');
    return fetchResourceById(id); // Example: return current data
    // throw ArgumentError('No update data provided.');
  }

  final response = await http.put(
    Uri.parse('$_baseUrl/resources/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      // Add Authorization header if needed
    },
    body: jsonEncode(updateData),
  );

  if (response.statusCode == 200) {
    try {
      return Resource.fromJson(jsonDecode(response.body));
    } catch (e) {
      print("Error parsing updated resource $id: $e");
      throw Exception('Failed to parse updated resource from API response.');
    }
  } else if (response.statusCode == 404) {
    throw Exception('Resource with id $id not found for update.');
  } else {
    print(
      'Failed to update resource $id: ${response.statusCode} ${response.body}',
    );
    throw Exception(
      'Failed to update resource. Status code: ${response.statusCode}',
    );
  }
}

/// Deletes a resource by its ID.
Future<void> deleteResource(String id) async {
  final response = await http.delete(
    Uri.parse('$_baseUrl/resources/$id'),
    headers: <String, String>{
      // Add Authorization header if needed
    },
  );

  if (response.statusCode == 204) {
    // Successfully deleted, no content returned
    print('Resource $id deleted successfully.');
    return;
  } else if (response.statusCode == 404) {
    throw Exception('Resource with id $id not found for deletion.');
  } else {
    // Handle other potential errors
    print(
      'Failed to delete resource $id: ${response.statusCode} ${response.body}',
    );
    throw Exception(
      'Failed to delete resource. Status code: ${response.statusCode}',
    );
  }
}

    // --- Add functions for other services (Donations, Auth, etc.) similarly ---
    
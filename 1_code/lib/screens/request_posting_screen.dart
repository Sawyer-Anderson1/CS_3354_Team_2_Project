// UI for user request screen 
// Creates a basics screen and imports the model and service darts for this specific function
// Asks the user for the name, aidtype, and description
// Also has a geo locator to see the users current and direct location 

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/request.dart';
import '../services/request_posting_service.dart';

class RequestPostingScreen extends StatefulWidget {
  const RequestPostingScreen({super.key});

  @override
  State<RequestPostingScreen> createState() => _RequestPostingScreenState();
}

class _RequestPostingScreenState extends State<RequestPostingScreen> {
  final _formKey = GlobalKey<FormState>();
  String _aidType = 'Medical';
  String _description = '';
  String _name = '';
  Position? _location;
  late Future<List<Request>> _currentRequests;

  @override
  void initState() {
    super.initState();
    _currentRequests = fetchCurrentRequests();
  }

  Future<void> _getLocation() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
    final position = await Geolocator.getCurrentPosition();
    setState(() => _location = position);
  }

  void _submitRequest() {
    if (_formKey.currentState!.validate() && _location != null) {
      _formKey.currentState!.save();

      final request = Request(
        name: _name,
        type: _aidType,
        description: _description,
        latitude: _location!.latitude,
        longitude: _location!.longitude,
      );

      submitRequest(request);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request submitted.')),
      );

      setState(() {
        _currentRequests = Future.value(_currentRequestsList);
        // Reset the form fields and location
        _formKey.currentState!.reset();
        _location = null;
        _aidType = 'Medical';
        _description = '';
        _name = '';
      });
    }
  }

  List<Request> get _currentRequestsList => _location != null ? _currentRequestsListInternal : [];

  List<Request> _currentRequestsListInternal = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Submit Aid Request',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Your Name'),
                    onSaved: (value) => _name = value ?? '',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _aidType,
                    items: ['Medical', 'Food', 'Shelter']
                        .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                        .toList(),
                    onChanged: (value) => setState(() => _aidType = value!),
                    decoration: const InputDecoration(labelText: 'Aid Type'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Description'),
                    onSaved: (value) => _description = value ?? '',
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _getLocation,
                    child: const Text('Get My Location'),
                  ),
                  if (_location != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Lat: ${_location!.latitude}, Long: ${_location!.longitude}',
                      ),
                    ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _submitRequest,
                    child: const Text('Submit Request'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const Text(
              "Current Requests for Help:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<Request>>(
              future: _currentRequests,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading requests.'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No current requests for help.'));
                }

                final requests = snapshot.data!;
                _currentRequestsListInternal = requests;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final request = requests[index];
                    return ListTile(
                      title: Text('${request.name} - ${request.type}'),
                      subtitle: Text('${request.description}\nLat: ${request.latitude}, Long: ${request.longitude}'),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


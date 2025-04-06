import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class RequestPostingScreen extends StatefulWidget {
  const RequestPostingScreen({super.key});

  @override
  State<RequestPostingScreen> createState() => _RequestPostingScreenState();
}

class _RequestPostingScreenState extends State<RequestPostingScreen> {
  final _formKey = GlobalKey<FormState>();
  String _aidType = 'Medical';
  String _description = '';
  Position? _location;

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

      final requestData = {
        'type': _aidType,
        'description': _description,
        'latitude': _location!.latitude,
        'longitude': _location!.longitude,
      };

      // TODO: Replace with actual POST call to backend
      print('Submitting aid request: $requestData');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request submitted (mocked).')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submit Aid Request')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _aidType,
                items:
                    ['Medical', 'Food', 'Shelter']
                        .map(
                          (type) =>
                              DropdownMenuItem(value: type, child: Text(type)),
                        )
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
      ),
    );
  }
}

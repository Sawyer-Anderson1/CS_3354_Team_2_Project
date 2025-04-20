import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/request.dart';
import '../services/request_posting_service.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class RequestPostingScreen extends StatefulWidget {
  const RequestPostingScreen({super.key});

  @override
  State<RequestPostingScreen> createState() => _RequestPostingScreenState();
}

class ScalableMarker extends StatefulWidget {
  final VoidCallback onTap;

  const ScalableMarker({super.key, required this.onTap});

  @override
  State<ScalableMarker> createState() => _ScalableMarkerState();
}

class _ScalableMarkerState extends State<ScalableMarker> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.6 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: const Icon(Icons.location_pin, color: Colors.red, size: 30),
        ),
      ),
    );
  }
}

class _RequestPostingScreenState extends State<RequestPostingScreen> {
  final _formKey = GlobalKey<FormState>();
  String _aidType = 'Medical';
  String _description = '';
  String _name = '';
  Position? _location;
  bool _locationMissingError = false;
  final List<Request> _submittedRequests = [];

  Future<void> _getLocation() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _location = position;
      _locationMissingError = false;
    });
  }

  void _submitRequest() {
    setState(() {
      _locationMissingError = _location == null;
    });

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

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Request submitted.')));

      setState(() {
        _submittedRequests.add(request);
        _formKey.currentState!.reset();
        _location = null;
        _aidType = 'Medical';
        _description = '';
        _name = '';
        _locationMissingError = false;
      });
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.deepPurple.shade400,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "SUBMIT AID REQUEST",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: _inputDecoration('Name'),
            onSaved: (value) => _name = value ?? '',
            validator:
                (value) =>
                    (value == null || value.isEmpty)
                        ? 'Please enter your name'
                        : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: _inputDecoration('Description'),
            maxLines: 3,
            onSaved: (value) => _description = value ?? '',
            validator:
                (value) =>
                    (value == null || value.isEmpty)
                        ? 'Please enter a description'
                        : null,
          ),
          const SizedBox(height: 16),
          const Text("Aid Type", style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children:
                ['Food', 'Medical', 'Shelter'].map((type) {
                  final isSelected = _aidType == type;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            type == 'Medical'
                                ? Icons.add
                                : type == 'Food'
                                ? Icons.restaurant
                                : Icons.home,
                            size: 16,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                          const SizedBox(width: 4),
                          Text(type),
                        ],
                      ),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _aidType = type),
                      selectedColor: Colors.deepPurple,
                      backgroundColor: Colors.grey.shade200,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _getLocation,
              icon: const Icon(Icons.my_location),
              label: const Text("Get My Location"),
              style: _buttonStyle(),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitRequest,
              style: _buttonStyle().copyWith(
                minimumSize: MaterialStateProperty.all(
                  const Size.fromHeight(50),
                ),
                backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
              ),
              child: const Text("SUBMIT"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F2F7),
      appBar: AppBar(
        title: const Text(
          'Submit Aid Request',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        elevation: 4,
        backgroundColor: Colors.deepPurple.shade600,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Map section
                      Expanded(
                        child: SizedBox(
                          height: 460,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 360,
                                  child: FlutterMap(
                                    options: MapOptions(
                                      initialCenter:
                                          _location != null
                                              ? LatLng(
                                                _location!.latitude,
                                                _location!.longitude,
                                              )
                                              : LatLng(34.0522, -118.2437),
                                      initialZoom: 5,
                                      interactiveFlags:
                                          InteractiveFlag.pinchZoom |
                                          InteractiveFlag.drag,
                                    ),
                                    children: [
                                      TileLayer(
                                        urlTemplate:
                                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                        userAgentPackageName: 'com.example.app',
                                      ),
                                      if (_location != null)
                                        MarkerLayer(
                                          markers: [
                                            Marker(
                                              width: 40,
                                              height: 40,
                                              point: LatLng(
                                                _location!.latitude,
                                                _location!.longitude,
                                              ),
                                              child: ScalableMarker(
                                                onTap: () {
                                                  debugPrint("Pin tapped!");
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (_location != null)
                                Text(
                                  'Lat: ${_location!.latitude.toStringAsFixed(3)}, Lon: ${_location!.longitude.toStringAsFixed(3)}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xFF2E2E3A),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(child: _buildForm()),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// UI to update resource inventory
import 'package:flutter/material.dart';
import '../models/resource.dart';
// ignore: library_prefixes
import '../services/resource_service.dart' as ResourceService;

class ResourceInventoryScreen extends StatefulWidget {
  const ResourceInventoryScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ResourceInventoryScreenState createState() => _ResourceInventoryScreenState();
}

class _ResourceInventoryScreenState extends State<ResourceInventoryScreen> {
  late Future<List<Resource>> resources;

  @override
  void initState() {
    super.initState();
    resources = ResourceService.fetchResources(); // Fetching resources from local JSON
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Resource Inventory',
          style: TextStyle(
            fontSize: 26, // Larger text size
            fontWeight: FontWeight.bold, // Make the text bold
            color: Colors.black, // Set text color to black
          ),
        ),
      ),
      body: FutureBuilder<List<Resource>>(
        future: resources,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No resources available.'));
          }

          final resourcesList = snapshot.data!;

          return ListView.builder(
            itemCount: resourcesList.length,
            itemBuilder: (context, index) {
              final resource = resourcesList[index];
              // ignore: avoid_print
              print("Resource: ${resource.name}");  // Log each resource name
              return ListTile(
                title: Text(resource.name),
                subtitle: Text("${resource.quantity} units - ${resource.location}"),
              );
            },
          );
        },
      ),
    );
  }
}


import 'package:flutter/material.dart';
import '../services/request_service.dart';

class RequestDetailScreen extends StatefulWidget {
  final Map<String, dynamic> request;

  const RequestDetailScreen({Key? key, required this.request}) : super(key: key);

  @override
  _RequestDetailScreenState createState() => _RequestDetailScreenState();
}

class _RequestDetailScreenState extends State<RequestDetailScreen> {
  final _requestService = RequestService();
  bool _isLoading = false;

  Future<void> _updateStatus(String status) async {
    setState(() => _isLoading = true);
    try {
      await _requestService.updateRequestStatus(widget.request['id'], status);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating status: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.request['title']),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.request['title'],
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text(widget.request['status']),
              backgroundColor: _getStatusColor(widget.request['status']),
            ),
            const SizedBox(height: 16),
            Text(
              'Description',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(widget.request['description']),
            const SizedBox(height: 16),
            Text(
              'Location',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(widget.request['location']),
            const SizedBox(height: 16),
            Text(
              'Priority',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(widget.request['priority']),
            const SizedBox(height: 16),
            if (widget.request['assigned_volunteer'] != null) ...[
              Text(
                'Assigned Volunteer',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(widget.request['assigned_volunteer']['name']),
            ],
            const SizedBox(height: 24),
            if (!_isLoading && widget.request['status'] == 'pending')
              ElevatedButton(
                onPressed: () => _updateStatus('in_progress'),
                child: const Text('Start Helping'),
              ),
            if (!_isLoading && widget.request['status'] == 'in_progress')
              ElevatedButton(
                onPressed: () => _updateStatus('completed'),
                child: const Text('Mark as Completed'),
              ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'in_progress':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
} 
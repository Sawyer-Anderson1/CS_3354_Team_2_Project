// UI for donation screen
// Creates a basics screen and imports the model and service darts for this specific function
// Asks the user for its name, type of donation, and description of the donation 

import 'package:flutter/material.dart';
import '../models/donation.dart';
import '../services/donation_service.dart';

class DonationScreen extends StatefulWidget {
  const DonationScreen({super.key});

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<Donation> _donations = [];
  final TextEditingController _detailController = TextEditingController();

  String _name = '';
  String _type = 'Money';
  String _detail = '';

  @override
  void initState() {
    super.initState();
    _loadDonations();
    _detailController.text = '\$'; // Start with $ by default since default type is Money
  }

  @override
  void dispose() {
    _detailController.dispose();
    super.dispose();
  }

  void _loadDonations() async {
    final donations = await fetchDonations();
    setState(() {
      _donations.addAll(donations);
    });
  }

  void _submitDonation() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _detail = _detailController.text;

      final newDonation = Donation(name: _name, type: _type, detail: _detail);

      setState(() {
        _donations.add(newDonation);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Thanks $_name for donating $_detail ($_type)'),
        ),
      );

      _formKey.currentState!.reset();
      _type = 'Money';
      _detailController.text = '\$';
    }
  }

  void _handleTypeChange(String? newType) {
    if (newType == null) return;
    setState(() {
      _type = newType;
      if (_type == 'Money') {
        if (!_detailController.text.startsWith('\$')) {
          _detailController.text = '\$';
        }
      } else {
        _detailController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Make a Donation',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Your Name"),
                    validator: (value) => value == null || value.isEmpty ? "Enter your name" : null,
                    onSaved: (value) => _name = value!,
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _type,
                    items: ['Money', 'Resource'].map((type) {
                      return DropdownMenuItem(value: type, child: Text(type));
                    }).toList(),
                    onChanged: _handleTypeChange,
                    decoration: const InputDecoration(labelText: "Donation Type"),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _detailController,
                    decoration: const InputDecoration(labelText: "Amount / Description"),
                    validator: (value) => value == null || value.isEmpty ? "Enter a description" : null,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _submitDonation,
                    // ignore: sort_child_properties_last
                    child: const Text("Donate"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const Text("All Donations:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: _donations.length,
                itemBuilder: (context, index) {
                  final d = _donations[index];
                  return ListTile(
                    leading: const Icon(Icons.volunteer_activism),
                    title: Text("${d.name} donated ${d.detail}"),
                    subtitle: Text(d.type),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

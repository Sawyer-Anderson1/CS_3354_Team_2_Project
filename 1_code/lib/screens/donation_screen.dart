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
    _detailController.text =
        '\$'; // Start with $ by default since default type is Money
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
        SnackBar(content: Text('Thanks $_name for donating $_detail ($_type)')),
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
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Your Name",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? "Enter your name"
                                : null,
                    onSaved: (value) => _name = value!,
                  ),
                  const SizedBox(height: 16),
                  const Text("Donation Type", style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var type in ['Money', 'Resource'])
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: ChoiceChip(
                              label: Center(child: Text(type)),
                              selected: _type == type,
                              onSelected: (_) => _handleTypeChange(type),
                              selectedColor: Colors.deepPurple,
                              backgroundColor: Colors.grey.shade200,
                              labelStyle: TextStyle(
                                color:
                                    _type == type ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _detailController,
                    decoration: InputDecoration(
                      labelText: "Amount / Description",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? "Enter a description"
                                : null,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _submitDonation,
                      icon: const Icon(Icons.favorite),
                      label: const Text("Donate"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Divider(),
            const Text(
              "All Donations:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child:
                  _donations.isEmpty
                      ? const Center(child: Text("No donations yet."))
                      : ListView.builder(
                        padding: const EdgeInsets.only(top: 10),
                        itemCount: _donations.length,
                        itemBuilder: (context, index) {
                          final d = _donations[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                            child: ListTile(
                              leading: const Icon(
                                Icons.volunteer_activism,
                                color: Colors.deepPurple,
                              ),
                              title: Text(
                                "${d.name} donated ${d.detail}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(d.type),
                            ),
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

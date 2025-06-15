import 'package:flutter/material.dart';

class CheckUserScreen extends StatefulWidget {
  final String policeId;

  const CheckUserScreen({
    super.key,
    required this.policeId,
  });

  @override
  State<CheckUserScreen> createState() => _CheckUserScreenState();
}

class _CheckUserScreenState extends State<CheckUserScreen> {
  final _searchController = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic>? _userData;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchUser() {
    setState(() {
      _isLoading = true;
    });
    // TODO: Implement actual API call
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
        _userData = {
          'name': 'John Doe',
          'licenseNumber': 'DL123456',
          'expiryDate': '2024-12-31',
          'status': 'Valid',
          'vehicleClass': 'B',
          'address': '123 Main St, City',
          'phone': '+1234567890',
        };
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check User ID / License'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Enter User ID or License Number',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _searchUser,
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_userData != null)
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'License Information',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const Divider(),
                          _buildInfoRow('Name', _userData!['name']),
                          _buildInfoRow(
                              'License Number', _userData!['licenseNumber']),
                          _buildInfoRow(
                              'Expiry Date', _userData!['expiryDate']),
                          _buildInfoRow('Status', _userData!['status']),
                          _buildInfoRow(
                              'Vehicle Class', _userData!['vehicleClass']),
                          _buildInfoRow('Address', _userData!['address']),
                          _buildInfoRow('Phone', _userData!['phone']),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  // TODO: Implement verify action
                                },
                                icon: const Icon(Icons.check_circle),
                                label: const Text('Verify'),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  // TODO: Implement report action
                                },
                                icon: const Icon(Icons.report),
                                label: const Text('Report'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

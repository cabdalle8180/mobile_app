import 'package:flutter/material.dart';

class ExpiringLicensesScreen extends StatefulWidget {
  final String policeId;

  const ExpiringLicensesScreen({
    super.key,
    required this.policeId,
  });

  @override
  State<ExpiringLicensesScreen> createState() => _ExpiringLicensesScreenState();
}

class _ExpiringLicensesScreenState extends State<ExpiringLicensesScreen> {
  String _selectedFilter = 'All';
  final bool _isLoading = false;

  final List<String> _filterOptions = [
    'All',
    'Expiring Soon',
    'Expired',
    'Recently Renewed',
  ];

  // TODO: Replace with actual API data
  final List<Map<String, dynamic>> _licenses = [
    {
      'name': 'John Doe',
      'licenseNumber': 'DL123456',
      'expiryDate': '2024-03-15',
      'status': 'Expiring Soon',
      'daysLeft': 15,
    },
    {
      'name': 'Jane Smith',
      'licenseNumber': 'DL789012',
      'expiryDate': '2024-02-28',
      'status': 'Expiring Soon',
      'daysLeft': 5,
    },
    {
      'name': 'Mike Johnson',
      'licenseNumber': 'DL345678',
      'expiryDate': '2024-01-31',
      'status': 'Expired',
      'daysLeft': -2,
    },
    {
      'name': 'Sarah Wilson',
      'licenseNumber': 'DL901234',
      'expiryDate': '2024-12-31',
      'status': 'Valid',
      'daysLeft': 300,
    },
  ];

  List<Map<String, dynamic>> get _filteredLicenses {
    switch (_selectedFilter) {
      case 'Expiring Soon':
        return _licenses
            .where((license) =>
                license['daysLeft'] > 0 && license['daysLeft'] <= 30)
            .toList();
      case 'Expired':
        return _licenses.where((license) => license['daysLeft'] < 0).toList();
      case 'Recently Renewed':
        return _licenses
            .where((license) => license['status'] == 'Recently Renewed')
            .toList();
      default:
        return _licenses;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitor Expiring Licenses'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Text(
                    'Filter:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedFilter,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      items: _filterOptions.map((String filter) {
                        return DropdownMenuItem<String>(
                          value: filter,
                          child: Text(filter),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedFilter = newValue;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _filteredLicenses.length,
                      itemBuilder: (context, index) {
                        final license = _filteredLicenses[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      license['name'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    _buildStatusChip(license['status']),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                _buildInfoRow(
                                    'License Number', license['licenseNumber']),
                                _buildInfoRow(
                                    'Expiry Date', license['expiryDate']),
                                _buildInfoRow(
                                  'Days Left',
                                  '${license['daysLeft']} days',
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () {
                                        // TODO: Implement view details
                                      },
                                      icon: const Icon(Icons.visibility),
                                      label: const Text('View Details'),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        // TODO: Implement send notification
                                      },
                                      icon: const Icon(Icons.notifications),
                                      label: const Text('Send Notification'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'Expiring Soon':
        color = Colors.orange;
        break;
      case 'Expired':
        color = Colors.red;
        break;
      case 'Recently Renewed':
        color = Colors.green;
        break;
      default:
        color = Colors.blue;
    }

    return Chip(
      label: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
      backgroundColor: color,
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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

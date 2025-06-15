import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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
  final _violationController = TextEditingController();
  final _amountController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic>? _userData;
  String? _errorMessage;
  bool _showFineForm = false;

  final List<String> _violationTypes = [
    'Speeding',
    'Running Red Light',
    'Illegal Parking',
    'Reckless Driving',
    'No Seat Belt',
    'Using Mobile Phone',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.policeId.isEmpty) {
      Future.microtask(() {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please log in as a police officer'),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _violationController.dispose();
    _amountController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _searchUser() async {
    if (_searchController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a license number or ID';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _showFineForm = false;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final users = prefs.getStringList('users') ?? [];

      // Search for the user
      for (final user in users) {
        final userData = jsonDecode(user) as Map<String, dynamic>;
        if (userData['licenseNumber'] == _searchController.text) {
          setState(() {
            _userData = userData;
            _isLoading = false;
          });
          return;
        }
      }

      // If user not found
      setState(() {
        _errorMessage = 'No license found with this number';
        _isLoading = false;
        _userData = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error searching for license';
        _isLoading = false;
        _userData = null;
      });
    }
  }

  Future<void> _issueFine() async {
    if (_violationController.text.isEmpty || _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final fines = prefs.getStringList('fines') ?? [];

      // Create fine record
      final fine = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'licenseNumber': _userData!['licenseNumber'],
        'policeId': widget.policeId,
        'violationType': _violationController.text,
        'amount': double.parse(_amountController.text),
        'location': _locationController.text,
        'notes': _notesController.text,
        'date': DateTime.now().toIso8601String(),
        'status': 'Pending',
      };

      // Add fine to list
      fines.add(jsonEncode(fine));
      await prefs.setStringList('fines', fines);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fine issued successfully'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _showFineForm = false;
          _violationController.clear();
          _amountController.clear();
          _locationController.clear();
          _notesController.clear();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
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
        title: Text(
          'Check License & Issue Fine',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Search License',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Enter License Number or ID',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: _searchUser,
                        ),
                        errorText: _errorMessage,
                      ),
                      keyboardType: TextInputType.text,
                      onSubmitted: (_) => _searchUser(),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _searchUser,
                      icon: const Icon(Icons.search),
                      label: const Text('Search'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_userData != null) ...[
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'License Information',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _userData!['status'] == 'Valid'
                                  ? Colors.green
                                  : Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _userData!['status'],
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                      _buildInfoSection('Personal Information', [
                        _buildInfoRow('Name', _userData!['name']),
                        _buildInfoRow(
                            'Date of Birth', _userData!['dateOfBirth']),
                        _buildInfoRow('Blood Group', _userData!['bloodGroup']),
                        _buildInfoRow('Nationality', _userData!['nationality']),
                      ]),
                      const SizedBox(height: 24),
                      _buildInfoSection('License Details', [
                        _buildInfoRow(
                            'License Number', _userData!['licenseNumber']),
                        _buildInfoRow('Issue Date', _userData!['issueDate']),
                        _buildInfoRow('Expiry Date', _userData!['expiryDate']),
                        _buildInfoRow(
                            'Vehicle Class', _userData!['vehicleClass']),
                        _buildInfoRow(
                            'Restrictions', _userData!['restrictions']),
                        _buildInfoRow(
                            'Endorsements', _userData!['endorsements']),
                      ]),
                      const SizedBox(height: 24),
                      _buildInfoSection('Contact Information', [
                        _buildInfoRow('Address', _userData!['address']),
                        _buildInfoRow('Phone', _userData!['phone']),
                      ]),
                      const SizedBox(height: 24),
                      if (!_showFineForm)
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _showFineForm = true;
                            });
                          },
                          icon: const Icon(Icons.receipt_long),
                          label: const Text('Issue Fine'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                          ),
                        )
                      else
                        Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Issue Fine',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    labelText: 'Violation Type',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.warning),
                                  ),
                                  items: _violationTypes.map((String type) {
                                    return DropdownMenuItem<String>(
                                      value: type,
                                      child: Text(type),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      _violationController.text = newValue;
                                    }
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: _amountController,
                                  decoration: const InputDecoration(
                                    labelText: 'Fine Amount (USD)',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.attach_money),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: _locationController,
                                  decoration: const InputDecoration(
                                    labelText: 'Location',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.location_on),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: _notesController,
                                  decoration: const InputDecoration(
                                    labelText: 'Additional Notes',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.note),
                                  ),
                                  maxLines: 3,
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            _showFineForm = false;
                                          });
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: _issueFine,
                                        child: const Text('Issue Fine'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

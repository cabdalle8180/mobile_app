import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PoliceReportsScreen extends StatefulWidget {
  const PoliceReportsScreen({super.key});

  @override
  State<PoliceReportsScreen> createState() => _PoliceReportsScreenState();
}

class _PoliceReportsScreenState extends State<PoliceReportsScreen> {
  bool _isLoading = false;
  List<Map<String, dynamic>> _reports = [];

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    setState(() => _isLoading = true);

    try {
      // TODO: Implement actual reports loading API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock data for demonstration
      setState(() {
        _reports = [
          {
            'id': 'R001',
            'type': 'Traffic Violation',
            'date': '2024-03-15',
            'status': 'Completed',
            'details': 'Speeding violation on Main Street',
            'licenseNumber': 'DL123456',
          },
          {
            'id': 'R002',
            'type': 'Accident Report',
            'date': '2024-03-14',
            'status': 'Pending',
            'details': 'Minor collision at intersection',
            'licenseNumber': 'DL789012',
          },
          {
            'id': 'R003',
            'type': 'Fine Issued',
            'date': '2024-03-13',
            'status': 'Completed',
            'details': 'Parking violation in restricted area',
            'licenseNumber': 'DL345678',
          },
        ];
      });
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
        title: const Text('Reports'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadReports,
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: _reports.length,
                itemBuilder: (context, index) {
                  final report = _reports[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              report['type'],
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: report['status'] == 'Completed'
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              report['status'],
                              style: GoogleFonts.poppins(
                                color: report['status'] == 'Completed'
                                    ? Colors.green
                                    : Colors.orange,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            report['details'],
                            style: GoogleFonts.poppins(
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.badge,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'License: ${report['licenseNumber']}',
                                style: GoogleFonts.poppins(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                report['date'],
                                style: GoogleFonts.poppins(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      onTap: () {
                        // TODO: Implement report details view
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}

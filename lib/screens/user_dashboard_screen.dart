import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/navigation_service.dart';
import 'welcome_screen.dart';
import 'digital_card_screen.dart';
import 'user_notifications_screen.dart';
import 'renew_license_screen.dart';
import 'payment_screen.dart';
import 'documents_screen.dart';
import 'emergency_contact_screen.dart';

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({Key? key}) : super(key: key);

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  late final AuthService authService;
  late Map<String, dynamic> _userData;

  @override
  void initState() {
    super.initState();
    authService = Provider.of<AuthService>(context, listen: false);
    _userData = {
      'name': 'John Doe',
      'licenseNumber': authService.userId ?? 'N/A',
      'expiryDate': '2024-12-31',
      'status': 'Active',
      'points': 12,
      'vehicleClass': 'B',
      'address': '123 Main St, Mogadishu',
      'dateOfBirth': '1990-01-01',
      'bloodGroup': 'O+',
      'nationality': 'Somali',
      'emergencyContact': {
        'name': 'Jane Doe',
        'relationship': 'Spouse',
        'phone': '+252 61 234 5678',
      },
      'documents': {
        'medicalCertificate': {
          'status': 'Valid',
          'expiryDate': '2024-12-31',
        },
        'proofOfAddress': {
          'status': 'Valid',
          'expiryDate': '2024-12-31',
        },
        'idCard': {
          'status': 'Pending',
          'expiryDate': null,
        },
      },
    };
  }

  void _handleLogout() {
    authService.logout();
    NavigationService.navigateToUserLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, ${_userData['name']}',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'License #${_userData['licenseNumber']}',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildQuickActions(context, authService.userId),
            const SizedBox(height: 24),
            _buildEmergencyContact(),
          ],
        ),
      ),
    );
  }

  Widget _buildDigitalCard(BuildContext context, AuthService authService) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'DRIVING LICENSE',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        authService.licenseStatus,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Text(
                          authService.userName
                                  ?.split(' ')
                                  .map((e) => e[0])
                                  .join('') ??
                              '',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            authService.userName ?? '',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'License #${authService.userId}',
                            style: GoogleFonts.poppins(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                _buildCardInfoRow(
                    'Vehicle Class', authService.vehicleClass ?? ''),
                const SizedBox(height: 12),
                _buildCardInfoRow(
                    'Date of Birth', authService.dateOfBirth ?? ''),
                const SizedBox(height: 12),
                _buildCardInfoRow('Blood Group', authService.bloodGroup ?? ''),
                const SizedBox(height: 12),
                _buildCardInfoRow('Nationality', authService.nationality ?? ''),
                const SizedBox(height: 12),
                _buildCardInfoRow('Expiry Date', authService.expiryDate ?? ''),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, String? userId) {
    if (userId == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            _buildActionCard(
              context,
              'Pay Fees',
              Icons.payment,
              Colors.blue,
              () {
                NavigationService.navigateToPayments(
                  context,
                  amount: 50.0,
                  serviceType: 'license_fee',
                );
              },
            ),
            _buildActionCard(
              context,
              'Documents',
              Icons.description,
              Colors.orange,
              () {
                NavigationService.navigateToLicenseCard(context);
              },
            ),
            _buildActionCard(
              context,
              'Renew License',
              Icons.refresh,
              Colors.green,
              () {
                NavigationService.navigateToPayments(
                  context,
                  amount: 50.0,
                  serviceType: 'license_renewal',
                );
              },
            ),
            _buildActionCard(
              context,
              'Digital Card',
              Icons.credit_card,
              Colors.purple,
              () {
                NavigationService.navigateToLicenseCard(context);
              },
            ),
            _buildActionCard(
              context,
              'Emergency Contact',
              Icons.emergency,
              Colors.red,
              () {
                NavigationService.navigateToEmergencyContact(
                  context,
                  initialData: {
                    'name': '',
                    'relationship': '',
                    'phone': '',
                    'address': '',
                  },
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: 12),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyContact() {
    final contact = _userData['emergencyContact'] as Map<String, dynamic>;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Emergency Contact',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contact['name'] as String,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${contact['relationship']} • ${contact['phone']}',
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDocuments() {
    final documents = _userData['documents'] as Map<String, dynamic>;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Documents',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildDocumentItem(
              'Medical Certificate',
              documents['medicalCertificate'],
              Icons.medical_services,
              Colors.blue,
            ),
            _buildDocumentItem(
              'Proof of Address',
              documents['proofOfAddress'],
              Icons.home,
              Colors.green,
            ),
            _buildDocumentItem(
              'ID Card',
              documents['idCard'],
              Icons.badge,
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentItem(
    String title,
    Map<String, dynamic> data,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Status: ${data['status']}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: data['status'] == 'Valid'
                        ? Colors.green
                        : Colors.orange,
                  ),
                ),
              ],
            ),
          ),
          if (data['expiryDate'] != null)
            Text(
              'Expires: ${data['expiryDate']}',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
        ],
      ),
    );
  }
}

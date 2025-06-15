import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:screenshot/screenshot.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;

class DigitalCardScreen extends StatefulWidget {
  final String userId;

  const DigitalCardScreen({
    super.key,
    required this.userId,
  });

  @override
  State<DigitalCardScreen> createState() => _DigitalCardScreenState();
}

class _DigitalCardScreenState extends State<DigitalCardScreen> {
  final _screenshotController = ScreenshotController();
  bool _isOfflineMode = false;
  late final encrypt.Key _encryptionKey;
  late final encrypt.IV _iv;

  // TODO: Replace with actual API data
  final Map<String, dynamic> _licenseData = {
    'name': 'John Doe',
    'licenseNumber': 'DL123456',
    'expiryDate': '2024-12-31',
    'issueDate': '2020-12-31',
    'vehicleClass': 'B',
    'address': '123 Main St, Mogadishu',
    'dateOfBirth': '1990-01-01',
    'bloodGroup': 'O+',
    'nationality': 'Somali',
    'photoUrl': 'https://example.com/photo.jpg',
  };

  @override
  void initState() {
    super.initState();
    _initializeEncryption();
  }

  void _initializeEncryption() {
    // In a real app, these would be securely stored and managed
    const keyString = 'your-32-char-secret-key-here!!!!!';
    _encryptionKey = encrypt.Key.fromUtf8(keyString);
    _iv = encrypt.IV.fromLength(16);
  }

  String _generateVerificationData() {
    final timestamp = DateTime.now().toIso8601String();
    final data = {
      'licenseNumber': _licenseData['licenseNumber'],
      'name': _licenseData['name'],
      'expiryDate': _licenseData['expiryDate'],
      'timestamp': timestamp,
      'userId': widget.userId,
    };

    // Create a hash of the data for verification
    final dataString = json.encode(data);
    final hash = sha256.convert(utf8.encode(dataString)).toString();

    // Encrypt the data
    final encrypter = encrypt.Encrypter(encrypt.AES(_encryptionKey));
    final encryptedData = encrypter.encrypt(dataString, iv: _iv);

    // Combine encrypted data and hash
    final verificationData = {
      'data': encryptedData.base64,
      'hash': hash,
      'iv': _iv.base64,
    };

    return json.encode(verificationData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Driver\'s Card'),
        actions: [
          IconButton(
            icon: Icon(_isOfflineMode ? Icons.cloud_off : Icons.cloud),
            onPressed: _toggleOfflineMode,
            tooltip: _isOfflineMode ? 'Offline Mode' : 'Online Mode',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareCard,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Screenshot(
              controller: _screenshotController,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildCardHeader(),
                      const SizedBox(height: 16),
                      _buildCardContent(),
                      const SizedBox(height: 16),
                      _buildQRCode(),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildOfflineInstructions(),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.blue.shade100,
          child: Text(
            _licenseData['name'].split(' ').map((e) => e[0]).join(''),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _licenseData['name'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'License #${_licenseData['licenseNumber']}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCardContent() {
    return Column(
      children: [
        _buildInfoRow('Expiry Date', _licenseData['expiryDate']),
        _buildInfoRow('Issue Date', _licenseData['issueDate']),
        _buildInfoRow('Vehicle Class', _licenseData['vehicleClass']),
        _buildInfoRow('Address', _licenseData['address']),
        _buildInfoRow('Date of Birth', _licenseData['dateOfBirth']),
        _buildInfoRow('Blood Group', _licenseData['bloodGroup']),
        _buildInfoRow('Nationality', _licenseData['nationality']),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRCode() {
    return Column(
      children: [
        const Text(
          'Scan to Verify',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        QrImageView(
          data: _generateVerificationData(),
          version: QrVersions.auto,
          size: 200.0,
          backgroundColor: Colors.white,
          errorStateBuilder: (context, error) => const Center(
            child: Text(
              'Error generating QR code',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Generated: ${DateTime.now().toString().split('.')[0]}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildOfflineInstructions() {
    if (!_isOfflineMode) return const SizedBox.shrink();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Offline Mode',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This card is available offline. You can view and share it without an internet connection.',
              style: TextStyle(
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _saveCardOffline,
              icon: const Icon(Icons.download),
              label: const Text('Save for Offline Use'),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleOfflineMode() {
    setState(() {
      _isOfflineMode = !_isOfflineMode;
    });
  }

  Future<void> _shareCard() async {
    try {
      final image = await _screenshotController.capture();
      if (image == null) return;

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/license_card.png');
      await file.writeAsBytes(image);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'My Digital Driver\'s License',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to share card'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _saveCardOffline() async {
    try {
      final image = await _screenshotController.capture();
      if (image == null) return;

      final appDir = await getApplicationDocumentsDirectory();
      final file = File('${appDir.path}/license_card.png');
      await file.writeAsBytes(image);

      // Save verification data for offline use
      final verificationData = _generateVerificationData();
      final verificationFile = File('${appDir.path}/verification_data.json');
      await verificationFile.writeAsString(verificationData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Card saved for offline use'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save card'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final userId = authService.userId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Documents'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
                children: [
          _buildDocumentCard(
            context,
            'Passport Photo',
            'Upload a recent passport photo',
            Icons.photo_camera,
            Colors.blue,
            () {
              // TODO: Implement photo upload
            },
                  ),
                  const SizedBox(height: 16),
          _buildDocumentCard(
            context,
            'ID Document',
            'Upload your ID document',
            Icons.badge,
            Colors.green,
            () {
              // TODO: Implement ID document upload
            },
          ),
          const SizedBox(height: 16),
          _buildDocumentCard(
            context,
            'Medical Certificate',
            'Upload your medical certificate',
            Icons.medical_services,
            Colors.orange,
            () {
              // TODO: Implement medical certificate upload
            },
          ),
          const SizedBox(height: 16),
          _buildDocumentCard(
            context,
            'Address Proof',
            'Upload your address proof document',
            Icons.home,
            Colors.purple,
            () {
              // TODO: Implement address proof upload
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
          ),
                    ),
                    subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(
                      fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        trailing: ElevatedButton(
          onPressed: onTap,
              child: const Text('Upload'),
        ),
      ),
    );
  }
}

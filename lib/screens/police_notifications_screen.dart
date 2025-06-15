import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PoliceNotificationsScreen extends StatelessWidget {
  final String policeId;

  const PoliceNotificationsScreen({
    super.key,
    required this.policeId,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual notifications from API
    final notifications = [
      {
        'title': 'New License Application',
        'message': 'A new license application requires your review',
        'time': '2 hours ago',
        'type': 'application',
      },
      {
        'title': 'License Expiring Soon',
        'message': '5 licenses are expiring in the next 7 days',
        'time': '5 hours ago',
        'type': 'expiry',
      },
      {
        'title': 'System Update',
        'message': 'New features have been added to the system',
        'time': '1 day ago',
        'type': 'system',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor:
                    _getNotificationColor(notification['type'] as String),
                child: Icon(
                  _getNotificationIcon(notification['type'] as String),
                  color: Colors.white,
                ),
              ),
              title: Text(
                notification['title'] as String,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    notification['message'] as String,
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification['time'] as String,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
              onTap: () {
                // TODO: Handle notification tap
              },
            ),
          );
        },
      ),
    );
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'application':
        return Colors.blue;
      case 'expiry':
        return Colors.orange;
      case 'system':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'application':
        return Icons.description;
      case 'expiry':
        return Icons.timer;
      case 'system':
        return Icons.system_update;
      default:
        return Icons.notifications;
    }
  }
}

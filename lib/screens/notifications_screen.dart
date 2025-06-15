import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              // TODO: Mark all as read
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 10, // TODO: Replace with actual notifications count
        itemBuilder: (context, index) {
          return _buildNotificationCard(
            context,
            title: _getNotificationTitle(index),
            message: _getNotificationMessage(index),
            time: _getNotificationTime(index),
            type: _getNotificationType(index),
            isRead: index > 2, // Example: first 3 notifications are unread
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context, {
    required String title,
    required String message,
    required String time,
    required NotificationType type,
    required bool isRead,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: _getNotificationColor(type).withOpacity(0.2),
          child: Icon(
            _getNotificationIcon(type),
            color: _getNotificationColor(type),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                ),
              ),
            ),
            if (!isRead)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              message,
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
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
  }

  String _getNotificationTitle(int index) {
    final titles = [
      'License Application Approved',
      'License Expiring Soon',
      'Payment Successful',
      'Document Verification Required',
      'License Renewal Reminder',
    ];
    return titles[index % titles.length];
  }

  String _getNotificationMessage(int index) {
    final messages = [
      'Your license application has been approved. You can now view your digital license.',
      'Your license will expire in 30 days. Please renew it to avoid any inconvenience.',
      'Your payment of \$50 has been processed successfully.',
      'Please upload your updated ID document for verification.',
      'Your license is due for renewal. Click here to start the renewal process.',
    ];
    return messages[index % messages.length];
  }

  String _getNotificationTime(int index) {
    final times = [
      '2 hours ago',
      '1 day ago',
      '2 days ago',
      '3 days ago',
      '1 week ago',
    ];
    return times[index % times.length];
  }

  NotificationType _getNotificationType(int index) {
    final types = [
      NotificationType.success,
      NotificationType.warning,
      NotificationType.info,
      NotificationType.warning,
      NotificationType.info,
    ];
    return types[index % types.length];
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.success:
        return Icons.check_circle;
      case NotificationType.warning:
        return Icons.warning;
      case NotificationType.error:
        return Icons.error;
      case NotificationType.info:
        return Icons.info;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.success:
        return Colors.green;
      case NotificationType.warning:
        return Colors.orange;
      case NotificationType.error:
        return Colors.red;
      case NotificationType.info:
        return Colors.blue;
    }
  }
}

enum NotificationType {
  success,
  warning,
  error,
  info,
}

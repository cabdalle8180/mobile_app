import 'package:flutter/material.dart';

class UserNotificationsScreen extends StatefulWidget {
  final String userId;

  const UserNotificationsScreen({
    super.key,
    required this.userId,
  });

  @override
  State<UserNotificationsScreen> createState() => _UserNotificationsScreenState();
}

class _UserNotificationsScreenState extends State<UserNotificationsScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual API data
    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'License Expiring Soon',
        'message': 'Your driver\'s license will expire in 30 days. Please renew it to avoid penalties.',
        'type': 'Alert',
        'priority': 'High',
        'timestamp': '2024-03-15 10:30',
        'isRead': false,
      },
      {
        'title': 'Payment Successful',
        'message': 'Your license renewal payment has been processed successfully.',
        'type': 'Payment',
        'priority': 'Medium',
        'timestamp': '2024-03-14 15:45',
        'isRead': true,
      },
      {
        'title': 'System Update',
        'message': 'New features have been added to the digital license system.',
        'type': 'Update',
        'priority': 'Low',
        'timestamp': '2024-03-13 09:15',
        'isRead': true,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // TODO: Implement refresh functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: _buildNotificationsList(notifications),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('All'),
            _buildFilterChip('Alerts'),
            _buildFilterChip('Payments'),
            _buildFilterChip('Updates'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = label;
          });
        },
        backgroundColor: Colors.grey.shade200,
        selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
        checkmarkColor: Theme.of(context).primaryColor,
        labelStyle: TextStyle(
          color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildNotificationsList(List<Map<String, dynamic>> notifications) {
    final filteredNotifications = _selectedFilter == 'All'
        ? notifications
        : notifications
            .where((notification) => notification['type'] == _selectedFilter)
            .toList();

    if (filteredNotifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No notifications',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: filteredNotifications.length,
      itemBuilder: (context, index) {
        final notification = filteredNotifications[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16.0),
            leading: CircleAvatar(
              backgroundColor: _getNotificationColor(notification['type'])
                  .withOpacity(0.1),
              child: Icon(
                _getNotificationIcon(notification['type']),
                color: _getNotificationColor(notification['type']),
              ),
            ),
            title: Text(
              notification['title'],
              style: TextStyle(
                fontWeight: notification['isRead']
                    ? FontWeight.normal
                    : FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(notification['message']),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildPriorityChip(notification['priority']),
                    const SizedBox(width: 8),
                    Text(
                      notification['timestamp'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            onTap: () {
              // TODO: Implement notification details view
            },
          ),
        );
      },
    );
  }

  Widget _buildPriorityChip(String priority) {
    Color color;
    switch (priority.toLowerCase()) {
      case 'high':
        color = Colors.red;
        break;
      case 'medium':
        color = Colors.orange;
        break;
      case 'low':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        priority,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getNotificationColor(String type) {
    switch (type.toLowerCase()) {
      case 'alert':
        return Colors.red;
      case 'payment':
        return Colors.green;
      case 'update':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'alert':
        return Icons.warning;
      case 'payment':
        return Icons.payment;
      case 'update':
        return Icons.system_update;
      default:
        return Icons.notifications;
    }
  }
} 
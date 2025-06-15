import 'package:flutter/material.dart';

class SystemNotificationsScreen extends StatefulWidget {
  final String policeId;

  const SystemNotificationsScreen({
    super.key,
    required this.policeId,
  });

  @override
  State<SystemNotificationsScreen> createState() =>
      _SystemNotificationsScreenState();
}

class _SystemNotificationsScreenState extends State<SystemNotificationsScreen> {
  String _selectedFilter = 'All';
  final bool _isLoading = false;

  final List<String> _filterOptions = [
    'All',
    'Alerts',
    'Updates',
    'Reports',
  ];

  // TODO: Replace with actual API data
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'New Traffic Violation Report',
      'message': 'A new traffic violation has been reported in your area.',
      'type': 'Alerts',
      'priority': 'High',
      'timestamp': '2024-02-15 10:30 AM',
      'isRead': false,
    },
    {
      'title': 'System Maintenance',
      'message': 'Scheduled maintenance will occur tonight from 2 AM to 4 AM.',
      'type': 'Updates',
      'priority': 'Medium',
      'timestamp': '2024-02-15 09:15 AM',
      'isRead': true,
    },
    {
      'title': 'License Expiry Alert',
      'message': 'Multiple licenses are expiring in the next 7 days.',
      'type': 'Alerts',
      'priority': 'High',
      'timestamp': '2024-02-15 08:45 AM',
      'isRead': false,
    },
    {
      'title': 'Monthly Report Available',
      'message': 'Your monthly performance report is now available.',
      'type': 'Reports',
      'priority': 'Low',
      'timestamp': '2024-02-14 11:20 PM',
      'isRead': true,
    },
  ];

  List<Map<String, dynamic>> get _filteredNotifications {
    if (_selectedFilter == 'All') {
      return _notifications;
    }
    return _notifications
        .where((notification) => notification['type'] == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('System Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // TODO: Implement refresh functionality
            },
          ),
        ],
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
                      itemCount: _filteredNotifications.length,
                      itemBuilder: (context, index) {
                        final notification = _filteredNotifications[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16.0),
                            leading:
                                _buildNotificationIcon(notification['type']),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    notification['title'],
                                    style: TextStyle(
                                      fontWeight: notification['isRead']
                                          ? FontWeight.normal
                                          : FontWeight.bold,
                                    ),
                                  ),
                                ),
                                _buildPriorityChip(notification['priority']),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Text(notification['message']),
                                const SizedBox(height: 8),
                                Text(
                                  notification['timestamp'],
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                            onTap: () {
                              // TODO: Implement notification details view
                            },
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

  Widget _buildNotificationIcon(String type) {
    IconData iconData;
    Color iconColor;

    switch (type) {
      case 'Alerts':
        iconData = Icons.warning;
        iconColor = Colors.red;
        break;
      case 'Updates':
        iconData = Icons.update;
        iconColor = Colors.blue;
        break;
      case 'Reports':
        iconData = Icons.assessment;
        iconColor = Colors.green;
        break;
      default:
        iconData = Icons.notifications;
        iconColor = Colors.grey;
    }

    return CircleAvatar(
      backgroundColor: iconColor.withOpacity(0.1),
      child: Icon(
        iconData,
        color: iconColor,
      ),
    );
  }

  Widget _buildPriorityChip(String priority) {
    Color color;
    switch (priority) {
      case 'High':
        color = Colors.red;
        break;
      case 'Medium':
        color = Colors.orange;
        break;
      case 'Low':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }

    return Chip(
      label: Text(
        priority,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
      backgroundColor: color,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

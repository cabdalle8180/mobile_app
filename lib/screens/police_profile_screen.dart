import 'package:flutter/material.dart';

class PoliceProfileScreen extends StatelessWidget {
  final String policeId;

  const PoliceProfileScreen({
    super.key,
    required this.policeId,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual data from API
    final Map<String, dynamic> profileData = {
      'name': 'Officer John Smith',
      'badgeNumber': policeId,
      'rank': 'Senior Officer',
      'department': 'Traffic Police',
      'joinDate': '2020-01-15',
      'performance': {
        'violationsReported': 156,
        'successfulVerifications': 289,
        'responseTime': '4.2 min',
        'rating': 4.8,
      },
      'contact': {
        'email': 'john.smith@police.gov',
        'phone': '+1234567890',
        'emergency': '+1234567891',
      },
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Police Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      profileData['name'],
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      profileData['rank'],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildSection(
                context,
                title: 'Officer Information',
                children: [
                  _buildInfoRow('Badge Number', profileData['badgeNumber']),
                  _buildInfoRow('Department', profileData['department']),
                  _buildInfoRow('Join Date', profileData['joinDate']),
                ],
              ),
              const SizedBox(height: 24),
              _buildSection(
                context,
                title: 'Performance Metrics',
                children: [
                  _buildMetricCard(
                    context,
                    icon: Icons.report,
                    title: 'Violations Reported',
                    value: profileData['performance']['violationsReported']
                        .toString(),
                  ),
                  _buildMetricCard(
                    context,
                    icon: Icons.check_circle,
                    title: 'Successful Verifications',
                    value: profileData['performance']['successfulVerifications']
                        .toString(),
                  ),
                  _buildMetricCard(
                    context,
                    icon: Icons.timer,
                    title: 'Avg. Response Time',
                    value: profileData['performance']['responseTime'],
                  ),
                  _buildMetricCard(
                    context,
                    icon: Icons.star,
                    title: 'Performance Rating',
                    value: '${profileData['performance']['rating']}/5.0',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSection(
                context,
                title: 'Contact Information',
                children: [
                  _buildInfoRow('Email', profileData['contact']['email']),
                  _buildInfoRow('Phone', profileData['contact']['phone']),
                  _buildInfoRow(
                      'Emergency', profileData['contact']['emergency']),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement edit profile
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Profile'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 45),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: children,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
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

  Widget _buildMetricCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 32,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class PaymentHistoryScreen extends StatefulWidget {
  final String userId;

  const PaymentHistoryScreen({
    super.key,
    required this.userId,
  });

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  final List<Map<String, dynamic>> _payments = [
    {
      'id': 'PAY001',
      'description': 'License Renewal',
      'date': '2024-03-15',
      'amount': 50.00,
      'status': 'Completed',
      'paymentMethod': 'EVC Plus',
      'receiptNumber': 'REC001',
    },
    {
      'id': 'PAY002',
      'description': 'Processing Fee',
      'date': '2024-03-15',
      'amount': 5.00,
      'status': 'Completed',
      'paymentMethod': 'EVC Plus',
      'receiptNumber': 'REC002',
    },
    {
      'id': 'PAY003',
      'description': 'License Renewal',
      'date': '2023-03-15',
      'amount': 50.00,
      'status': 'Completed',
      'paymentMethod': 'Sahal',
      'receiptNumber': 'REC003',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment History'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _payments.length,
        itemBuilder: (context, index) {
          final payment = _payments[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        payment['description'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          payment['status'],
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('Date', payment['date']),
                  _buildInfoRow(
                      'Amount', '\$${payment['amount'].toStringAsFixed(2)}'),
                  _buildInfoRow('Payment Method', payment['paymentMethod']),
                  _buildInfoRow('Receipt Number', payment['receiptNumber']),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          // TODO: Implement view receipt
                        },
                        icon: const Icon(Icons.receipt),
                        label: const Text('View Receipt'),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: () {
                          // TODO: Implement download receipt
                        },
                        icon: const Icon(Icons.download),
                        label: const Text('Download'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
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
}

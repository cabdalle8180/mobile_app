import 'package:flutter/material.dart';
import 'police_dashboard_screen.dart';

class PoliceLoginScreen extends StatefulWidget {
  const PoliceLoginScreen({super.key});

  @override
  State<PoliceLoginScreen> createState() => _PoliceLoginScreenState();
}

class _PoliceLoginScreenState extends State<PoliceLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _policeIdController = TextEditingController();
  bool _isCapturingFace = false;

  @override
  void dispose() {
    _policeIdController.dispose();
    super.dispose();
  }

  void _startFaceCapture() {
    setState(() {
      _isCapturingFace = true;
    });
    // TODO: Implement face capture functionality
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isCapturingFace = false;
      });
    });
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement actual login logic
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PoliceDashboardScreen(
            policeId: _policeIdController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Police Login'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.local_police_outlined,
                  size: 80,
                  color: Colors.blue,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _policeIdController,
                  decoration: const InputDecoration(
                    labelText: 'Police ID',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.badge),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Police ID';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _isCapturingFace ? null : _startFaceCapture,
                  icon: Icon(_isCapturingFace ? Icons.camera_alt : Icons.face),
                  label:
                      Text(_isCapturingFace ? 'Capturing...' : 'Capture Face'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

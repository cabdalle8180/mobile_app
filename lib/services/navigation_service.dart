import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/user_login_screen.dart';
import '../screens/user_dashboard_screen.dart';
import '../screens/payment_screen.dart';
import '../screens/documents_screen.dart';
import '../screens/renew_license_screen.dart';
import '../screens/digital_card_screen.dart';
import '../screens/user_notifications_screen.dart';
import '../screens/welcome_screen.dart';
import '../screens/emergency_contact_screen.dart';
import '../screens/user_registration_screen.dart';
import '../screens/license_application_screen.dart';
import '../screens/police_dashboard_screen.dart';
import '../screens/police_registration_screen.dart';
import '../screens/police_login_screen.dart';
import '../screens/issue_fine_screen.dart';
import '../screens/police_reports_screen.dart';
import '../screens/police_profile_screen.dart';
import '../screens/check_user_screen.dart';
import '../services/auth_service.dart';

class NavigationService {
  static void navigateToUserDashboard(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const UserDashboardScreen()),
    );
  }

  static void navigateToUserLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const UserLoginScreen()),
    );
  }

  static void navigateToUserRegistration(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserRegistrationScreen()),
    );
  }

  static void navigateToPoliceLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const PoliceLoginScreen()),
    );
  }

  static void navigateToPoliceRegistration(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PoliceRegistrationScreen()),
    );
  }

  static void navigateToPoliceDashboard(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const PoliceDashboardScreen()),
    );
  }

  static void navigateToPayments(
    BuildContext context, {
    required double amount,
    required String serviceType,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          amount: amount,
          serviceType: serviceType,
        ),
      ),
    );
  }

  static void navigateToLicenseCard(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userId = authService.userId;
    if (userId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DigitalCardScreen(userId: userId),
        ),
      );
    }
  }

  static void navigateToNotifications(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userId = authService.userId;
    if (userId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserNotificationsScreen(userId: userId),
        ),
      );
    }
  }

  static void navigateToEmergencyContact(
    BuildContext context, {
    required Map<String, dynamic> initialData,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmergencyContactScreen(initialData: initialData),
      ),
    );
  }

  static void navigateToIssueFine(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const IssueFineScreen()),
    );
  }

  static void navigateToPoliceReports(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PoliceReportsScreen()),
    );
  }

  static void navigateToPoliceProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PoliceProfileScreen()),
    );
  }

  static void navigateToCheckUser(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final policeId = await authService.getPoliceId();
    if (policeId != null) {
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CheckUserScreen(policeId: policeId),
          ),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please log in as a police officer'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  static void navigateToWelcome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const UserLoginScreen()),
    );
  }

  static void navigateToLicenseApplication(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LicenseApplicationScreen()),
    );
  }

  static void navigateToLogin(BuildContext context) {}
}

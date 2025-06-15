import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RegistrationFlowService {
  static const String _pendingUsersKey = 'pendingUsers';
  static const String _pendingPoliceKey = 'pendingPolice';
  static const String _approvedUsersKey = 'approvedUsers';
  static const String _approvedPoliceKey = 'approvedPolice';

  // Check if user exists and is approved
  static Future<bool> isUserApproved(String licenseNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final approvedUsers = prefs.getStringList(_approvedUsersKey) ?? [];

    for (final user in approvedUsers) {
      final userData = jsonDecode(user) as Map<String, dynamic>;
      if (userData['licenseNumber'] == licenseNumber) {
        return true;
      }
    }
    return false;
  }

  // Check if police officer exists and is approved
  static Future<bool> isPoliceApproved(String policeId) async {
    final prefs = await SharedPreferences.getInstance();
    final approvedPolice = prefs.getStringList(_approvedPoliceKey) ?? [];

    for (final police in approvedPolice) {
      final policeData = jsonDecode(police) as Map<String, dynamic>;
      if (policeData['idNumber'] == policeId) {
        return true;
      }
    }
    return false;
  }

  // Register new user
  static Future<bool> registerUser(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    final pendingUsers = prefs.getStringList(_pendingUsersKey) ?? [];

    // Check if user already exists
    for (final user in pendingUsers) {
      final existingUser = jsonDecode(user) as Map<String, dynamic>;
      if (existingUser['licenseNumber'] == userData['licenseNumber']) {
        return false;
      }
    }

    // Add to pending users
    pendingUsers.add(jsonEncode(userData));
    await prefs.setStringList(_pendingUsersKey, pendingUsers);
    return true;
  }

  // Register new police officer
  static Future<bool> registerPolice(Map<String, dynamic> policeData) async {
    final prefs = await SharedPreferences.getInstance();
    final pendingPolice = prefs.getStringList(_pendingPoliceKey) ?? [];

    // Check if police officer already exists
    for (final police in pendingPolice) {
      final existingPolice = jsonDecode(police) as Map<String, dynamic>;
      if (existingPolice['idNumber'] == policeData['idNumber']) {
        return false;
      }
    }

    // Add to pending police
    pendingPolice.add(jsonEncode(policeData));
    await prefs.setStringList(_pendingPoliceKey, pendingPolice);
    return true;
  }

  // Approve user registration
  static Future<void> approveUser(String licenseNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final pendingUsers = prefs.getStringList(_pendingUsersKey) ?? [];
    final approvedUsers = prefs.getStringList(_approvedUsersKey) ?? [];
    Map<String, dynamic>? userData;

    // Find and remove from pending
    for (int i = 0; i < pendingUsers.length; i++) {
      final user = jsonDecode(pendingUsers[i]) as Map<String, dynamic>;
      if (user['licenseNumber'] == licenseNumber) {
        userData = user;
        pendingUsers.removeAt(i);
        break;
      }
    }

    if (userData != null) {
      // Generate default password
      final defaultPassword = 'User${licenseNumber.substring(0, 4)}';
      userData['password'] = defaultPassword;
      userData['isApproved'] = true;

      // Add to approved users
      approvedUsers.add(jsonEncode(userData));
      await prefs.setStringList(_pendingUsersKey, pendingUsers);
      await prefs.setStringList(_approvedUsersKey, approvedUsers);
    }
  }

  // Approve police registration
  static Future<void> approvePolice(String policeId) async {
    final prefs = await SharedPreferences.getInstance();
    final pendingPolice = prefs.getStringList(_pendingPoliceKey) ?? [];
    final approvedPolice = prefs.getStringList(_approvedPoliceKey) ?? [];
    Map<String, dynamic>? policeData;

    // Find and remove from pending
    for (int i = 0; i < pendingPolice.length; i++) {
      final police = jsonDecode(pendingPolice[i]) as Map<String, dynamic>;
      if (police['idNumber'] == policeId) {
        policeData = police;
        pendingPolice.removeAt(i);
        break;
      }
    }

    if (policeData != null) {
      // Generate default password
      final defaultPassword = 'Police${policeId.substring(0, 4)}';
      policeData['password'] = defaultPassword;
      policeData['isApproved'] = true;

      // Add to approved police
      approvedPolice.add(jsonEncode(policeData));
      await prefs.setStringList(_pendingPoliceKey, pendingPolice);
      await prefs.setStringList(_approvedPoliceKey, approvedPolice);
    }
  }

  // Get registration status for user
  static Future<String> getUserRegistrationStatus(String licenseNumber) async {
    if (await isUserApproved(licenseNumber)) {
      return 'approved';
    }

    final prefs = await SharedPreferences.getInstance();
    final pendingUsers = prefs.getStringList(_pendingUsersKey) ?? [];

    for (final user in pendingUsers) {
      final userData = jsonDecode(user) as Map<String, dynamic>;
      if (userData['licenseNumber'] == licenseNumber) {
        return 'pending';
      }
    }
    return 'not_found';
  }

  // Get registration status for police
  static Future<String> getPoliceRegistrationStatus(String policeId) async {
    if (await isPoliceApproved(policeId)) {
      return 'approved';
    }

    final prefs = await SharedPreferences.getInstance();
    final pendingPolice = prefs.getStringList(_pendingPoliceKey) ?? [];

    for (final police in pendingPolice) {
      final policeData = jsonDecode(police) as Map<String, dynamic>;
      if (policeData['idNumber'] == policeId) {
        return 'pending';
      }
    }
    return 'not_found';
  }

  // Verify user login
  static Future<bool> verifyUserLogin(
      String licenseNumber, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final approvedUsers = prefs.getStringList(_approvedUsersKey) ?? [];

    for (final user in approvedUsers) {
      final userData = jsonDecode(user) as Map<String, dynamic>;
      if (userData['licenseNumber'] == licenseNumber &&
          userData['password'] == password) {
        return true;
      }
    }
    return false;
  }

  // Verify police login
  static Future<bool> verifyPoliceLogin(
      String policeId, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final approvedPolice = prefs.getStringList(_approvedPoliceKey) ?? [];

    for (final police in approvedPolice) {
      final policeData = jsonDecode(police) as Map<String, dynamic>;
      if (policeData['idNumber'] == policeId &&
          policeData['password'] == password) {
        return true;
      }
    }
    return false;
  }
}

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userId;
  String? _userRole;
  bool _isApproved = false;
  String? _userName;
  String? _licenseNumber;
  String? _licenseStatus;
  String? _vehicleClass;
  String? _dateOfBirth;
  String? _bloodGroup;
  String? _nationality;
  String? _expiryDate;

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  String? get userId => _userId;
  String? get userRole => _userRole;
  bool get isApproved => _isApproved;
  String? get userName => _userName;
  String get licenseStatus => _licenseStatus ?? 'Unknown';
  String? get vehicleClass => _vehicleClass;
  String? get dateOfBirth => _dateOfBirth;
  String? get bloodGroup => _bloodGroup;
  String? get nationality => _nationality;
  String? get expiryDate => _expiryDate;

  Future<bool> login(String licenseNumber, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if user exists
      final users = prefs.getStringList('users') ?? [];
      for (final user in users) {
        final userData = jsonDecode(user) as Map<String, dynamic>;
        if (userData['licenseNumber'] == licenseNumber &&
            userData['password'] == password) {
          _isAuthenticated = true;
          _userId = licenseNumber;
          _userRole = 'user';
          _isApproved = true;
          _userName = userData['name'] as String?;
          _licenseNumber = licenseNumber;
          _licenseStatus = userData['status'] as String?;
          _vehicleClass = userData['vehicleClass'] as String?;
          _dateOfBirth = userData['dateOfBirth'] as String?;
          _bloodGroup = userData['bloodGroup'] as String?;
          _nationality = userData['nationality'] as String?;
          _expiryDate = userData['expiryDate'] as String?;
          notifyListeners();
          return true;
        }
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> loginPolice(String policeId, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if user exists and is approved
      final approvedUsers = prefs.getStringList('approvedUsers') ?? [];
      for (final user in approvedUsers) {
        final userData = jsonDecode(user) as Map<String, dynamic>;
        if (userData['idNumber'] == policeId &&
            userData['password'] == password) {
          _isAuthenticated = true;
          _userId = policeId;
          _userRole = 'police';
          _isApproved = true;
          _userName = userData['name'] as String?;

          // Store police ID in SharedPreferences for persistence
          await prefs.setString('currentPoliceId', policeId);
          await prefs.setString('userRole', 'police');

          notifyListeners();
          return true;
        }
      }

      // Check pending registrations
      final pendingRegistrations =
          prefs.getStringList('pendingRegistrations') ?? [];
      for (final registration in pendingRegistrations) {
        final regData = jsonDecode(registration) as Map<String, dynamic>;
        if (regData['idNumber'] == policeId) {
          _isAuthenticated = false;
          _userId = null;
          _userRole = null;
          _isApproved = false;
          notifyListeners();
          return false;
        }
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkLicenseApproval() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final approvedLicenses = prefs.getStringList('approvedLicenses') ?? [];
      return approvedLicenses.contains(_licenseNumber);
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentPoliceId'); // Clear stored police ID
    await prefs.remove('userRole'); // Clear user role

    _isAuthenticated = false;
    _userId = null;
    _userRole = null;
    _isApproved = false;
    _userName = null;
    _licenseNumber = null;
    _licenseStatus = null;
    _vehicleClass = null;
    _dateOfBirth = null;
    _bloodGroup = null;
    _nationality = null;
    _expiryDate = null;
    notifyListeners();
  }

  Future<bool> registerPolice(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pendingRegistrations =
          prefs.getStringList('pendingRegistrations') ?? [];

      // Check if ID already exists
      for (final registration in pendingRegistrations) {
        final regData = jsonDecode(registration) as Map<String, dynamic>;
        if (regData['idNumber'] == data['idNumber']) {
          return false;
        }
      }

      // Add new registration
      pendingRegistrations.add(jsonEncode(data));
      await prefs.setStringList('pendingRegistrations', pendingRegistrations);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> registerUser(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final users = prefs.getStringList('users') ?? [];

      // Check if license number already exists
      for (final user in users) {
        final userData = jsonDecode(user) as Map<String, dynamic>;
        if (userData['licenseNumber'] == data['licenseNumber']) {
          return false;
        }
      }

      // Add new user
      users.add(jsonEncode(data));
      await prefs.setStringList('users', users);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Admin function to approve registration
  Future<void> approveRegistration(String idNumber) async {
    final prefs = await SharedPreferences.getInstance();

    // Get pending registrations
    final pendingRegistrations =
        prefs.getStringList('pendingRegistrations') ?? [];
    Map<String, dynamic>? registrationData;

    // Find and remove the registration
    for (int i = 0; i < pendingRegistrations.length; i++) {
      final regData =
          jsonDecode(pendingRegistrations[i]) as Map<String, dynamic>;
      if (regData['idNumber'] == idNumber) {
        registrationData = regData;
        pendingRegistrations.removeAt(i);
        break;
      }
    }

    if (registrationData != null) {
      // Generate a default password (in a real app, this would be more secure)
      final defaultPassword = 'Police${idNumber.substring(0, 4)}';

      // Add to approved users
      final approvedUsers = prefs.getStringList('approvedUsers') ?? [];
      registrationData['isApproved'] = true;
      registrationData['password'] = defaultPassword;
      approvedUsers.add(jsonEncode(registrationData));

      // Save changes
      await prefs.setStringList('pendingRegistrations', pendingRegistrations);
      await prefs.setStringList('approvedUsers', approvedUsers);
    }
  }

  // Admin function to reject registration
  Future<void> rejectRegistration(String idNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final pendingRegistrations =
        prefs.getStringList('pendingRegistrations') ?? [];

    // Remove the registration
    pendingRegistrations.removeWhere((reg) {
      final regData = jsonDecode(reg) as Map<String, dynamic>;
      return regData['idNumber'] == idNumber;
    });

    await prefs.setStringList('pendingRegistrations', pendingRegistrations);
  }

  Future<String?> getPoliceId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('currentPoliceId');
  }

  Future<void> initializeTestData() async {
    final prefs = await SharedPreferences.getInstance();

    // Add test users
    final users = [
      {
        'name': 'John Smith',
        'licenseNumber': 'DL123456',
        'password': 'password123',
        'status': 'Valid',
        'dateOfBirth': '1990-01-15',
        'bloodGroup': 'A+',
        'nationality': 'Somali',
        'issueDate': '2020-01-01',
        'expiryDate': '2025-01-01',
        'vehicleClass': 'B',
        'restrictions': 'None',
        'endorsements': 'None',
      },
      {
        'name': 'Jane Doe',
        'licenseNumber': 'DL789012',
        'password': 'password123',
        'status': 'Valid',
        'dateOfBirth': '1988-05-20',
        'bloodGroup': 'O+',
        'nationality': 'Somali',
        'issueDate': '2019-06-15',
        'expiryDate': '2024-06-15',
        'vehicleClass': 'A',
        'restrictions': 'Glasses Required',
        'endorsements': 'None',
      },
    ];

    // Add test police officers
    final approvedUsers = [
      {
        'idNumber': 'P12345',
        'name': 'Officer John',
        'password': 'police123',
        'rank': 'Sergeant',
        'station': 'Central Police Station',
        'department': 'Traffic',
      },
      {
        'idNumber': 'P67890',
        'name': 'Officer Sarah',
        'password': 'police123',
        'rank': 'Inspector',
        'station': 'North Police Station',
        'department': 'Traffic',
      },
    ];

    await prefs.setStringList(
        'users', users.map((u) => jsonEncode(u)).toList());
    await prefs.setStringList(
        'approvedUsers', approvedUsers.map((u) => jsonEncode(u)).toList());
  }
}

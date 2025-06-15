import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/navigation_service.dart';
import '../services/theme_service.dart';
import 'new_license_application_screen.dart';
import 'police_job_application_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final isDark = themeService.isDarkMode;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    colorScheme.primary.withOpacity(0.8),
                    colorScheme.primary.withOpacity(0.5),
                  ]
                : [
                    Colors.blue.shade900,
                    Colors.blue.shade500,
                  ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 16,
                right: 16,
                child: _buildThemeToggle(context, themeService),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLogo(isDark),
                    const SizedBox(height: 40),
                    _buildWelcomeText(),
                    const SizedBox(height: 50),
                    _buildRoleButton(
                      context,
                      'Police Officer',
                      Icons.badge,
                      isDark ? colorScheme.primary : Colors.blue.shade900,
                      () => _handlePoliceRole(context),
                    ),
                    const SizedBox(height: 20),
                    _buildRoleButton(
                      context,
                      'Citizen',
                      Icons.person,
                      isDark ? colorScheme.secondary : Colors.green.shade800,
                      () => _handleUserRole(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handlePoliceRole(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Police Officer Registration'),
        content: const Text('Would you like to apply for a police position?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              NavigationService.navigateToPoliceLogin(context);
            },
            child: const Text('I already have an account'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PoliceJobApplicationScreen(),
                ),
              );
            },
            child: const Text('Apply Now'),
          ),
        ],
      ),
    );
  }

  void _handleUserRole(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Citizen Registration'),
        content: const Text('Would you like to apply for a license?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              NavigationService.navigateToUserLogin(context);
            },
            child: const Text('I already have an account'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewLicenseApplicationScreen(),
                ),
              );
            },
            child: const Text('Apply Now'),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context, ThemeService themeService) {
    final isDark = themeService.isDarkMode;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: IconButton(
        icon: Icon(
          isDark ? Icons.light_mode : Icons.dark_mode,
          color: Colors.white,
          size: 24,
        ),
        onPressed: () => themeService.toggleTheme(),
      ),
    );
  }

  Widget _buildLogo(bool isDark) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.1) : Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(
        Icons.security,
        size: 60,
        color: isDark ? Colors.white : Colors.blue.shade900,
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      children: [
        Text(
          'Welcome to',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Police Management System',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRoleButton(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withOpacity(isDark ? 0.3 : 0.2),
                  color.withOpacity(isDark ? 0.2 : 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(isDark ? 0.3 : 0.2),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.2),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    size: 24,
                    color: color,
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

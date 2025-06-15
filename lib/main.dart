import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'screens/role_selection_screen.dart';
import 'services/auth_service.dart';
import 'services/theme_service.dart';

void main() {
  runApp(const DigitalLicenseApp());
}

class DigitalLicenseApp extends StatelessWidget {
  const DigitalLicenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ThemeService()),
      ],
      child: Consumer<ThemeService>(
        builder: (context, themeService, _) {
          return MaterialApp(
            title: 'Police Management System',
            theme: themeService.lightTheme,
            darkTheme: themeService.darkTheme,
            themeMode:
                themeService.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const RoleSelectionScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

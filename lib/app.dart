import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'shell/main_shell.dart';

class ClipVaultApp extends StatelessWidget {
  const ClipVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeController>();
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      themeMode: theme.mode,
      theme: AppTheme.build(accent: theme.accent, brightness: Brightness.light),
      darkTheme: AppTheme.build(accent: theme.accent, brightness: Brightness.dark),
      home: const MainShell(),
    );
  }
}

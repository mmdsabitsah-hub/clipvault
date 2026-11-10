import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';

class ClipVaultLogo extends StatelessWidget {
  const ClipVaultLogo({super.key, this.size = 44});
  final double size;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.32),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primary, AppColors.secondary],
        ),
      ),
      child: Icon(Icons.video_library_rounded, color: Colors.white, size: size * 0.55),
    );
  }
}

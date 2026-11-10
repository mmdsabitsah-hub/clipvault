import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/theme_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeController>();
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        children: [
          Text('Settings', style: text.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Appearance',
                      style: text.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<ThemeMode>(
                      showSelectedIcon: false,
                      segments: const [
                        ButtonSegment(
                            value: ThemeMode.system,
                            icon: Icon(Icons.brightness_auto_rounded),
                            label: Text('System')),
                        ButtonSegment(
                            value: ThemeMode.light,
                            icon: Icon(Icons.light_mode_rounded),
                            label: Text('Light')),
                        ButtonSegment(
                            value: ThemeMode.dark,
                            icon: Icon(Icons.dark_mode_rounded),
                            label: Text('Dark')),
                      ],
                      selected: {theme.mode},
                      onSelectionChanged: (s) => theme.setMode(s.first),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Accent colour',
                      style: text.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 14,
                    runSpacing: 14,
                    children: [
                      for (final p in kThemePresets)
                        _Swatch(
                          color: p.color,
                          label: p.name,
                          selected: theme.presetId == p.id,
                          onTap: () => theme.setPreset(p),
                        ),
                      _Swatch(
                        color: theme.presetId == 'custom'
                            ? theme.accent
                            : scheme.surfaceContainerHighest,
                        label: 'Custom',
                        icon: Icons.palette_rounded,
                        selected: theme.presetId == 'custom',
                        onTap: () => _pickCustom(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Download folder, default quality, Wi-Fi-only, storage usage, language '
                'and cloud backup are added in Stages 4 and 7, when the features they '
                'control exist.',
                style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickCustom(BuildContext context) async {
    final ctrl = context.read<ThemeController>();
    double hue = HSVColor.fromColor(ctrl.accent).hue;
    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          final color = HSVColor.fromAHSV(1, hue, 0.75, 0.9).toColor();
          return AlertDialog(
            title: const Text('Custom accent'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 56,
                  decoration:
                      BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
                ),
                const SizedBox(height: 12),
                Slider(
                  value: hue,
                  min: 0,
                  max: 360,
                  onChanged: (v) => setState(() => hue = v),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              FilledButton(
                style: FilledButton.styleFrom(minimumSize: const Size(96, 44)),
                onPressed: () {
                  ctrl.setCustomAccent(color);
                  Navigator.pop(ctx);
                },
                child: const Text('Apply'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.color,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final Color color;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final onColor = ThemeData.estimateBrightnessForColor(color) == Brightness.dark
        ? Colors.white
        : Colors.black87;
    return Semantics(
      button: true,
      selected: selected,
      label: '$label accent colour',
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? Theme.of(context).colorScheme.onSurface : Colors.transparent,
                  width: 2.5,
                ),
              ),
              child: selected
                  ? Icon(Icons.check_rounded, color: onColor)
                  : (icon != null ? Icon(icon, color: onColor, size: 20) : null),
            ),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

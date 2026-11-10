import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../features/downloads/downloads_screen.dart';
import '../features/editor/editor_screen.dart';
import '../features/home/home_screen.dart';
import '../features/library/library_screen.dart';
import '../features/settings/settings_screen.dart';
import 'nav_controller.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  Widget _page(int i) => switch (i) {
        NavController.home => const HomeScreen(),
        NavController.downloads => const DownloadsScreen(),
        NavController.editor => const EditorScreen(),
        NavController.library => const LibraryScreen(),
        _ => const SettingsScreen(),
      };

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<NavController>();
    return Scaffold(
      extendBody: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        switchInCurve: Curves.easeOutCubic,
        transitionBuilder: (child, anim) => FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween(begin: const Offset(0, 0.02), end: Offset.zero).animate(anim),
            child: child,
          ),
        ),
        child: KeyedSubtree(key: ValueKey(nav.index), child: _page(nav.index)),
      ),
      bottomNavigationBar: _FloatingNavBar(index: nav.index, onTap: nav.go),
    );
  }
}

class _NavItemData {
  const _NavItemData(this.icon, this.activeIcon, this.label);
  final IconData icon;
  final IconData activeIcon;
  final String label;
}

class _FloatingNavBar extends StatelessWidget {
  const _FloatingNavBar({required this.index, required this.onTap});
  final int index;
  final ValueChanged<int> onTap;

  static const _items = [
    _NavItemData(Icons.home_outlined, Icons.home_rounded, 'Home'),
    _NavItemData(Icons.download_outlined, Icons.download_rounded, 'Downloads'),
    _NavItemData(Icons.content_cut_outlined, Icons.content_cut_rounded, 'Editor'),
    _NavItemData(Icons.video_library_outlined, Icons.video_library_rounded, 'Library'),
    _NavItemData(Icons.settings_outlined, Icons.settings_rounded, 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Material(
        elevation: 10,
        shadowColor: Colors.black45,
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Row(
            children: [
              for (var i = 0; i < _items.length; i++)
                Expanded(
                  child: _NavItem(
                    data: _items[i],
                    selected: i == index,
                    onTap: () => onTap(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.data, required this.selected, required this.onTap});
  final _NavItemData data;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = selected ? scheme.primary : scheme.onSurfaceVariant;
    return Semantics(
      button: true,
      selected: selected,
      label: data.label,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: selected ? scheme.primary.withValues(alpha: 0.14) : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(selected ? data.activeIcon : data.icon, color: color, size: 24),
              const SizedBox(height: 2),
              Text(
                data.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  color: color,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

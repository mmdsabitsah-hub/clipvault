import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../services/url_detector.dart';
import '../../shell/nav_controller.dart';
import '../../widgets/clipvault_logo.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/toast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();
  DetectionResult? _result;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged() {
    final text = _controller.text.trim();
    setState(() => _result = text.isEmpty ? null : UrlDetector.detect(text));
  }

  Future<void> _paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trim();
    if (!mounted) return;
    if (text == null || text.isEmpty) {
      showToast(context, 'Clipboard is empty');
      return;
    }
    _controller.text = text;
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 18) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        children: [
          Row(
            children: [
              const ClipVaultLogo(),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppConstants.appName,
                      style: text.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                  Text(AppConstants.tagline,
                      style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 28),
          Text(_greeting(), style: text.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text('Paste a link to get started.',
              style: text.bodyLarge?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: 'https://…',
              prefixIcon: const Icon(Icons.link_rounded),
              suffixIcon: _controller.text.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Clear',
                      icon: const Icon(Icons.close_rounded),
                      onPressed: _controller.clear,
                    ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _paste,
                  icon: const Icon(Icons.content_paste_rounded),
                  label: const Text('Paste Link'),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: _controller.text.isEmpty ? null : _controller.clear,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                icon: const Icon(Icons.backspace_outlined),
                label: const Text('Clear'),
              ),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: _result == null
                ? const SizedBox(width: double.infinity)
                : Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: _DetectionCard(result: _result!),
                  ),
          ),
          const SizedBox(height: 28),
          const _SectionTitle('Quick tools'),
          const SizedBox(height: 12),
          const _QuickTools(),
          const SizedBox(height: 28),
          const _SectionTitle('Recent downloads'),
          const SizedBox(height: 8),
          const Card(
            child: SizedBox(
              height: 180,
              child: EmptyState(
                compact: true,
                icon: Icons.history_rounded,
                title: 'Nothing here yet',
                message: 'Completed downloads will show up here.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) => Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
      );
}

class _DetectionCard extends StatelessWidget {
  const _DetectionCard({required this.result});
  final DetectionResult result;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ok = result.canDownloadDirectly;
    final invalid = result.platform == MediaPlatform.invalid;
    final color = ok ? AppColors.accent : (invalid ? scheme.error : scheme.secondary);
    final icon = ok
        ? Icons.check_circle_rounded
        : (invalid ? Icons.error_outline_rounded : Icons.info_outline_rounded);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(result.label,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(result.message,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: scheme.onSurfaceVariant)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickTools extends StatelessWidget {
  const _QuickTools();

  static const _tools = [
    (Icons.content_cut_rounded, 'Trim'),
    (Icons.crop_rounded, 'Crop'),
    (Icons.rotate_90_degrees_cw_rounded, 'Rotate'),
    (Icons.compress_rounded, 'Compress'),
    (Icons.audiotrack_rounded, 'Extract audio'),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _tools.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final (icon, label) = _tools[i];
          return InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: () => context.read<NavController>().go(NavController.editor),
            child: Container(
              width: 92,
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: scheme.primary),
                  const SizedBox(height: 8),
                  Text(label,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

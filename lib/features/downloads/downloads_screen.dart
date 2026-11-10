import 'package:flutter/material.dart';
import '../../widgets/empty_state.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Downloads',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
            const Expanded(
              child: EmptyState(
                icon: Icons.download_rounded,
                title: 'No downloads yet',
                message: 'Your download queue and history will appear here. The download manager is built in Stage 4.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

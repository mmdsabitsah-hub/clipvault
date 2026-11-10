import 'package:flutter/material.dart';
import '../../widgets/empty_state.dart';

class EditorScreen extends StatelessWidget {
  const EditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Editor',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
            const Expanded(
              child: EmptyState(
                icon: Icons.content_cut_rounded,
                title: 'Media editor',
                message: 'Trim, crop, rotate, compress and extract audio from your own files. The editing engine is built in Stage 6.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

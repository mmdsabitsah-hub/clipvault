import 'package:flutter/material.dart';
import '../../widgets/empty_state.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Library',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
            const Expanded(
              child: EmptyState(
                icon: Icons.video_library_rounded,
                title: 'Your library is empty',
                message: 'Downloaded and imported media will be organised here. The local library and database are built in Stage 3.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

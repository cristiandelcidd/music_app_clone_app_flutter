import 'package:client/features/home/view/pages/upload_song_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:client/core/providers/current_user_notifier.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(
        child: Text('Welcome, ${user?.name}!', style: TextStyle(fontSize: 24)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to upload song page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UploadSongPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

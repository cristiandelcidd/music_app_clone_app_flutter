import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/theme/theme.dart';
import 'package:client/features/auth/view/pages/signup_page.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/features/home/view/pages/upload_song_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();

  await container.read(authViewModelProvider.notifier).initSharedPreferences();
  await container.read(authViewModelProvider.notifier).getData();

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserNotifierProvider);

    final home =
        currentUser == null ? const SignupPage() : const UploadSongPage();

    return MaterialApp(
      title: 'Music App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkThemeMode,
      home: home,
    );
  }
}

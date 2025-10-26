import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medi_app/views/login_screen.dart';
import 'package:medi_app/views/home_screen.dart';
import 'package:medi_app/controllers/auth_provider.dart';

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MediApp',
        home: authState == null ? const LoginScreen() : const HomeScreen(),
      ),
    );
  }
}

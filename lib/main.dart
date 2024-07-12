import 'package:chat_with_gemini/MyHomePage.dart';
import 'package:chat_with_gemini/onboarding.dart';
import 'package:chat_with_gemini/themeNotifier.dart';
import 'package:chat_with_gemini/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final themeMode =ref.watch(themeProvider);
    return MaterialApp(
      title: 'Chat Gemini',
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      darkTheme: darkMode,
      themeMode: themeMode,

      home: const Onboarding(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ui/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: StarkzApp()));
}

class StarkzApp extends StatelessWidget {
  const StarkzApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Starkzapp - Profile Explorer',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
        cardTheme: const CardThemeData(elevation: 2, margin: EdgeInsets.zero),
      ),
      home: const HomeScreen(),
    );
  }
}

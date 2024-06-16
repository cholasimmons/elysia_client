import 'package:dummy/_providers/auth_provider.dart';
import 'package:dummy/_providers/stats_provider.dart';
import 'package:dummy/_views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          // ChangeNotifierProvider(create: (_) => NavigationProvider()),
          ChangeNotifierProvider(create: (_) => StatsProvider()),
        ],
        child: MaterialApp(
            title: 'Elysia Client',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyanAccent),
              useMaterial3: true,
            ),
            home: const HomeView(title: 'Elysia Server Stats')));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:police_dispatch_client/police_dispatch_client.dart';

import 'screens/dashboard_screen.dart';

/// Application entry point.
///
/// Wraps the entire widget tree in [ProviderScope] so Riverpod providers
/// are accessible from any descendant widget.
void main() {
  // Initialise the Serverpod client pointing to the dispatch server.
  // In production, replace 'localhost' with the server's public hostname.
  final client = Client('http://localhost:8080/');

  runApp(
    ProviderScope(
      overrides: [
        // Make the Serverpod client available throughout the app
        clientProvider.overrideWithValue(client),
      ],
      child: const PoliceDispatchApp(),
    ),
  );
}

/// Root widget — sets up the Material theme and routing.
class PoliceDispatchApp extends StatelessWidget {
  const PoliceDispatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Titan System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1565C0), // Deep police blue
          secondary: Color(0xFF00B0FF), // Accent cyan
          surface: Color(0xFF1A1A2E),
          error: Color(0xFFCF6679),
        ),
        scaffoldBackgroundColor: const Color(0xFF0D0D1A),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}

/// Global provider that holds the Serverpod [Client] instance.
/// Overridden in [main] with the real client.
final clientProvider = Provider<Client>((ref) {
  throw UnimplementedError('clientProvider must be overridden in main()');
});

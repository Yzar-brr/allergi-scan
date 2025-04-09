import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home/home.dart';
import 'services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService().createDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AlergiScan',
      theme: ThemeData(
        useMaterial3: true,
          textTheme: GoogleFonts.latoTextTheme(
            Theme.of(context).textTheme,
          ),
      ),

      home: const Home(),
    );
  }
}

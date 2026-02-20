import 'package:flutter/material.dart';
import 'package:organiza_t/view/espacio_view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: Colors.teal,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        //===== BOTONES ELEVADOS (ElevatedButton) =====
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal[200],
            foregroundColor: Colors.black,
            padding: EdgeInsets.all(16),
          ),
        ),

        floatingActionButtonTheme: FloatingActionButtonThemeData(elevation: 0),

        // ===== CAMPOS DE TEXTO (TextField) =====
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.all(16),
        ),
        // ===== CARDS ============
        cardTheme: CardThemeData(
          color: Colors.teal[100],
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: 'ORGANIZA-T',
      home: EspacioView(),
    );
  }
}

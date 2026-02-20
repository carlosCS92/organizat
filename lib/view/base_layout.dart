import 'package:flutter/material.dart';

///Vista general de la aplicación.
///@param child (Widget del body de la aplicacion)
class BaseLayout extends StatelessWidget {
  final Widget child;

  const BaseLayout({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Center(
          child: Text(
            "Organiza-T",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: child,
    );
  }
}

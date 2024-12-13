import 'package:flutter/material.dart';
import 'screens/book_list_screen.dart';

void main() {
  runApp(const Bookology());
}

class Bookology extends StatelessWidget {
  const Bookology({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Discovery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const BookListScreen(),
    );
  }
}
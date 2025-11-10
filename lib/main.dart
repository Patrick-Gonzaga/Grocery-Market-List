import 'package:flutter/material.dart';
import 'package:market_management/ui/home_page.dart';

void main() {
  runApp(MaterialApp(home: Home()));
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}

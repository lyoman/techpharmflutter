import 'package:flutter/material.dart';
import './pages/HomeScreen.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.deepPurple),title: 'Pharmacy Locator', home: HomeScreen());
  }
}
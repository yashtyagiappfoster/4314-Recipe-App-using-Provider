import 'package:flutter/material.dart';
import 'package:food_app/provider/recipe_provider.dart';
import 'package:food_app/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RecipeProvider(),
      child: MaterialApp(
        title: 'Food Recipe App',
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}

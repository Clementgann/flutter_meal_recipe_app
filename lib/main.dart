import 'package:flutter/material.dart';
import 'package:meal_recipe_app/providers/meal_provider.dart';
import 'package:provider/provider.dart';
import 'screens/meal_grid_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final mealProvider = MealProvider();
  await mealProvider.loadMeals();  // Load meals from shared preferences
  runApp(MyApp(mealProvider: mealProvider));
}

class MyApp extends StatelessWidget {
  final MealProvider mealProvider;

  const MyApp({super.key, required this.mealProvider});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: mealProvider,
      child: MaterialApp(
        title: 'Meal Recipe App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const MealGridScreen(),
      ),
    );
  }
}

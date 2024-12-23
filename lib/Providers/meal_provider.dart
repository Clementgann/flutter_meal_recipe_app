import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:meal_recipe_app/Models/meal_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MealProvider with ChangeNotifier {
  List<MealModel> _meals = [];
  List<MealModel> get meals => _meals;

  // Load meals from SharedPreferences
  Future<void> loadMeals() async {
    final prefs = await SharedPreferences.getInstance();
    final mealsData = prefs.getString('meals');
    if (mealsData != null) {
      final List<dynamic> mealsJson = json.decode(mealsData);
      _meals = mealsJson.map((meal) => MealModel.fromJson(meal)).toList();
      notifyListeners();
    }
  }

  // Save meals to SharedPreferences
  Future<void> saveMeals() async {
    final prefs = await SharedPreferences.getInstance();
    final mealsJson = _meals.map((meal) => meal.toJson()).toList();
    await prefs.setString('meals', json.encode(mealsJson));
  }

  // Add a new meal
  void addMeal(MealModel meal) {
    _meals.add(meal);
    saveMeals();  // Save updated meals
    notifyListeners();
  }

  // Update an existing meal
  void updateMeal(MealModel updatedMeal) {
    final index = _meals.indexWhere((meal) => meal.name == updatedMeal.name);
    if (index != -1) {
      _meals[index] = updatedMeal;
      saveMeals();  // Save updated meals
      notifyListeners();
    }
  }

  void removeMeal(MealModel meal) {
    _meals.remove(meal);
    notifyListeners(); // Notify listeners to update the UI after deletion
  }

  // Filter meals by category
  List<MealModel> filterMealsByCategory(String category) {
    return _meals.where((meal) => meal.category == category).toList();
  }

  // Get available categories
  List<String> getCategories() {
    return _meals.map((meal) => meal.category).toSet().toList();
  }
}

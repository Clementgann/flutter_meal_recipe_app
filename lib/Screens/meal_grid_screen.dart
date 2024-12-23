import 'dart:io';
import 'package:flutter/material.dart';
import 'package:meal_recipe_app/providers/meal_provider.dart';
import 'package:provider/provider.dart';
import 'meal_detail_screen.dart'; // Import MealDetailScreen

import 'add_meal_screen.dart'; // Import the AddMealScreen

class MealGridScreen extends StatefulWidget {
  const MealGridScreen({super.key});

  @override
  _MealGridScreenState createState() => _MealGridScreenState();
}

class _MealGridScreenState extends State<MealGridScreen> {
  String _selectedCategory = 'All'; // Default category is 'All'

  @override
  Widget build(BuildContext context) {
    // Get all meals from the provider
    final meals = Provider.of<MealProvider>(context).meals;

    // Filter meals by selected category
    final filteredMeals = _selectedCategory == 'All'
        ? meals
        : meals.where((meal) => meal.category == _selectedCategory).toList();

    // Get a list of unique categories for the dropdown
    final categories = ['All', ...meals.map((meal) => meal.category).toSet()];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meals'),
      ),
      body: Column(
        children: <Widget>[
          // Category Filter Dropdown
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _selectedCategory,
              onChanged: (String? newCategory) {
                setState(() {
                  _selectedCategory = newCategory!;
                });
              },
              items: categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
            ),
          ),

          // Handle empty meal list
          if (filteredMeals.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  'No meals available. Please add a meal.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            // Meal Grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75, // Adjust aspect ratio to fit the layout
                ),
                itemCount: filteredMeals.length,
                itemBuilder: (ctx, index) {
                  final meal = filteredMeals[index];
                  return Dismissible(
                    key: Key(meal.name),
                    direction: DismissDirection.endToStart, // Swipe to delete
                    onDismissed: (direction) {
                      // Delete the meal from the provider
                      Provider.of<MealProvider>(context, listen: false).removeMeal(meal);
                      // Show a snackbar after deletion
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${meal.name} deleted')),
                      );
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to MealDetailScreen with Hero animation
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => MealDetailScreen(meal: meal),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Hero animation for image
                            Hero(
                              tag: meal.name, // Ensure the tag matches in both screens
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                child: meal.imagePath != null
                                    ? Image.file(
                                        File(meal.imagePath!),
                                        height: 150,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(height: 150, color: Colors.grey),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  // Bold meal title
                                  Text(
                                    meal.name,
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  // Meal description with smaller font size
                                  Text(
                                    meal.description,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      // Floating Action Button (FAB) to add a new meal
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to AddMealScreen to add a new meal
          Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => const AddMealScreen()),
          );
        },
        tooltip: 'Add New Meal',
        child: const Icon(Icons.add),
      ),
    );
  }
}

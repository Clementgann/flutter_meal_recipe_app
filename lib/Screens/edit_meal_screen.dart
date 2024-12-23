import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meal_recipe_app/Models/meal_model.dart';
import 'package:permission_handler/permission_handler.dart'; // Permission handler

import 'package:meal_recipe_app/providers/meal_provider.dart';
import 'package:provider/provider.dart';

class EditMealScreen extends StatefulWidget {
  final MealModel meal;

  const EditMealScreen({super.key, required this.meal});

  @override
  _EditMealScreenState createState() => _EditMealScreenState();
}

class _EditMealScreenState extends State<EditMealScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _ingredientsController = TextEditingController();
  File? _image;

  @override
  void initState() {
    super.initState();
    // Initialize form controllers with existing meal data
    _nameController.text = widget.meal.name;
    _descriptionController.text = widget.meal.description;
    _categoryController.text = widget.meal.category;
    _ingredientsController.text = widget.meal.ingredients.join(', ');
    _image = widget.meal.imagePath != null ? File(widget.meal.imagePath!) : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _ingredientsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    // Request storage permission
    PermissionStatus status = await Permission.photos.request();
    if (status.isGranted) {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _image = File(image.path);
        });
      }
    } else {
      // Handle permission denied
      print('Permission denied');
      // Optionally, show a Snackbar or AlertDialog to inform the user
    }
  }

  void _saveMeal() {
    if (_formKey.currentState!.validate()) {
      final newMealModel = MealModel(
        name: _nameController.text,
        description: _descriptionController.text,
        category: _categoryController.text,
        ingredients: _ingredientsController.text.split(',').map((e) => e.trim()).toList(),
        imagePath: _image?.path,
      );

      // Update the meal using Provider
      Provider.of<MealProvider>(context, listen: false).updateMeal(newMealModel);

      // Go back to the previous screen
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Meal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _image == null
                        ? const Center(child: Text('Tap to pick an image'))
                        : Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Meal Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a meal name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Meal Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(labelText: 'Meal Category'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a category';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _ingredientsController,
                  decoration: const InputDecoration(labelText: 'Ingredients (comma separated)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter ingredients';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: _saveMeal,
                  child: const Text('Save Meal'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

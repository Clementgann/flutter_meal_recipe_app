import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meal_recipe_app/Models/meal_model.dart';
import 'package:permission_handler/permission_handler.dart'; // Permission handler
import 'package:meal_recipe_app/providers/meal_provider.dart';
import 'package:provider/provider.dart';

class MealDetailScreen extends StatefulWidget {
  final MealModel meal;

  const MealDetailScreen({super.key, required this.meal});

  @override
  _MealDetailScreenState createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  bool _isEditing = false;

  // Text controllers for form fields in edit mode
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  late TextEditingController _ingredientsController;

  // Image File for updating the image
  File? _image;

  @override
  void initState() {
    super.initState();

    // Initialize the controllers with meal data
    _nameController = TextEditingController(text: widget.meal.name);
    _descriptionController = TextEditingController(text: widget.meal.description);
    _categoryController = TextEditingController(text: widget.meal.category);
    _ingredientsController = TextEditingController(text: widget.meal.ingredients.join(', '));

    // Initialize the image path if it exists
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

  // Method to pick an image
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
    }
  }

  // Method to save the edited meal
  void _saveMeal() {
    final updatedMeal = MealModel(
      name: _nameController.text,
      description: _descriptionController.text,
      category: _categoryController.text,
      ingredients: _ingredientsController.text.split(',').map((e) => e.trim()).toList(),
      imagePath: _image?.path,
    );

    // Update the meal using Provider
    Provider.of<MealProvider>(context, listen: false).updateMeal(updatedMeal);

    // Go back to the previous screen
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.meal.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Hero animation for image
            Hero(
              tag: widget.meal.name, // Ensure the tag matches in both screens
              child: GestureDetector(
                onTap: _pickImage, // Allow image picking in edit mode
                child: Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _image == null
                      ? const Center(child: Text('No Image Available'))
                      : Image.file(
                          _image!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Meal title
            Text(
              widget.meal.name,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Meal description
            Text(widget.meal.description),
            const SizedBox(height: 16),
            // Ingredients
            const Text('Ingredients:'),
            Text(widget.meal.ingredients.join(', ')),
            const SizedBox(height: 16),
            // Category
            Text('Category: ${widget.meal.category}'),
            const SizedBox(height: 16),

            // Edit button if not in edit mode
            if (!_isEditing)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = true; // Switch to edit mode
                    });
                  },
                  child: const Text('Edit Meal'),
                ),
              )
            else
              Center(
                child: ElevatedButton(
                  onPressed: _saveMeal, // Save the meal when in edit mode
                  child: const Text('Save Changes'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

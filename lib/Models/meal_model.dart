import 'package:json_annotation/json_annotation.dart';

part 'meal.g.dart';

@JsonSerializable()
class MealModel {
  final String name;
  final String description;
  final String category;
  final List<String> ingredients;
  final String? imagePath;

  MealModel({
    required this.name,
    required this.description,
    required this.category,
    required this.ingredients,
    this.imagePath,
  });

  // From JSON
  factory MealModel.fromJson(Map<String, dynamic> json) => _$MealModelFromJson(json);

  // To JSON
  Map<String, dynamic> toJson() => _$MealModelToJson(this);

  // Convert image from File to String
  static MealModel fromJsonWithImage(Map<String, dynamic> json) {
    final imagePath = json['imagePath'];
    return MealModel(
      name: json['name'],
      description: json['description'],
      category: json['category'],
      ingredients: List<String>.from(json['ingredients']),
      imagePath: imagePath,
    );
  }

  Map<String, dynamic> toJsonWithImage() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'ingredients': ingredients,
      'imagePath': imagePath,
    };
  }
}


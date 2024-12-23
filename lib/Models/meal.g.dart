// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_model.dart';

MealModel _$MealModelFromJson(Map<String, dynamic> json) {
  return MealModel(
    name: json['name'] as String,
    description: json['description'] as String,
    category: json['category'] as String,
    ingredients: (json['ingredients'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    imagePath: json['imagePath'] as String?,
  );
}

Map<String, dynamic> _$MealModelToJson(MealModel instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'category': instance.category,
      'ingredients': instance.ingredients,
      'imagePath': instance.imagePath,
    };

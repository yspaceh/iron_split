import 'package:flutter/material.dart';
import 'package:iron_split/gen/strings.g.dart';

class CategoryConstant {
  final String id;
  final String labelKey;
  final IconData icon;

  const CategoryConstant({
    required this.id,
    required this.labelKey,
    required this.icon,
  });

  static CategoryConstant getCategoryById(String? id) {
    return kAppCategories.firstWhere(
      (category) => category.id == id,
      orElse: () => kAppCategories.last, // Default to 'others'
    );
  }

  String getName(Translations t) {
    switch (id) {
      case 'fastfood':
        return t.category.food;
      case 'directions_bus':
        return t.category.transport;
      case 'shopping_bag':
        return t.category.shopping;
      case 'movie':
        return t.category.entertainment;
      case 'hotel':
        return t.category.accommodation;
      case 'more_horiz':
      default:
        return t.category.others;
    }
  }
}

const List<CategoryConstant> kAppCategories = [
  CategoryConstant(
      id: 'fastfood', labelKey: 't.category.food', icon: Icons.fastfood),
  CategoryConstant(
      id: 'directions_bus',
      labelKey: 't.category.transport',
      icon: Icons.directions_bus),
  CategoryConstant(
      id: 'shopping_bag',
      labelKey: 't.category.shopping',
      icon: Icons.shopping_bag),
  CategoryConstant(
      id: 'movie', labelKey: 't.category.entertainment', icon: Icons.movie),
  CategoryConstant(
      id: 'hotel', labelKey: 't.category.accommodation', icon: Icons.hotel),
  CategoryConstant(
      id: 'more_horiz', labelKey: 't.category.others', icon: Icons.more_horiz),
];

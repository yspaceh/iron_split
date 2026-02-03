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
        return t.common.category.food;
      case 'directions_bus':
        return t.common.category.transport;
      case 'shopping_bag':
        return t.common.category.shopping;
      case 'movie':
        return t.common.category.entertainment;
      case 'hotel':
        return t.common.category.accommodation;
      case 'more_horiz':
      default:
        return t.common.category.others;
    }
  }
}

const List<CategoryConstant> kAppCategories = [
  CategoryConstant(
      id: 'fastfood',
      labelKey: 't.common.category.food',
      icon: Icons.fastfood_outlined),
  CategoryConstant(
      id: 'directions_bus',
      labelKey: 't.common.category.transport',
      icon: Icons.directions_bus_outlined),
  CategoryConstant(
      id: 'shopping_bag',
      labelKey: 't.common.category.shopping',
      icon: Icons.shopping_bag_outlined),
  CategoryConstant(
      id: 'movie',
      labelKey: 't.common.category.entertainment',
      icon: Icons.movie_outlined),
  CategoryConstant(
      id: 'hotel',
      labelKey: 't.common.category.accommodation',
      icon: Icons.hotel_outlined),
  CategoryConstant(
      id: 'more_horiz',
      labelKey: 't.common.category.others',
      icon: Icons.more_horiz),
];

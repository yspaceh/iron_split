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

  static const String defaultCategory = 'fastfood';

  String getName(Translations t) {
    switch (id) {
      case 'fastfood':
        return t.common.category.food;
      case 'directions_bus':
        return t.common.category.transport;
      case 'shopping_bag':
        return t.common.category.shopping;
      case 'entertainment':
        return t.common.category.entertainment;
      case 'hotel':
        return t.common.category.accommodation;
      case 'daily':
        return t.common.category.daily;
      case 'rent':
        return t.common.category.rent;
      case 'utilities':
        return t.common.category.utilities;
      case 'more_horiz':
      default:
        return t.common.category.others;
    }
  }

  static String getHint(Translations t, String? id) {
    switch (id) {
      case 'fastfood':
        return t.s15_record_edit.hint.category.food;
      case 'directions_bus':
        return t.s15_record_edit.hint.category.transport;
      case 'shopping_bag':
        return t.s15_record_edit.hint.category.shopping;
      case 'entertainment':
        return t.s15_record_edit.hint.category.entertainment;
      case 'hotel':
        return t.s15_record_edit.hint.category.accommodation;
      case 'daily':
        return t.s15_record_edit.hint.category.daily;
      case 'rent':
        return t.s15_record_edit.hint.category.rent;
      case 'utilities':
        return t.s15_record_edit.hint.category.utilities;
      case 'more_horiz':
      default:
        return t.s15_record_edit.hint.category.others;
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
      id: 'entertainment',
      labelKey: 't.common.category.entertainment',
      icon: Icons.attractions_outlined),
  CategoryConstant(
      id: 'hotel',
      labelKey: 't.common.category.accommodation',
      icon: Icons.hotel_outlined),
  CategoryConstant(
      id: 'daily',
      labelKey: 't.common.category.daily',
      icon: Icons.cleaning_services_outlined),
  CategoryConstant(
      id: 'rent',
      labelKey: 't.common.category.rent',
      icon: Icons.home_work_outlined),
  CategoryConstant(
      id: 'utilities',
      labelKey: 't.common.category.utilities',
      icon: Icons.wb_incandescent_outlined),
  CategoryConstant(
      id: 'more_horiz',
      labelKey: 't.common.category.others',
      icon: Icons.interests_outlined),
];

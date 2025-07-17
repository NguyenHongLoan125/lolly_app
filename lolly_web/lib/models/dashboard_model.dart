import 'package:flutter/material.dart';

class BlockModel {
  final String title;
  final int value;
  final String unit;
  final IconData icon;

  BlockModel({
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
  });
}

class Category {
  final int? id;
  final String? name;

  Category({required this.id, required this.name});

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['category_name'],
    );
  }
}

class SubCategory {
  final int? id;
  final String? name;
  final int? categoryId;

  SubCategory({required this.id, required this.name, required this.categoryId});

  factory SubCategory.fromMap(Map<String, dynamic> map) {
    return SubCategory(
      id: map['id'],
      name: map['sub_category_name'],
      categoryId: map['category'],
    );
  }
}


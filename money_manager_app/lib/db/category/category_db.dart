import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_manager_app/models/category/category_model.dart';

const CATEGORY_DB_NAME = 'category-database';

abstract class CategoryDbFunctions {
  Future<List<CategoryModel>> getcategory();
  Future<void> insertCategory(CategoryModel value);
  Future<void> deleteCategory(String categoryId);
}

class CategoryDb implements CategoryDbFunctions {
  CategoryDb._internal();

  static CategoryDb instance = CategoryDb._internal();

  factory CategoryDb() {
    return CategoryDb.instance;
  }

  ValueNotifier<List<CategoryModel>> incomeCategoryList = ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expanseCategoryList = ValueNotifier([]);

  @override
  Future<void> insertCategory(CategoryModel value) async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await _categoryDB.put(value.id, value);
    refreshUI();
  }

  @override
  Future<List<CategoryModel>> getcategory() async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    return _categoryDB.values.toList();
  }

  Future<void> refreshUI() async {
    final _allCategories = await getcategory();
    incomeCategoryList.value.clear();
    expanseCategoryList.value.clear();
    await Future.forEach(
      _allCategories,
      (CategoryModel category) {
        if (category.type == CategoryType.income) {
          incomeCategoryList.value.add(category);
        } else {
          expanseCategoryList.value.add(category);
        }
      },
    );
    incomeCategoryList.notifyListeners();
    expanseCategoryList.notifyListeners();
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    final _categoryDb = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await _categoryDb.delete(categoryId);
    refreshUI();
  }
}

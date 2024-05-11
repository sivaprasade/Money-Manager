import 'package:flutter/material.dart';
import 'package:money_manager_app/db/category/category_db.dart';
import 'package:money_manager_app/models/category/category_model.dart';

ValueNotifier<CategoryType> selectedCategory =
    ValueNotifier(CategoryType.income);

Future<void> showCategoryAddPopup(BuildContext context) async {
  final _nameEditingController = TextEditingController();
  showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: const Text('add category'),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _nameEditingController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Category',
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    RadioButton(
                      title: 'Income',
                      type: CategoryType.income,
                    ),
                    RadioButton(title: 'Expanse', type: CategoryType.expanse),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  final _name = _nameEditingController.text;
                  if (_name.isEmpty) {
                    return;
                  }
                  final _type = selectedCategory.value;
                  final _category = CategoryModel(
                      id: DateTime.now().microsecondsSinceEpoch.toString(),
                      name: _name,
                      type: _type);
                  CategoryDb().insertCategory(_category);
                  Navigator.of(ctx).pop();
                },
                child: const Text('add'),
              ),
            )
          ],
        );
      });
}

class RadioButton extends StatelessWidget {
  final String title;
  final CategoryType type;

  const RadioButton({super.key, required this.title, required this.type});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
          valueListenable: selectedCategory,
          builder: (BuildContext ctx, CategoryType newCategory, Widget? _) {
            return Radio<CategoryType>(
                value: type,
                groupValue: newCategory,
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  selectedCategory.value = value;
                  selectedCategory.notifyListeners();
                });
          },
        ),
        Text(title),
      ],
    );
  }
}

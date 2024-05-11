import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:money_manager_app/db/category/category_db.dart';

import '../../models/category/category_model.dart';

class ExpanseCategoryList extends StatelessWidget {
  const ExpanseCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: CategoryDb().expanseCategoryList,
        builder: (BuildContext ctx, List<CategoryModel> newList, Widget? _) {
          return ListView.separated(
            itemBuilder: (ctx, index) {
              final category = newList[index];
              return Card(
                child: ListTile(
                  title: Text(category.name),
                  trailing: IconButton(
                      onPressed: () {
                        CategoryDb.instance.deleteCategory(category.id);
                      },
                      icon: const Icon(Icons.delete)),
                ),
              );
            },
            separatorBuilder: (ctx, index) {
              return SizedBox(
                height: 10,
              );
            },
            itemCount: newList.length,
          );
        });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:money_manager_app/db/category/category_db.dart';
import 'package:money_manager_app/models/category/category_model.dart';
import 'package:money_manager_app/screen/add_transaction/screen_add_transaction.dart';
import 'package:money_manager_app/screen/category/category_add_popup.dart';
import 'package:money_manager_app/screen/category/screen_category.dart';
import 'package:money_manager_app/screen/home/widgets/bottom_navigation.dart';
import 'package:money_manager_app/screen/transactions/screen_transaction.dart';

class ScreenHome extends StatelessWidget {
  ScreenHome({super.key});

  static ValueNotifier<int> selectIndexNotifer = ValueNotifier(0);

  final _pages = [ScreenTransaction(), ScreenCategory()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Money Manager'),
        centerTitle: true,
      ),
      bottomNavigationBar: const MoneyManagerBottomNavigation(),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: selectIndexNotifer,
          builder: (BuildContext context, int updatedIndex, _) {
            return _pages[updatedIndex];
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectIndexNotifer.value == 0) {
            print('transaction add');
            Navigator.of(context).pushNamed(ScreenAddTransaction.routeName);
          } else {
            print('category add');

            showCategoryAddPopup(context);

            //final _sample = CategoryModel(
            //  id: DateTime.now().millisecond.toString(),
            //  name: "travel",
            //   type: CategoryType.expanse);
            //CategoryDb().insertCategory(_sample);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

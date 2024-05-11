import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:money_manager_app/db/category/category_db.dart';
import 'package:money_manager_app/screen/category/expense_category_list.dart';
import 'package:money_manager_app/screen/category/income_category_list.dart';

class ScreenCategory extends StatefulWidget {
  const ScreenCategory({super.key});

  @override
  State<ScreenCategory> createState() => _ScreenCategoryState();
}

class _ScreenCategoryState extends State<ScreenCategory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    CategoryDb().refreshUI();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            controller: _tabController,
            tabs: [
              Tab(text: 'INCOME'),
              Tab(
                text: 'EXPENSE',
              )
            ]),
        Expanded(
          child: TabBarView(
              controller: _tabController,
              children: [IncomeCategoryList(), ExpanseCategoryList()]),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_manager_app/db/category/category_db.dart';
import 'package:money_manager_app/db/transaction/transaction_db.dart';
import 'package:money_manager_app/models/category/category_model.dart';

import '../../models/transaction/transaction_model.dart';

class ScreenTransaction extends StatelessWidget {
  const ScreenTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refresh();
    CategoryDb.instance.refreshUI();
    return ValueListenableBuilder(
        valueListenable: TransactionDB.instance.transactionNotifier,
        builder: (BuildContext ctx, List<TransactionModel> newList, Widget? _) {
          return ListView.separated(
            padding: const EdgeInsets.all(10),
            itemBuilder: (ctx, index) {
              final _value = newList[index];
              return Slidable(
                key: Key(_value.id!),
                startActionPane: ActionPane(
                  motion: ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (ctx) {
                        TransactionDB.instance.deleteTransaction(_value.id!);
                      },
                      backgroundColor: Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: Card(
                  elevation: 0,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 50,
                      child: Text(
                        parseDate(_value.date),
                        textAlign: TextAlign.center,
                      ),
                      backgroundColor: _value.type == CategoryType.income
                          ? Colors.green
                          : Colors.red,
                    ),
                    title: Text('RS ${_value.amount.toString()}'),
                    subtitle: Text(_value.category.name),
                  ),
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

  String parseDate(DateTime date) {
    final _date = DateFormat.MMMd().format(date);
    final _splitDate = _date.split(' ');
    return '${_splitDate.last}\n ${_splitDate.first}';
  }
}

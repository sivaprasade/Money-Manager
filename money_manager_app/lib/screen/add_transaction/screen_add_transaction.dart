import 'package:flutter/material.dart';
import 'package:money_manager_app/db/category/category_db.dart';
import 'package:money_manager_app/db/transaction/transaction_db.dart';
import 'package:money_manager_app/models/category/category_model.dart';
import 'package:money_manager_app/models/transaction/transaction_model.dart';

class ScreenAddTransaction extends StatefulWidget {
  static const routeName = 'add-transaction';
  const ScreenAddTransaction({super.key});

  @override
  State<ScreenAddTransaction> createState() => _ScreenAddTransactionState();
}

class _ScreenAddTransactionState extends State<ScreenAddTransaction> {
  DateTime? _selectedDate;
  CategoryType? _selectedCategorytype;
  CategoryModel? _selectedCategorymodel;

  String? _categoryId;
  final _purposeController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void initState() {
    _selectedCategorytype = CategoryType.income;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _purposeController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Purpose'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Amount'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton.icon(
              onPressed: () async {
                final _selectedDatetemp = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(Duration(days: 30)),
                    lastDate: DateTime.now());
                if (_selectedDatetemp == null) {
                  return;
                } else {
                  setState(() {
                    _selectedDate = _selectedDatetemp;
                  });
                }
              },
              icon: const Icon(Icons.calendar_today),
              label: Text(_selectedDate == null
                  ? 'select date'
                  : _selectedDate.toString()),
            ),
            Row(
              children: [
                Row(
                  children: [
                    Radio(
                        value: CategoryType.income,
                        groupValue: _selectedCategorytype,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCategorytype = CategoryType.income;
                            _categoryId = null;
                          });
                        }),
                    const Text('Income'),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                        value: CategoryType.expanse,
                        groupValue: _selectedCategorytype,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCategorytype = CategoryType.expanse;
                            _categoryId = null;
                          });
                        }),
                    const Text('Expanse'),
                  ],
                ),
              ],
            ),
            DropdownButton(
                hint: const Text('select category'),
                value: _categoryId,
                items: (_selectedCategorytype == CategoryType.income
                        ? CategoryDb.instance.incomeCategoryList
                        : CategoryDb.instance.expanseCategoryList)
                    .value
                    .map((e) {
                  return DropdownMenuItem(
                    value: e.id,
                    child: Text(e.name),
                    onTap: () {
                      _selectedCategorymodel = e;
                    },
                  );
                }).toList(),
                onChanged: (selectedValue) {
                  setState(() {
                    _categoryId = selectedValue;
                  });
                }),
            ElevatedButton(
                onPressed: () {
                  addTransaction();
                },
                child: const Text('Submit'))
          ],
        ),
      )),
    );
  }

  Future<void> addTransaction() async {
    final _purposeText = _purposeController.text;
    final _amountText = _amountController.text;
    if (_purposeText.isEmpty) {
      return;
    }
    if (_amountText.isEmpty) {
      return;
    }
    if (_categoryId == null) {
      return;
    }
    if (_selectedCategorymodel == null) {
      return;
    }
    final _parsedAmount = double.tryParse(_amountText);

    if (_parsedAmount == null) {
      return;
    }

    final _model = TransactionModel(
        purpose: _purposeText,
        amount: _parsedAmount,
        date: _selectedDate!,
        type: _selectedCategorytype!,
        category: _selectedCategorymodel!);
    await TransactionDB.instance.addTransaction(_model);
    Navigator.of(context).pop();
    TransactionDB.instance.refresh();
  }
}

import 'package:flutter/material.dart';
import 'package:msaassignment/domain/entities/expense.dart';
import 'package:msaassignment/presentation/providers/expenseProvider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddExpenseScreen extends StatefulWidget {
  final Expense? expense;

  AddExpenseScreen({this.expense});

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  late DateTime _date;
  late String _category;

  @override
  void initState() {
    super.initState();
    _amountController =
        TextEditingController(text: widget.expense?.amount.toString() ?? '');
    _descriptionController =
        TextEditingController(text: widget.expense?.description ?? '');
    _date = widget.expense?.date ?? DateTime.now();
    _category = widget.expense?.category ?? 'Other';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.expense == null ? 'Add Expense' : 'Edit Expense'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            SizedBox(height: 40,),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            SizedBox(height: 40,),

            ListTile(
              tileColor: Color(0xFF1E1E1E),
              title: Text('Date'),
              subtitle: Text(_date.toString().split(' ')[0]),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  setState(() {
                    _date = pickedDate;
                  });
                }
              },
            ),
            SizedBox(height: 40,),

            DropdownButtonFormField<String>(
              value: _category,
              decoration: InputDecoration(labelText: 'Category'),
              items: ['Food', 'Transport', 'Entertainment', 'Bills', 'Other']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _category = newValue!;
                });
              },
            ),
            SizedBox(height: 20),

            ElevatedButton(
              child: Text(
                  widget.expense == null ? 'Add Expense' : 'Update Expense'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final expense = Expense(
                    id: widget.expense?.id ?? Uuid().v4(),
                    amount: double.parse(_amountController.text),
                    date: _date,
                    description: _descriptionController.text,
                    category: _category,
                  );

                  if (widget.expense == null) {
                    Provider.of<ExpenseProvider>(context, listen: false)
                        .addExpense(expense);
                  } else {
                    Provider.of<ExpenseProvider>(context, listen: false)
                        .updateExpense(expense);
                  }

                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

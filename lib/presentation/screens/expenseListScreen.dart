import 'package:flutter/material.dart';
import 'package:msaassignment/domain/entities/expense.dart';
import 'package:provider/provider.dart';
import '../providers/expenseProvider.dart';
import '../widgets/expenseItem.dart';
import 'addExpenseScreen.dart';
import 'expenseSummaryScreen.dart';

class ExpenseListScreen extends StatefulWidget {
  @override
  _ExpenseListScreenState createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> with TickerProviderStateMixin {
  DateTime? _selectedDate;
  late AnimationController _animationController;
  List<Animation<double>> _itemAnimations = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _prepareAnimations(int itemCount) {
    _itemAnimations = List.generate(
      itemCount,
          (index) => Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            index / itemCount * 0.5,
            (index + 1) / itemCount * 0.5,
            curve: Curves.easeOut,
          ),
        ),
      ),
    );
    _animationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
          IconButton(
            icon: Icon(Icons.summarize),
            onPressed: () {
              _navigateToSummaryScreen(context);
            },
          ),
        ],
      ),
      body: Consumer<ExpenseProvider>(
        builder: (context, expenseProvider, child) {
          if (expenseProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (expenseProvider.error != null) {
            return Center(child: Text(expenseProvider.error!));
          } else {
            final expenses = _selectedDate != null
                ? expenseProvider.getFilteredExpenses(startDate: _selectedDate, endDate: _selectedDate)
                : expenseProvider.expenses;
            expenses.sort((a, b) => b.date.compareTo(a.date));

            if (_itemAnimations.length != expenses.length) {
              _prepareAnimations(expenses.length);
            }

            return Column(
              children: [
                if (_selectedDate != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedDate = null;
                        });
                      },
                      child: Text('Remove Filter'),
                    ),
                  ),
                Expanded(
                  child: expenses.isEmpty
                      ? Center(
                    child: Text(_selectedDate != null
                        ? 'No expenses for the selected date.'
                        : 'No expenses to show.'),
                  )
                      : ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      return AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, 100 * _itemAnimations[index].value),
                            child: Opacity(
                              opacity: 1 - _itemAnimations[index].value,
                              child: child,
                            ),
                          );
                        },
                        child: ExpenseItem(
                          expense: expenses[index],
                          onDelete: () => expenseProvider.deleteExpense(expenses[index].id),
                          onEdit: () {
                            _navigateToAddExpenseScreen(context, expenses[index]);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddExpenseScreen(context, null);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _navigateToSummaryScreen(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ExpenseSummaryScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ).then((_) => _prepareAnimations(_itemAnimations.length));
  }

  void _navigateToAddExpenseScreen(BuildContext context, Expense? expense) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => AddExpenseScreen(expense: expense),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ).then((_) => _prepareAnimations(_itemAnimations.length));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _prepareAnimations(_itemAnimations.length);
    }
  }
}
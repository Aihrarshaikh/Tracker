import 'package:flutter/foundation.dart';
import 'package:msaassignment/domain/entities/expense.dart';
import 'package:msaassignment/domain/repositories/expenseRepository.dart';

class ExpenseProvider with ChangeNotifier {
  final ExpenseRepository _repository;

  ExpenseProvider(this._repository);

  List<Expense> _expenses = [];
  bool _isLoading = false;
  String? _error;

  List<Expense> get expenses => _expenses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadExpenses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _expenses = await _repository.getExpenses();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load expenses: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addExpense(Expense expense) async {
    try {
      await _repository.addExpense(expense);
      await loadExpenses();
    } catch (e) {
      _error = 'Failed to add expense: $e';
      notifyListeners();
    }
  }

  Future<void> updateExpense(Expense expense) async {
    try {
      await _repository.updateExpense(expense);
      await loadExpenses();
    } catch (e) {
      _error = 'Failed to update expense: $e';
      notifyListeners();
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      await _repository.deleteExpense(id);
      await loadExpenses();
    } catch (e) {
      _error = 'Failed to delete expense: $e';
      notifyListeners();
    }
  }

  Future<void> fetchExpenses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _expenses = await _repository.getExpenses();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Expense> getFilteredExpenses({DateTime? startDate, DateTime? endDate, String? category}) {
    return _expenses.where((expense) {
      if (startDate != null && expense.date.isBefore(startDate)) {
        return false;
      }
      if (endDate != null && expense.date.isAfter(endDate)) {
        return false;
      }
      if (category != null && expense.category != category) {
        return false;
      }
      return true;
    }).toList();
  }

  double getTotalExpenses({DateTime? startDate, DateTime? endDate, String? category}) {
    return getFilteredExpenses(startDate: startDate, endDate: endDate, category: category)
        .fold(0, (sum, expense) => sum + expense.amount);
  }

  Map<String, double> getExpensesByCategory() {
    final Map<String, double> categoryExpenses = {};
    for (var expense in _expenses) {
      if (categoryExpenses.containsKey(expense.category)) {
        categoryExpenses[expense.category] = categoryExpenses[expense.category]! + expense.amount;
      } else {
        categoryExpenses[expense.category] = expense.amount;
      }
    }
    return categoryExpenses;
  }

  @visibleForTesting
  void setExpensesForTest(List<Expense> expenses) {
    _expenses = expenses;
    notifyListeners();
  }

}

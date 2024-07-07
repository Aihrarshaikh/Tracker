import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:msaassignment/data/models/expenseModel.dart';

class ExpenseLocalDataSource {
  static const String boxName = 'expenses';

  Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ExpenseModelAdapter());
    await Hive.openBox<ExpenseModel>(boxName);
  }

  Future<List<ExpenseModel>> getExpenses() async {
    final box = await Hive.openBox<ExpenseModel>(boxName);
    return box.values.toList();
  }

  Future<void> addExpense(ExpenseModel expense) async {
    final box = await Hive.openBox<ExpenseModel>(boxName);
    await box.put(expense.id, expense);
  }

  Future<void> updateExpense(ExpenseModel expense) async {
    final box = await Hive.openBox<ExpenseModel>(boxName);
    await box.put(expense.id, expense);
  }

  Future<void> deleteExpense(String id) async {
    final box = await Hive.openBox<ExpenseModel>(boxName);
    await box.delete(id);
  }
}
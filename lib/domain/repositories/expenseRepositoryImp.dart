

import 'package:msaassignment/data/models/expenseModel.dart';
import 'package:msaassignment/domain/entities/expense.dart';
import 'package:msaassignment/domain/repositories/expenseRepository.dart';

import '../../data/datasources/expenseLocalDataSource.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDataSource localDataSource;

  ExpenseRepositoryImpl(this.localDataSource);

  @override
  Future<List<Expense>> getExpenses() async {
    final expenseModels = await localDataSource.getExpenses();
    return expenseModels;
  }

  @override
  Future<void> addExpense(Expense expense) async {
    await localDataSource.addExpense(ExpenseModel.fromEntity(expense));
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    await localDataSource.updateExpense(ExpenseModel.fromEntity(expense));
  }

  @override
  Future<void> deleteExpense(String id) async {
    await localDataSource.deleteExpense(id);
  }
}
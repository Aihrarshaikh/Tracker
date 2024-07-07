import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:msaassignment/domain/entities/expense.dart';
import 'package:msaassignment/domain/repositories/expenseRepository.dart';
import 'package:msaassignment/presentation/providers/expenseProvider.dart';

import 'widget_test.mocks.dart';

@GenerateMocks([ExpenseRepository])

void main() {
  late ExpenseProvider expenseProvider;
  late MockExpenseRepository mockRepository;

  setUp(() {
    mockRepository = MockExpenseRepository();
    expenseProvider = ExpenseProvider(mockRepository);
  });

  group('ExpenseProvider', () {
    test('initial state', () {
      expect(expenseProvider.expenses, isEmpty);
      expect(expenseProvider.isLoading, isFalse);
      expect(expenseProvider.error, isNull);
    });

    group('loadExpenses', () {
      test('should update state correctly when successful', () async {
        final expenses = [
          Expense(id: '1', amount: 100, category: 'Food', date: DateTime.now(), description: 'Groceries'),
          Expense(id: '2', amount: 200, category: 'Transport', date: DateTime.now(), description: 'Taxi'),
        ];

        when(mockRepository.getExpenses()).thenAnswer((_) async => expenses);

        await expenseProvider.loadExpenses();

        expect(expenseProvider.expenses, equals(expenses));
        expect(expenseProvider.isLoading, isFalse);
        expect(expenseProvider.error, isNull);
      });

      test('should update state correctly when an error occurs', () async {
        when(mockRepository.getExpenses()).thenThrow(Exception('Network error'));

        await expenseProvider.loadExpenses();

        expect(expenseProvider.expenses, isEmpty);
        expect(expenseProvider.isLoading, isFalse);
        expect(expenseProvider.error, contains('Failed to load expenses'));
      });
    });

    group('addExpense', () {
      test('should call repository and reload expenses', () async {
        final newExpense = Expense(id: '3', amount: 150, category: 'Entertainment', date: DateTime.now(), description: 'Movie');

        when(mockRepository.addExpense(newExpense)).thenAnswer((_) async {});
        when(mockRepository.getExpenses()).thenAnswer((_) async => [newExpense]);

        await expenseProvider.addExpense(newExpense);

        verify(mockRepository.addExpense(newExpense)).called(1);
        expect(expenseProvider.expenses, [newExpense]);
        expect(expenseProvider.error, isNull);
      });

      test('should update error state when adding expense fails', () async {
        final newExpense = Expense(id: '3', amount: 150, category: 'Entertainment', date: DateTime.now(), description: 'Movie');

        when(mockRepository.addExpense(newExpense)).thenThrow(Exception('Failed to add'));

        await expenseProvider.addExpense(newExpense);

        expect(expenseProvider.error, contains('Failed to add expense'));
      });
    });

    group('updateExpense', () {
      test('should call repository and reload expenses', () async {
        final updatedExpense = Expense(id: '1', amount: 120, category: 'Food', date: DateTime.now(), description: 'Updated Groceries');

        when(mockRepository.updateExpense(updatedExpense)).thenAnswer((_) async {});
        when(mockRepository.getExpenses()).thenAnswer((_) async => [updatedExpense]);

        await expenseProvider.updateExpense(updatedExpense);

        verify(mockRepository.updateExpense(updatedExpense)).called(1);
        expect(expenseProvider.expenses, [updatedExpense]);
        expect(expenseProvider.error, isNull);
      });

      test('should update error state when updating expense fails', () async {
        final updatedExpense = Expense(id: '1', amount: 120, category: 'Food', date: DateTime.now(), description: 'Updated Groceries');

        when(mockRepository.updateExpense(updatedExpense)).thenThrow(Exception('Failed to update'));

        await expenseProvider.updateExpense(updatedExpense);

        expect(expenseProvider.error, contains('Failed to update expense'));
      });
    });

    group('deleteExpense', () {
      test('should call repository and reload expenses', () async {
        when(mockRepository.deleteExpense('1')).thenAnswer((_) async {});
        when(mockRepository.getExpenses()).thenAnswer((_) async => []);

        await expenseProvider.deleteExpense('1');

        verify(mockRepository.deleteExpense('1')).called(1);
        expect(expenseProvider.expenses, isEmpty);
        expect(expenseProvider.error, isNull);
      });

      test('should update error state when deleting expense fails', () async {
        when(mockRepository.deleteExpense('1')).thenThrow(Exception('Failed to delete'));

        await expenseProvider.deleteExpense('1');

        expect(expenseProvider.error, contains('Failed to delete expense'));
      });
    });
    group('getFilteredExpenses', () {
      test('should filter expenses correctly', () {
        final now = DateTime.now();
        final testExpenses = [
          Expense(id: '1', amount: 100, category: 'Food', date: now.subtract(Duration(days: 2)), description: 'Groceries'),
          Expense(id: '2', amount: 200, category: 'Transport', date: now.subtract(Duration(days: 1)), description: 'Taxi'),
          Expense(id: '3', amount: 300, category: 'Entertainment', date: now, description: 'Movie'),
        ];
        expenseProvider.setExpensesForTest(testExpenses);

        final filtered = expenseProvider.getFilteredExpenses(
          startDate: now.subtract(Duration(days: 1)),
          endDate: now,
          category: 'Transport',
        );

        expect(filtered.length, 1);
        expect(filtered.first.id, '2');
      });
    });

    group('getTotalExpenses', () {
      test('should calculate total expenses correctly', () {
        final now = DateTime.now();
        final testExpenses = [
          Expense(id: '1', amount: 100, category: 'Food', date: now.subtract(Duration(days: 2)), description: 'Groceries'),
          Expense(id: '2', amount: 200, category: 'Transport', date: now.subtract(Duration(days: 1)), description: 'Taxi'),
          Expense(id: '3', amount: 300, category: 'Entertainment', date: now, description: 'Movie'),
        ];
        expenseProvider.setExpensesForTest(testExpenses);

        final total = expenseProvider.getTotalExpenses(
          startDate: now.subtract(Duration(days: 1)),
          endDate: now,
        );

        expect(total, 500);
      });
    });

    group('getExpensesByCategory', () {
      test('should group expenses by category correctly', () {
        final testExpenses = [
          Expense(id: '1', amount: 100, category: 'Food', date: DateTime.now(), description: 'Groceries'),
          Expense(id: '2', amount: 200, category: 'Transport', date: DateTime.now(), description: 'Taxi'),
          Expense(id: '3', amount: 150, category: 'Food', date: DateTime.now(), description: 'Restaurant'),
        ];
        expenseProvider.setExpensesForTest(testExpenses);

        final categoryExpenses = expenseProvider.getExpensesByCategory();

        expect(categoryExpenses, {
          'Food': 250,
          'Transport': 200,
        });
      });
    });
  });
}
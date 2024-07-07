import 'package:hive/hive.dart';

import '../../domain/entities/expense.dart';

part 'expenseModel.g.dart';

@HiveType(typeId: 0)
class ExpenseModel extends Expense {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String category;

  ExpenseModel({
    required this.id,
    required this.amount,
    required this.date,
    required this.description,
    required this.category,
  }) : super(
    id: id,
    amount: amount,
    date: date,
    description: description,
    category: category,
  );

  factory ExpenseModel.fromEntity(Expense expense) {
    return ExpenseModel(
      id: expense.id,
      amount: expense.amount,
      date: expense.date,
      description: expense.description,
      category: expense.category,
    );
  }

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      description: json['description'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'date': date.toIso8601String(),
      'description': description,
      'category': category,
    };
  }
}
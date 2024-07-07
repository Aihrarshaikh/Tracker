import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final String id;
  final double amount;
  final DateTime date;
  final String description;
  final String category;

  Expense({
    required this.id,
    required this.amount,
    required this.date,
    required this.description,
    required this.category,
  });

  @override
  List<Object> get props => [id, amount, date, description, category];
}
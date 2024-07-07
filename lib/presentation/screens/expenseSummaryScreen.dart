import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expenseProvider.dart';
import '../widgets/expenseChart.dart';

class ExpenseSummaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Summary'),
      ),
      body: Consumer<ExpenseProvider>(
        builder: (context, expenseProvider, child) {
          final totalExpenses = expenseProvider.getTotalExpenses();
          final weeklyExpenses = expenseProvider.getTotalExpenses(
            startDate: DateTime.now().subtract(Duration(days: 7)),
          );
          final monthlyExpenses = expenseProvider.getTotalExpenses(
            startDate: DateTime.now().subtract(Duration(days: 30)),
          );

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCard(
                  context,
                  'Total Expenses',
                  totalExpenses,
                  Icons.account_balance_wallet,
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        context,
                        'Last 7 Days',
                        weeklyExpenses,
                        Icons.date_range,
                        compact: true,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildSummaryCard(
                        context,
                        'Last 30 Days',
                        monthlyExpenses,
                        Icons.calendar_today,
                        compact: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Text(
                  'Expense by Category',
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleLarge,
                ),
                SizedBox(height: 16),
                ExpenseChart(expenses: expenseProvider.expenses),
                SizedBox(height: 24),
                Text(
                  'Breakdown',
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleLarge,
                ),
                SizedBox(height: 16),
                ..._buildCategoryList(context, expenseProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, double amount,
      IconData icon, {bool compact = false}) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(compact ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme
                    .of(context)
                    .colorScheme
                    .secondary),
                SizedBox(width: 8),
                Text(title, style: Theme
                    .of(context)
                    .textTheme
                    .titleMedium),
              ],
            ),
            if (!compact) SizedBox(height: 8),
            Text(
              '\Rs ${amount.toStringAsFixed(2)}',
              style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                fontWeight: FontWeight.bold,
                // color: Theme.of(context).titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCategoryList(BuildContext context, ExpenseProvider expenseProvider) {
    final categoryExpenses = expenseProvider.getExpensesByCategory();
    final totalExpenses = expenseProvider.getTotalExpenses();

    if (categoryExpenses.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Center(
            child: Text(
              'Nothing to show',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      ];
    }

    return categoryExpenses.entries.map((entry) {
      final color = _getCategoryColor(entry.key);
      final percentage = (entry.value / totalExpenses * 100).toStringAsFixed(1);

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  entry.key,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '\Rs ${entry.value.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$percentage%',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Color(0xFFFF6F00);  // Dark orange
      case 'transport':
        return Color(0xFF1E88E5);  // Dark blue
      case 'entertainment':
        return Color(0xFF8E24AA);  // Dark purple
      case 'bills':
        return Color(0xFF43A047);  // Dark green
      case 'other':
        return Color(0xFF546E7A);  // Dark blue-grey
      default:
        return Color(0xFFE53935);  // Dark red (fallback color)
    }
  }
}



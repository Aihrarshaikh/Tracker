import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:msaassignment/domain/entities/expense.dart';
import 'dart:math' as math;

class ExpenseChart extends StatefulWidget {
  final List<Expense> expenses;

  ExpenseChart({required this.expenses});

  @override
  _ExpenseChartState createState() => _ExpenseChartState();
}

class _ExpenseChartState extends State<ExpenseChart> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Map<String, double> _groupExpensesByCategory() {
    final Map<String, double> categoryExpenses = {};
    for (var expense in widget.expenses) {
      if (categoryExpenses.containsKey(expense.category)) {
        categoryExpenses[expense.category] = categoryExpenses[expense.category]! + expense.amount;
      } else {
        categoryExpenses[expense.category] = expense.amount;
      }
    }
    return categoryExpenses;
  }

  @override
  Widget build(BuildContext context) {
    final groupedExpenses = _groupExpensesByCategory();
    final totalExpense = groupedExpenses.values.fold(0.0, (sum, amount) => sum + amount);

    return Column(
      children: [
        Container(
          height: 250,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return ScaleTransition(
                    scale: _scaleAnimation,
                    child: CustomPaint(
                      size: Size(200, 200),
                      painter: PieChartPainter(
                        groupedExpenses: groupedExpenses,
                        animationValue: _animation.value,
                      ),
                    ),
                  );
                },
              ),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      color: Colors.white.withOpacity(0.1),
                      child: Center(
                        child: AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Total',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Rs ${(totalExpense * _animation.value).toStringAsFixed(0)}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: groupedExpenses.entries.map((entry) {
            return _buildLegendItem(entry.key, entry.value, totalExpense);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String category, double amount, double total) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getCategoryColor(category),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: _getCategoryColor(category),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 6),
          Text(
            '$category: ${(amount / total * 100).toStringAsFixed(1)}%',
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Color(0xFFFF6F00).withOpacity(0.2);  // Dark orange
      case 'transport':
        return Color(0xFF1E88E5).withOpacity(0.2);  // Dark blue
      case 'entertainment':
        return Color(0xFF8E24AA).withOpacity(0.2);  // Dark purple
      case 'bills':
        return Color(0xFF43A047).withOpacity(0.2);  // Dark green
      case 'other':
        return Color(0xFF546E7A).withOpacity(0.2);  // Dark blue-grey
      default:
        return Color(0xFFE53935).withOpacity(0.2);  // Dark red (fallback color)
    }
  }
}

class PieChartPainter extends CustomPainter {
  final Map<String, double> groupedExpenses;
  final double animationValue;

  PieChartPainter({required this.groupedExpenses, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    final total = groupedExpenses.values.fold(0.0, (sum, amount) => sum + amount);
    double startAngle = -math.pi / 2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2);

    groupedExpenses.forEach((category, amount) {
      final sweepAngle = (amount / total) * 2 * math.pi * animationValue;
      paint.color = _getCategoryColor(category);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
      startAngle += sweepAngle;
    });

    // Draw outer glow
    final glowPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..maskFilter = MaskFilter.blur(BlurStyle.outer, 4);

    canvas.drawCircle(center, radius, glowPaint);

    // Draw inner shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..maskFilter = MaskFilter.blur(BlurStyle.inner, 4);

    canvas.drawCircle(center, radius - 2, shadowPaint);
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Color(0xFFFF6F00).withOpacity(0.8);  // Dark orange
      case 'transport':
        return Color(0xFF1E88E5).withOpacity(0.8);  // Dark blue
      case 'entertainment':
        return Color(0xFF8E24AA).withOpacity(0.8);  // Dark purple
      case 'bills':
        return Color(0xFF43A047).withOpacity(0.8);  // Dark green
      case 'other':
        return Color(0xFF546E7A).withOpacity(0.8);  // Dark blue-grey
      default:
        return Color(0xFFE53935).withOpacity(0.8);  // Dark red (fallback color)
    }
  }


  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
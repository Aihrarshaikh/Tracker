import 'package:flutter/material.dart';
import 'package:msaassignment/core/theme/appTheme.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/datasources/expenseLocalDataSource.dart';
import 'domain/repositories/expenseRepositoryImp.dart';
import 'presentation/providers/expenseProvider.dart';
import 'presentation/screens/expenseListScreen.dart';
import 'services/notificationService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final expenseDataSource = ExpenseLocalDataSource();
  await expenseDataSource.initHive();

  final expenseRepository = ExpenseRepositoryImpl(expenseDataSource);

  final notificationService = NotificationService();
  await notificationService.initNotifications();

  runApp(MyApp(expenseRepository: expenseRepository, notificationService: notificationService));
}

class MyApp extends StatelessWidget {
  final ExpenseRepositoryImpl expenseRepository;
  final NotificationService notificationService;

  const MyApp({Key? key, required this.expenseRepository, required this.notificationService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ExpenseProvider(expenseRepository)..fetchExpenses(),
        ),
      ],
      child: MaterialApp(
        title: 'Personal Expense Tracker',
        theme: AppTheme.darkTheme,
        home: ExpenseListScreen(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return _createRoute(ExpenseListScreen());
          // Add other routes here
            default:
              return null;
          }
        },
      ),
    );
  }

  PageRoute _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
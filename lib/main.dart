import 'package:expenses_tracking_app/data/models/reminder_model.dart';
import 'package:expenses_tracking_app/data/repositories/user_repo.dart';
import 'package:expenses_tracking_app/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'data/models/transaction_model.dart';
import 'data/repositories/transaction_repo.dart';
import 'logic/cubit/finance_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(TransactionTypeAdapter());
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(ReminderAdapter());

  final transactionRepository = TransactionRepository();
  final UserRepository userRepo = UserRepository();

  await Hive.openBox<Transaction>('transactions');
  await Hive.openBox<Reminder>('reminders');

  runApp(
    BlocProvider(
      create: (context) => FinanceCubit(transactionRepository, userRepo)
        ..loadTransactions()
        ..loadUsername()
        ..loadReminders(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: const SplashScreen(),
    );
  }
}

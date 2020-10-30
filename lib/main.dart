import 'package:flutter/material.dart';
import 'package:my_expenses/widgets/chart.dart';
import 'package:my_expenses/widgets/new_transaction.dart';
import 'package:my_expenses/widgets/transaction_list.dart';

import 'models/transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Expenses',
      home: MyHomePage(),
      theme: ThemeData(
        accentColor: Colors.pinkAccent,
        primarySwatch: Colors.teal,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
              ),
              button: TextStyle(color: Colors.white),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(_addNewTransaction);
        });
  }

  final List<Transaction> _userTransations = [
    Transaction(
        id: 0.toString(), title: 'Bananas', amount: 10, time: DateTime.now()),
    Transaction(
        id: 1.toString(),
        title: 'Oranges',
        amount: 12,
        time: DateTime.now().subtract(new Duration(minutes: 10))),
    Transaction(
        id: 2.toString(),
        title: 'Apples',
        amount: 10,
        time: DateTime.now().subtract(new Duration(days: 2))),
    Transaction(
        id: 3.toString(),
        title: 'Kiwi',
        amount: 12,
        time: DateTime.now().subtract(new Duration(minutes: 10))),
  ];

  void _addNewTransaction(String txTitle, double txAmount, DateTime txDate) {
    final newTx = new Transaction(
        id: DateTime.now().toString(),
        amount: txAmount,
        title: txTitle,
        time: txDate);

    setState(() {
      _userTransations.add(newTx);
    });
  }

  List<Transaction> get _recentTransactions {
    return _userTransations
        .where((element) =>
            element.time.isAfter(DateTime.now().subtract(Duration(days: 7))))
        .toList();
    //return _userTransations;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter App'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _startAddNewTransaction(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
              child: new Chart(_recentTransactions),
            ),
            TransactionList(_userTransations),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _startAddNewTransaction(context);
        },
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses/widgets/chart_bar.dart';

import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      double totalSum = 0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].time.day == weekDay.day &&
            recentTransactions[i].time.month == weekDay.month &&
            recentTransactions[i].time.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
        // print(DateFormat.E().format(weekDay));
        // print(totalSum);
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 2),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  double get totalWeekSpendings {
    return groupedTransactionValues.fold(
        0.0, (sum, element) => sum + element['amount']);
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTransactionValues);
    return Card(
      elevation: 10,
      margin: EdgeInsets.all(5),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: groupedTransactionValues.map((data) {
            //return Text('${data['day']} : ${data['amount']}');
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  data['day'],
                  data['amount'],
                  totalWeekSpendings == 0
                      ? 0
                      : (data['amount'] as double) / totalWeekSpendings),
            );
            //return Text('dsa');
          }).toList(),
        ),
      ),
    );
  }
}

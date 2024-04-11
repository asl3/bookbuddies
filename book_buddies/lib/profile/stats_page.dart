import 'package:flutter/material.dart';
import 'package:book_buddies/models/user.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context, listen: true);

    Map<String, double> dataMap = {};
    for (var book in user.books) {
      dataMap[book.genre] = (dataMap[book.genre] ?? 0) + 1;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stats'),
      ),
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Text(
              'Genres in Your Collection',
              style: TextStyle(fontSize: 24),
            )),
            PieChart(
              dataMap: dataMap,
              chartValuesOptions: ChartValuesOptions(
                decimalPlaces: 0,
              ),
            )
          ],
        ),
      )),
    );
  }
}

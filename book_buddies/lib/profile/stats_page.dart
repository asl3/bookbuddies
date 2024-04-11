import 'package:flutter/material.dart';
import 'package:book_buddies/models/user.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  Map<String, double> dataMap = {};
  Map<String, Color> genreColors = {};
  List<PieChartSectionData> genreData = [];
  List<Map<String, int>> booksPerMonth = [];
  List<BarChartGroupData> monthData = [];

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context, listen: true);

    getGenreData(user);
    getMonthData(user);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Stats'),
        ),
        body: SafeArea(
            child: AspectRatio(
                aspectRatio: 1,
                // child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Genres in Your Collection',
                        style: TextStyle(fontSize: 24),
                      ),
                      Expanded(
                          child: AspectRatio(
                              aspectRatio: 1,
                              child: PieChart(
                                PieChartData(
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 0,
                                  sections: genreData,
                                ),
                              ))),
                      Text(
                        'Books Finished Last Year',
                        style: TextStyle(fontSize: 24),
                      ),
                      Expanded(
                          child: AspectRatio(
                        aspectRatio: 1,
                        child: BarChart(
                          BarChartData(barGroups: monthData),
                        ),
                      ))
                    ]))));
  }

  void getGenreData(User user) {
    dataMap = {};
    for (var book in user.books) {
      dataMap[book.genre] = (dataMap[book.genre] ?? 0) + 1;
    }

    genreColors = {};
    for (var genre in dataMap.keys) {
      genreColors[genre] =
          Colors.primaries[dataMap.keys.toList().indexOf(genre)];
    }

    genreData = [];
    dataMap.forEach((key, value) {
      genreData.add(generateSectionData(value, genreColors[key]!));
    });
  }

  void getMonthData(User user) {
    booksPerMonth = [];
    for (int i = 0; i < 12; i++) {
      booksPerMonth.add({});
    }
    DateTime now = DateTime.now();
    int currentMonth = now.year * 12 + now.month;
    for (var book in user.books) {
      if (book.finishedAt != null) {
        DateTime finishedAt = book.finishedAt!;
        int finishedMonth = finishedAt.year * 12 + finishedAt.month;
        if (currentMonth - finishedMonth < 12) {
          var map = booksPerMonth[12 - (currentMonth - finishedMonth) - 1];
          map[book.genre] = (map[book.genre] ?? 0) + 1;
        }
      }
    }

    monthData = [];
    for (int i = 0; i < 12; i++) {
      monthData.add(generateGroupData(i, booksPerMonth[i]));
    }
  }

  PieChartSectionData generateSectionData(double value, Color color) {
    return PieChartSectionData(
      value: value,
      color: color,
      title: '${value.toInt()}',
      radius: 80,
      titleStyle: TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  BarChartGroupData generateGroupData(int x, Map<String, int> data) {
    double y = 0;

    List<BarChartRodStackItem> stack = [];
    data.forEach((key, value) {
      stack.add(BarChartRodStackItem(y, y + value, genreColors[key]!));
      y += value;
    });

    return BarChartGroupData(
        x: x, barRods: [BarChartRodData(toY: y, rodStackItems: stack)]);
  }
}

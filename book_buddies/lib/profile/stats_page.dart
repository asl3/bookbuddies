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
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context, listen: true);

    Map<String, double> dataMap = {};
    for (var book in user.books) {
      dataMap[book.genre] = (dataMap[book.genre] ?? 0) + 1;
    }

    Map<String, Color> genreColors = {};
    for (var genre in dataMap.keys) {
      genreColors[genre] =
          Colors.primaries[dataMap.keys.toList().indexOf(genre)];
    }

    List<PieChartSectionData> genreData = [];
    dataMap.forEach((key, value) {
      genreData.add(generateSectionData(value, genreColors[key]!));
    });

    List<int> booksPerMonth = List.filled(12, 0);
    DateTime now = DateTime.now();
    int currentMonth = now.year * 12 + now.month;
    for (var book in user.books) {
      if (book.finishedAt != null) {
        DateTime finishedAt = book.finishedAt!;
        int finishedMonth = finishedAt.year * 12 + finishedAt.month;
        if (currentMonth - finishedMonth < 12) {
          booksPerMonth[currentMonth - finishedMonth]++;
        }
      }
    }

    print(booksPerMonth);

    List<BarChartGroupData> monthData = [];
    for (int i = 0; i < 12; i++) {
      monthData.add(generateGroupData(i, booksPerMonth[i]));
    }

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

  BarChartGroupData generateGroupData(int x, int y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y.toDouble(),
          color: Colors.blue,
          width: 22,
        ),
      ],
    );
  }
}

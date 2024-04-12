import 'package:flutter/material.dart';
import 'package:book_buddies/models/user.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'indicator.dart';

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

    Widget pie = titledChart(
        "Genres in Collection",
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Expanded(child: pieChart()), makeIndicators()],
        ));
    Widget bar = titledChart("Books Finished by Month", barChart());

    return Scaffold(
        appBar: AppBar(
          title: const Text('Stats'),
        ),
        body: OrientationBuilder(
            builder: (context, orientation) => SafeArea(
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Flex(
                        direction: orientation == Orientation.portrait
                            ? Axis.vertical
                            : Axis.horizontal,
                        children: [
                          Expanded(child: pie),
                          Expanded(child: bar)
                        ])))));
  }

  Widget titledChart(String title, Widget chart) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        Expanded(child: chart),
      ],
    );
  }

  Widget pieChart() {
    return PieChart(
      PieChartData(
        borderData: FlBorderData(
          show: false,
        ),
        sectionsSpace: 0,
        centerSpaceRadius: 0,
        sections: genreData,
      ),
    );
  }

  Widget barChart() {
    return BarChart(
      BarChartData(
        barGroups: monthData,
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getMonths,
              reservedSize: 38,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getHeights,
              reservedSize: 38,
            ),
          ),
        ),
        gridData: const FlGridData(show: true, drawVerticalLine: false),
      ),
    );
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
      titleStyle: const TextStyle(
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

  Widget getMonths(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    const String months = 'JFMAMJJASOND';
    final String month = months.substring(value.toInt(), value.toInt() + 1);

    Widget text = Text(month, style: style);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  Widget getHeights(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    int v = value.toInt();

    final String height = v < value ? '' : v.toString();
    Widget text = Text(height, style: style);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  Widget makeIndicators() {
    List<Widget> indicators = [];
    genreColors.forEach((key, value) {
      indicators.add(Indicator(
        color: value,
        text: key,
        isSquare: true,
      ));
      indicators.add(const SizedBox(
        height: 4,
      ));
    });

    return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: indicators);
  }
}

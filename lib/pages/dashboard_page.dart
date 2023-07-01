import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<ChartData> data = [
    ChartData(titleX: "Pedro", valueY: 30),
    ChartData(titleX: "Juan", valueY: 50),
    ChartData(titleX: "Fidel", valueY: 70),
    ChartData(titleX: "Ramón", valueY: 55),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(
          "Dashboard",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(minimum: 0, maximum: 100, interval: 20),
              series: [
                ColumnSeries(
                  dataSource: data,
                  xValueMapper: (ChartData temp, index) => temp.titleX,
                  yValueMapper: (ChartData temp, index) => temp.valueY,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  double valueY;
  String titleX;
  ChartData({required this.titleX, required this.valueY});
}

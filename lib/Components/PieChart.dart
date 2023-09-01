import 'package:flutter/material.dart';
import 'package:wink30/utils/MyColors.dart';
import 'package:pie_chart/pie_chart.dart';

class MyChart extends StatelessWidget {
  final String amount;
  final double income;
  final double getIncome;

  MyChart({
    super.key,
    required this.amount,
    required this.income,
    required this.getIncome,
  });

  Map<String, double> getDataMap() {
    double bonus = income - getIncome;
    return {
      "Received": getIncome,
      "Bonus": bonus,
    };
  }

  // Colors for each segment
  // of the pie chart
  List<Color> colorList = [
    const Color(0xffD95AF3),
    const Color(0xff3EE094),
  ];
  final gradientList = <List<Color>>[
    [
      const Color.fromRGBO(252, 194, 1, 1),
      const Color.fromRGBO(252, 194, 1, 1),
    ],
    [
      Color.fromARGB(120, 255, 204, 35),
      Color.fromARGB(120, 255, 204, 35),
    ],
  ];

  final TextStyle aboutPackage = const TextStyle(
    color: MyColors.primaryColor,
    fontWeight: FontWeight.w400,
  );
  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = getDataMap();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: MyColors.containerColor,
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Package",
                  style: TextStyle(
                    color: MyColors.primaryColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  "\$ $amount",
                  style: const TextStyle(
                    color: MyColors.primaryColor,
                    fontWeight: FontWeight.w800,
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            PieChart(
              chartLegendSpacing: 35,
              degreeOptions: const DegreeOptions(initialAngle: 270),
              chartType: ChartType.ring,
              centerTextStyle: const TextStyle(color: Colors.black),
              dataMap: dataMap,
              colorList: colorList,
              emptyColor: Colors.grey,
              chartRadius: MediaQuery.of(context).size.width / 4,
              ringStrokeWidth: 14,
              animationDuration: const Duration(seconds: 3),
              chartValuesOptions: const ChartValuesOptions(
                  showChartValues: true,
                  showChartValuesOutside: true,
                  showChartValuesInPercentage: true,
                  chartValueStyle:
                      TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  showChartValueBackground: true),
              legendOptions: const LegendOptions(
                  showLegends: true,
                  legendShape: BoxShape.circle,
                  legendTextStyle: TextStyle(fontSize: 15, color: Colors.white),
                  legendPosition: LegendPosition.bottom,
                  showLegendsInRow: true),
              gradientList: gradientList,
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Capping", style: aboutPackage),
                Text("\$ $income", style: aboutPackage)
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Received Income", style: aboutPackage),
                Text("\$ $getIncome", style: aboutPackage)
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Pending Income", style: aboutPackage),
                Text("\$ ${income - getIncome}", style: aboutPackage)
              ],
            ),
          ],
        ),
      ),
    );
  }
}

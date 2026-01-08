
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/simulation_data.dart';

class CostChart extends StatelessWidget {
  final SimulationResult result;

  const CostChart({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Data for chart: Variable Cost vs Fixed Cost vs Profit
    // Or just Costs breakdown?
    // TOR says "Pie Chart (library: fl_chart) untuk proporsi biaya."
    // So usually: Variable vs Fixed. Or breakdown of specific costs if available.
    // Since we only passed aggregate costs to Result, we can chart Total Var vs Total Fixed.
    // Optionally we could chart Revenue = Cost + Profit.
    
    // Let's Chart: Expenses Breakdown (Variable vs Fixed)
    // and maybe a second chart for Revenue distribution?
    // Let's stick to Expenses Breakdown (Fixed vs Variable).
    
    final double totalCost = result.totalVariableCost + result.totalFixedCost;
    
    // Prevent NaN/Infinity if totalCost is 0
    double fixedPct = 0;
    double varPct = 0;
    if (totalCost > 0) {
      fixedPct = (result.totalFixedCost / totalCost) * 100;
      varPct = (result.totalVariableCost / totalCost) * 100;
    } else {
        // If no cost, showing an empty chart or just returning placeholders
        // is better than crashing.
        return const Center(child: Text("Belum ada data biaya."));
    }

    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: [
          const SizedBox(height: 18),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(
                      color: Colors.orangeAccent,
                      value: result.totalFixedCost,
                      title: '${fixedPct.toStringAsFixed(1)}%',
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      color: Colors.blueAccent,
                      value: result.totalVariableCost,
                      title: '${varPct.toStringAsFixed(1)}%',
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 28),
          // Legend
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Indicator(
                color: Colors.orangeAccent,
                text: 'Fixed Cost\n(Tetap)',
                isSquare: true,
              ),
              SizedBox(height: 4),
              Indicator(
                color: Colors.blueAccent,
                text: 'Variable Cost\n(Variabel)',
                isSquare: true,
              ),
              SizedBox(height: 18),
            ],
          ),
          const SizedBox(width: 28),
        ],
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: textColor,
          ),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class HeatMapSection extends StatelessWidget {
  const HeatMapSection({super.key, required this.datasetsList, required this.statedate});
  final Map<DateTime, int> datasetsList;
  final DateTime statedate;

  
  

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: HeatMap(
        datasets:datasetsList ,
        startDate:statedate,
        endDate: DateTime.now().add(Duration(days: 40)),
        colorsets: {
          25: Colors.green.shade200,
          50: Colors.green.shade300,
          75: Colors.green.shade400,
          80: Colors.green.shade500,
          100: Colors.green.shade600,
        },
        colorMode: ColorMode.color,
        defaultColor: Colors.grey.shade400,
        showText: true,
        scrollable: true,
        textColor: Colors.white,
        size: 40,
      ),
    );
  }
}

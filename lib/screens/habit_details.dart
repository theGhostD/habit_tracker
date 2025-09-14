import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/models/habit_model.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:habit_tracker/utils/firebase_utils.dart';

class HabitDetails extends ConsumerStatefulWidget {
  const HabitDetails({super.key, required this.habit});

  final HabitModel habit;

  @override
  ConsumerState<HabitDetails> createState() => _HabitDetailsState();
}

class _HabitDetailsState extends ConsumerState<HabitDetails> {
  @override
  Widget build(BuildContext context) {
    bool iscompleted = widget.habit.iscompleted;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit.habitName),
        backgroundColor: Colors.red,
      ),
      backgroundColor: const Color.fromARGB(240, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.flag_circle, color: Colors.orange),
                        SizedBox(width: 4),
                        Text(
                          '365 Habit View',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    HeatMap(
                      datasets: {
                        DateTime(2025, 08, 31): 5,
                        DateTime(2025, 09, 1): 2,
                        DateTime(2025, 09, 2): 1,
                        DateTime(2025, 09, 3): 2,
                        DateTime(2025, 09, 4): 3,
                        DateTime(2025, 09, 5): 3,
                        DateTime(2025, 09, 6): 5,
                        DateTime(2025, 09, 7): 1,
                        DateTime(2025, 09, 10): 5,
                        DateTime(2025, 09, 15): 3,
                      },
                      startDate: DateTime.now(),
                      endDate: DateTime.now().add(Duration(days: 365)),
                      colorsets: {
                        1: Colors.red.shade100,
                        2: Colors.red.shade200,
                        3: Colors.red.shade300,
                        4: Colors.red.shade400,
                        5: Colors.red.shade500,
                      },
                      colorMode: ColorMode.color,
                      defaultColor: const Color.fromARGB(224, 230, 230, 230),

                      scrollable: true,
                      textColor: Colors.grey.shade300,
                      size: 16,
                      showColorTip: false,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.stacked_bar_chart, color: Colors.blueAccent),
                        SizedBox(width: 4),
                        Text(
                          'Habit Progress',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),

                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Card(
                                color: Colors.white,
                                elevation: 0.5,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                            70,
                                            255,
                                            205,
                                            210,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Icon(
                                            Icons.calendar_month,
                                            color: Colors.red,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        'This Month',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                      SizedBox(height: 4),

                                      Text(
                                        '15',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(height: 4),

                                      Text(
                                        'days in August',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Card(
                                color: Colors.white,
                                elevation: 0.5,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                            107,
                                            187,
                                            222,
                                            251,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Icon(
                                            Icons.check_circle,
                                            color: const Color.fromARGB(
                                              255,
                                              18,
                                              108,
                                              243,
                                            ),
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        'Total Done',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                      SizedBox(height: 4),

                                      Text(
                                        '15',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(height: 4),

                                      Text(
                                        'days overall',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Card(
                                color: Colors.white,
                                elevation: 0.5,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                            32,
                                            255,
                                            153,
                                            0,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Icon(
                                            Icons.local_fire_department,
                                            color: Colors.orange,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        'Longest Streak',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                      SizedBox(height: 4),

                                      Text(
                                        '6',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(height: 4),

                                      Text(
                                        'days in a row',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Card(
                                color: Colors.white,
                                elevation: 0.5,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                            29,
                                            76,
                                            175,
                                            79,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Icon(
                                            Icons.bolt,
                                            color: Colors.lightGreen,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        'Current Streak',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                      SizedBox(height: 4),

                                      Text(
                                        '5',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(height: 4),

                                      Text(
                                        'days active',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  color: iscompleted ? Colors.grey : Colors.red,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextButton(
                  onPressed: () {
                    if (iscompleted) {
                      Navigator.pop(context);
                      return;
                    }
                    FirebaseUtils.updateDataset(
                      DateTime.now(),
                      widget.habit,
                      context,
                    );
                    Navigator.pop(context);
                  },
                  child: Text(
                    iscompleted ? 'Close' : 'Completed',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

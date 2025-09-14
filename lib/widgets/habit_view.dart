import 'package:flutter/material.dart';
import 'package:habit_tracker/models/habit_model.dart';
import 'package:habit_tracker/utils/firebase_utils.dart';
import 'package:habit_tracker/widgets/habit_tiles.dart';

class HabitView extends StatefulWidget {
  const HabitView({super.key, required this.habitList});
  final List<HabitModel> habitList;

  @override
  State<HabitView> createState() => _HabitViewState();
}

class _HabitViewState extends State<HabitView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: widget.habitList.isEmpty
          ? Center(child: Text('No Habit!!'))
          : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: widget.habitList.length,
              itemBuilder: (context, index) => Dismissible(
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20.0),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) async {
                  final habitToRemove = widget.habitList[index];

                  await FirebaseUtils.removeHabit(habitToRemove, context);

                  // Check if the widget is still mounted before showing SnackBar
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${habitToRemove.habitName} Removed Sucessfully',
                        ),
                        duration: Duration(seconds: 3),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () async {
                            await FirebaseUtils.addhabit(
                              habitToRemove,
                              context,
                            );
                          },
                        ),
                      ),
                    );
                  }
                },
                key: ValueKey(widget.habitList[index]),
                child: HabitTiles(currentHabit: widget.habitList[index]),
              ),
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:habit_tracker/models/habit_model.dart';
// import 'package:habit_tracker/screens/habit_details.dart';
import 'package:habit_tracker/utils/firebase_utils.dart';

class HabitTiles extends StatelessWidget {
  const HabitTiles({super.key, required this.currentHabit});

  final HabitModel currentHabit;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),

      child: Card(
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ListTile(
          onTap: () {
          
            if (currentHabit.iscompleted) {
              return;
            }
            FirebaseUtils.updateDataset(DateTime.now(), currentHabit, context);
            return;
          },
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          contentPadding: EdgeInsets.only(left: 12),
          leading: Checkbox(
            checkColor: Colors.white,
            activeColor: Colors.red,
            value: currentHabit.iscompleted,
            onChanged: (value) {},
          ),

          title: Text(
            currentHabit.habitName,
            style: TextStyle(fontWeight: FontWeight.w500,),
          ),
          subtitle: Text(
            currentHabit.habitDesp,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
          ),
          trailing: SizedBox(
            width: 100,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          currentHabit.streakDays.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        Icon(
                          Icons.local_fire_department,
                          color: Colors.red,
                          size: 18,
                        ),
                      ],
                    ),
                    Text(
                      'DAYS',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),

                Icon(
                  Icons.chevron_right_outlined,
                  size: 28,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

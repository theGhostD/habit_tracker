import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/models/habit_model.dart';
import 'package:intl/intl.dart';

void displaySnackar(
  String message,
  BuildContext context, {
  bool? isremove,
  HabitModel? currentHabit,
}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(seconds: 1),
      action: isremove != null && isremove
          ? SnackBarAction(
              label: 'Undo',
              onPressed: () async {
                await FirebaseUtils.addhabit(currentHabit!, context);
              },
            )
          : null,
    ),
  );
}

final DateFormat formatter = DateFormat('yyyy-MM-dd');

num currentHabitCount(int totalHabitLength) {
  return 100 / totalHabitLength;
}

num trackCurrentCount(double prevCount, List<dynamic> habitList) {
  bool iscountvalid = (100 / prevCount) == habitList.length;
  if (iscountvalid) {
    return prevCount + currentHabitCount(habitList.length);
  }
  // i need to check number of completed task for that particular day
  final habitCompleted = habitList.where(
    (habit) => habit['iscompleted'] == true,
  );

  final newHabitCount =
      habitCompleted.length * currentHabitCount(habitList.length) +
      currentHabitCount(habitList.length);
  return newHabitCount;
}

class FirebaseUtils {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // add new habit
  static Future<void> addhabit(HabitModel habit, BuildContext context) async {
    try {
      final User currentUser = FirebaseAuth.instance.currentUser!;

      await _firestore.collection('users').doc(currentUser.uid).update({
        'habit_list': FieldValue.arrayUnion([habit.toMap()]),
      });
      if (context.mounted) {
        displaySnackar('Sucessfully Added ${habit.habitName}', context);
      }
    } catch (e) {
      if (context.mounted) {
        displaySnackar(e.toString(), context);
      }
    }
  }

  // remove Habit
  static Future<void> removeHabit(
    HabitModel habit,
    BuildContext context,
  ) async {
    final User currentUser = FirebaseAuth.instance.currentUser!;

    try {
      await _firestore.collection('users').doc(currentUser.uid).update({
        'habit_list': FieldValue.arrayRemove([habit.toMap()]),
      });
      if (context.mounted) {
        displaySnackar(
          'Sucessfully Added ${habit.habitName}',
          context,
          isremove: true,
          currentHabit: habit,
        );
      }
    } catch (e) {
      if (context.mounted) {
        displaySnackar(e.toString(), context);
      }
    }
  }

  // put dataset or update it when user mark habit as completed
  static Future<void> updateDataset(
    DateTime currentDate,
    HabitModel habit,
    BuildContext context,
  ) async {
    final User currentUser = FirebaseAuth.instance.currentUser!;

    final currentUserData = await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .get();
    final List data = currentUserData.data()!['user_data'];
    final List habitList = currentUserData.data()!['habit_list'];

    // update the status
    final updatedHabitList = habitList.map((h) {
      if (h['id'] == habit.id) {
        return {
          ...h,
          'iscompleted': !h['iscompleted'],
          'lastCompletedDate': formatter.format(currentDate),
          'streakDays': h['streakDays'] + 1,
        };
      }
      return h;
    }).toList();

    try {
      await _firestore.collection('users').doc(currentUser.uid).update({
        'habit_list': updatedHabitList,
      });
      if (context.mounted) {
        displaySnackar('Sucessfully Updated ${habit.habitName}', context);
      }
    } catch (e) {
      if (context.mounted) {
        displaySnackar(e.toString(), context);
      }
    }

    // get current time and update it

    final currentTimeData = data
        .where(
          (userData) =>
              (userData['currentDate'] as Timestamp).toDate().toString().split(
                ' ',
              )[0] ==
              currentDate.toString().split(' ')[0],
        )
        .toList();

    if (currentTimeData.isEmpty) {
      final newUserData = [
        ...data,
        {
          'currentDate': currentDate,
          'count': currentHabitCount(habitList.length),
        },
      ];
      try {
        await _firestore.collection('users').doc(currentUser.uid).update({
          'user_data': newUserData,
        });
      } catch (e) {
        if (context.mounted) {
          displaySnackar(e.toString(), context);
        }
      }
      return;
    }

    final newCurrentUserData = data.map((dataValue) {
      if ((dataValue['currentDate'] as Timestamp).toDate().toString().split(
            ' ',
          )[0] ==
          (currentTimeData[0]['currentDate'] as Timestamp)
              .toDate()
              .toString()
              .split(' ')[0]) {
        final newModifyData = {
          ...dataValue,
          'count': trackCurrentCount(dataValue['count'], habitList),
        };
        return newModifyData;
      }
      return dataValue;
    });
    try {
      await _firestore.collection('users').doc(currentUser.uid).update({
        'user_data': newCurrentUserData,
      });
    } catch (e) {
      print(e);
      if (context.mounted) {
        displaySnackar(e.toString(), context);
      }
    }
    return;
  }
}

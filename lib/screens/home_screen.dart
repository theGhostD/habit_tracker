import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/models/habit_model.dart';
import 'package:habit_tracker/screens/new_habit.dart';
import 'package:habit_tracker/widgets/habit_view.dart';
import 'package:habit_tracker/widgets/heat_map.dart';
import 'package:intl/intl.dart';

final db = FirebaseFirestore.instance;
final DateFormat formatter = DateFormat('yyyy-MM-dd');

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> resetHabitsForNewDay(List<HabitModel> habitList, String userId) async {
    if (habitList.isEmpty) {
      return;
    }

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    final updatedHabitList = habitList.map((h) {
      var iscompleted = formatter.format(DateTime.now()) == h.lastCompletedDate
          ? h.iscompleted
          : false;
      return h.copyWith(iscompleted: iscompleted);
    }).toList();

    try {
      await _firestore.collection('users').doc(userId).update({
        'habit_list': updatedHabitList.map((habit) => habit.toMap()).toList(),
      });
    } catch (e) {
      print('Firestore error: $e');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(228, 255, 255, 255),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final stream = db.collection('users').doc(currentUser.uid).snapshots();

    return Scaffold(
      backgroundColor: const Color.fromARGB(228, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.red,
        surfaceTintColor: Colors.white,
        title: Text('Habit Tracker',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,),),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewHabit()),
              );
            },
            icon: Icon(Icons.add,color: Colors.white,),
          ),

          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout,color: Colors.white,),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: stream,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.hasError) {
            return Center(child: Text('Error: ${asyncSnapshot.error}'));
          }

          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.grey[200],
                ),
              ),
            );
          }
          if (!asyncSnapshot.hasData || !asyncSnapshot.data!.exists) {
            return Center(child: Text('No data found'));
          }

          var data = asyncSnapshot.data!.get('habit_list') as List;
          final DateTime startDate =
              (asyncSnapshot.data!.get('Start_date') as Timestamp).toDate();

          final List userDataSet = asyncSnapshot.data!.get('user_data');
          final Map<DateTime, int> newDataSet = userDataSet.isEmpty
              ? {}
              : Map.fromEntries(
                  userDataSet
                      .map(
                        (innerMap) => MapEntry(
                          innerMap['currentDate'] != null
                              ? DateTime(
                                  (innerMap['currentDate'] as Timestamp)
                                      .toDate()
                                      .year,
                                  (innerMap['currentDate'] as Timestamp)
                                      .toDate()
                                      .month,
                                  (innerMap['currentDate'] as Timestamp)
                                      .toDate()
                                      .day,
                                )
                              : DateTime.now(),
                          (innerMap['count'] as num).toInt(),
                        ),
                      )
                      .toList(),
                );

          List<HabitModel> habitList = data
              .map(
                (dataValue) => HabitModel(
                  habitName: dataValue['habitName'],
                  streakDays: dataValue['streakDays'],
                  habitDesp: dataValue['habitDesp'],
                  emoji: dataValue['emoji'],
                  iscompleted: dataValue['iscompleted'],
                  id: dataValue['id'],
                  lastCompletedDate: dataValue['lastCompletedDate'],
                ),
              )
              .toList();

          // Reset habits for new day when data is available
          WidgetsBinding.instance.addPostFrameCallback((_) {
            resetHabitsForNewDay(habitList, currentUser.uid);
          });

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              HeatMapSection(datasetsList: newDataSet, statedate: startDate),
              HabitView(habitList: habitList),
            ],
          );
        },
      ),
    );
  }
}

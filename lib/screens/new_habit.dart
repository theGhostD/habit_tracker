import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/models/habit_model.dart';
import 'package:habit_tracker/utils/firebase_utils.dart';
import 'package:habit_tracker/widgets/tab_section.dart';

class NewHabit extends ConsumerStatefulWidget {
  const NewHabit({super.key});

  @override
  ConsumerState<NewHabit> createState() => _NewHabitState();
}

class _NewHabitState extends ConsumerState<NewHabit> {
  List<HabitModel> habitList = [
    HabitModel(
      habitName: 'Morning Walk',
      streakDays: 0,
      habitDesp: 'walking 8:am every morning',
      emoji: '🚶‍♂️',
      iscompleted: false,
      id: '1',
    ),
    HabitModel(
      habitName: 'Daily Gratitude',
      streakDays: 0,
      habitDesp: 'first Thing in the morning',
      emoji: '🙏',
      iscompleted: false,
      id: '2',
    ),
    HabitModel(
      habitName: 'Jogging',
      streakDays: 0,
      habitDesp: 'Jog 5km every day',
      emoji: '\u{1F3C3}\u{200D}\u{2642}\u{FE0F}',
      iscompleted: false,
      id: '3',
    ),
    HabitModel(
      habitName: 'Push-Ups',
      streakDays: 0,
      habitDesp: '10-15 reps',
      emoji: '\u{1F4AA}',
      iscompleted: false,
      id: '4',
    ),
    HabitModel(
      habitName: 'Cycling',
      streakDays: 0,
      habitDesp: '5-10km per day',
      emoji: '🚵',
      iscompleted: false,
      id: '5',
    ),

    HabitModel(
      habitName: 'Reading',
      streakDays: 0,
      habitDesp: '5-10km per day',
      emoji: '📖',
      iscompleted: false,
      id: '6',
    ),
    HabitModel(
      habitName: 'Swimming',
      streakDays: 0,
      habitDesp: '5-10km per day',
      emoji: '\u{1F3CA}\u{200D}\u{2642}\u{FE0F}',
      iscompleted: false,
      id: '7',
    ),

    HabitModel(
      habitName: 'Cycling',
      streakDays: 0,
      habitDesp: '5-10km per day',
      emoji: '🚵',
      iscompleted: false,
      id: '8',
    ),

    HabitModel(
      habitName: 'Reading',
      streakDays: 0,
      habitDesp: '5-10km per day',
      emoji: '📖',
      iscompleted: false,
      id: '9',
    ),
    HabitModel(
      habitName: 'Swimming',
      streakDays: 0,
      habitDesp: '5-10km per day',
      emoji: '\u{1F3CA}\u{200D}\u{2642}\u{FE0F}',
      iscompleted: false,
      id: '10',
    ),
  ];
  void openCustomBottomTab() {
    showModalBottomSheet(
      showDragHandle: true,
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.2,
            maxChildSize: 0.9,
            expand: false,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: BottomModal(),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close, color: Colors.blue),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: GestureDetector(
        onTap: openCustomBottomTab,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, color: Colors.white, size: 20),
                SizedBox(width: 4),
                Text(
                  'Custom Habit',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'New Habit ',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 2,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Icon(Icons.search, size: 22),
                  ),
                  prefixIconColor: Colors.grey,
                  prefixIconConstraints: BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  hintText: 'Search in All',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  filled: true,
                  fillColor: const Color.fromARGB(15, 0, 0, 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: TabSection(),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ListView.builder(
                  itemCount: habitList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(15, 0, 0, 0),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
                        onTap: () async {
                          await FirebaseUtils.addhabit(
                            habitList[index],
                            context,
                          );
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        leading: Text(
                          habitList[index].emoji!,
                          style: TextStyle(fontSize: 18),
                        ),
                        title: Text(
                          habitList[index].habitName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomModal extends ConsumerWidget {
  const BottomModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitNameController = TextEditingController();
    final habitDespController = TextEditingController();

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Create New Habit ',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            SizedBox(height: 20),
            TextField(
              controller: habitNameController,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: 'Enter Habit Name',
                hintStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 16),

            TextField(
              controller: habitDespController,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: 'Enter Description ',
                hintStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                SizedBox(width: 16),

                ElevatedButton(
                  onPressed: () async {
                    if (habitNameController.text.isNotEmpty &&
                        habitDespController.text.isNotEmpty) {
                      var habitModel = HabitModel(
                        habitName: habitNameController.text,
                        streakDays: 0,
                        habitDesp: habitDespController.text,
                        emoji: '',
                        iscompleted: false,
                        // id:'22'
                      );

                      await FirebaseUtils.addhabit(habitModel, context);
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text(
                    'Save habit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

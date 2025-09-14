import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

enum HabitAction { toggleIsCompleted, newHabit, undoRemoval, dismissed }

final DateFormat formatter = DateFormat('yyyy-MM-dd');

class HabitModel {
  HabitModel({
    required this.habitName,
    required this.streakDays,
    required this.habitDesp,
    this.emoji,
    this.iscompleted = false,
    String? id,
    String? lastCompletedDate,
  }) : id = id ?? uuid.v4(),
       lastCompletedDate =
           lastCompletedDate ?? formatter.format(DateTime.now());

  final String id;

  final String habitName;
  final String habitDesp;
  final bool iscompleted;

  final num streakDays;
  final String? emoji;
  final String lastCompletedDate;

  HabitModel copyWith({
    String? id,
    String? habitName,
    String? habitDesp,
    bool? iscompleted,
    num? streakDays,
    String? emoji,
  }) {
    return HabitModel(
      habitName: habitName ?? this.habitName,
      habitDesp: habitDesp ?? this.habitDesp,
      iscompleted: iscompleted ?? this.iscompleted,
      streakDays: streakDays ?? this.streakDays,
      emoji: emoji ?? this.emoji,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'habitName': habitName,
      'streakDays': streakDays,
      'habitDesp': habitDesp,
      'emoji': emoji,
      'iscompleted': iscompleted,
      'id': id,
      'lastCompletedDate': lastCompletedDate,
    };
  }
}

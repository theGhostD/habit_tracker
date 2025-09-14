import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/models/habit_model.dart';

class HabitNotifier extends StateNotifier<List<HabitModel>> {
  HabitNotifier() : super([]);

  bool habitListAction(
    HabitModel newHabit,
    HabitAction actionType, {
    int? currentHabitIndex,
  }) {
    final doesHabitExist = state.any(
      (habit) => habit.habitName == newHabit.habitName,
    );
    if (doesHabitExist && actionType == HabitAction.newHabit) {
      return true;
    }
    if (doesHabitExist && actionType == HabitAction.dismissed) {
      state = state.where((habit) => habit.id != newHabit.id).toList();
      return true;
    }

    if (actionType == HabitAction.undoRemoval && currentHabitIndex != null) {
      var newList = [...state];
      newList.insert(currentHabitIndex, newHabit);
      state = newList;

      return true;
    }

    if (actionType == HabitAction.toggleIsCompleted && doesHabitExist) {
      var newList = state.map((habit) {
        if (habit.id == newHabit.id) {
          return habit.copyWith(iscompleted: !habit.iscompleted);
        }
        return habit;
      }).toList();
      state = newList;

      var isCompleted = state.where((xx) => xx.id == newHabit.id).toList();

      return isCompleted[0].iscompleted;
    }

    state = [...state, newHabit];
    return false;
  }

  bool habitStatus(HabitModel currentHabit) {
    var isCompleted = state.where((xx) => xx.id == currentHabit.id).toList();

    return isCompleted[0].iscompleted;
  }
}

final habitProvider = StateNotifierProvider<HabitNotifier, List<HabitModel>>((
  ref,
) {
  return HabitNotifier();
});

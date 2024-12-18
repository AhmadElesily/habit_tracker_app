import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../core/themes/colors.dart';
import '../cubit/items_cubit_cubit.dart';

class CalenderTab extends StatefulWidget { // Changed to StatelessWidget
  const CalenderTab({super.key});

  @override
  State<CalenderTab> createState() => _CalenderTabState();
}

class _CalenderTabState extends State<CalenderTab> {
  DateTime _focusedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.transparent,
      ),
      height: MediaQuery.of(context).size.height * 0.12, // Optional, remove if using Expanded
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column( // Wrap in Column to use Expanded
          children: [
            Expanded( // Use Expanded to avoid overflow
              child: TableCalendar(
                headerVisible: false,
                calendarStyle: const CalendarStyle(
                  defaultTextStyle: TextStyle(color: Colors.white),
                  weekendTextStyle: TextStyle(color: AppColors.buttonColor),
                  todayDecoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.rectangle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    shape: BoxShape.rectangle,
                  ),
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: AppColors.whiteColor),
                  weekendStyle: TextStyle(color: AppColors.buttonColor),
                ),
                firstDay: DateTime.now().subtract(const Duration(days: 365)),
                lastDay: DateTime.now().add(const Duration(days: 365)),
                focusedDay: _focusedDate,
                currentDay: _focusedDate,
                calendarFormat: CalendarFormat.week,
                availableCalendarFormats: const {
                  CalendarFormat.week: 'Week',
                },
                onDaySelected: (selectedDate, focusedDate) {
                  context.read<ItemsCubit>().loadHabitsForToday(selectedDate);
                  setState(() {
                    _focusedDate = focusedDate;
                  });
                  // Update focused date if necessary
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

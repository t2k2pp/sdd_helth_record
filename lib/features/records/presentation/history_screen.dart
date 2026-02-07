import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sdd_health_record/features/records/models/health_record.dart';
import 'package:sdd_health_record/features/records/repository/health_record_repository.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

part 'history_screen.g.dart';

@riverpod
class HistoryController extends _$HistoryController {
  @override
  Stream<List<HealthRecord>> build(DateTime date) {
    return _fetchRecords(date);
  }

  Stream<List<HealthRecord>> _fetchRecords(DateTime date) async* {
    final repository = await ref.watch(healthRecordRepositoryProvider.future);
    yield* repository.watchRecordsByDate(date);
  }
}

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final recordsAsync = ref.watch(
      historyControllerProvider(_selectedDay ?? _focusedDay),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.tealAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.teal,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: recordsAsync.when(
              data: (records) {
                if (records.isEmpty) {
                  return const Center(
                    child: Text('No records for selected day.'),
                  );
                }
                return ListView.builder(
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final record = records[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        title: Text(DateFormat.Hm().format(record.date)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (record.weight != null)
                              Text('Weight: ${record.weight} kg'),
                            if (record.temperature != null)
                              Text('Temp: ${record.temperature} °C'),
                            if (record.steps != null)
                              Text('Steps: ${record.steps}'),
                            if (record.exerciseNote != null &&
                                record.exerciseNote!.isNotEmpty)
                              Text('Exercise: ${record.exerciseNote!}'),
                            if (record.diaryNote != null &&
                                record.diaryNote!.isNotEmpty)
                              Text('Diary: ${record.diaryNote!}'),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}

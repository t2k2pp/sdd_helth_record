import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sdd_health_record/features/records/models/health_record.dart';
import 'package:sdd_health_record/features/records/repository/health_record_repository.dart';
import 'package:sdd_health_record/features/steps/health_service.dart';
import 'package:intl/intl.dart';

part 'home_screen.g.dart';

@riverpod
class HomeController extends _$HomeController {
  @override
  Stream<List<HealthRecord>> build() {
    return _fetchRecords();
  }

  Stream<List<HealthRecord>> _fetchRecords() async* {
    final repository = await ref.watch(healthRecordRepositoryProvider.future);
    yield* repository.watchRecordsByDate(DateTime.now());
  }
}

@riverpod
Future<int?> dailySteps(DailyStepsRef ref) async {
  final service = ref.watch(healthServiceProvider);
  return await service.getDailySteps();
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsAsync = ref.watch(homeControllerProvider);
    final stepsAsync = ref.watch(dailyStepsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Record'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () => context.push('/history'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () async {
              final service = ref.read(healthServiceProvider);
              final granted = await service.requestPermissions();
              if (granted && context.mounted) {
                ref.invalidate(dailyStepsProvider);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Synced steps')));
              } else if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Permission denied or failed')),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: ListTile(
              leading: const Icon(Icons.directions_walk),
              title: const Text('Today\'s Steps (Phone)'),
              trailing: stepsAsync.when(
                data: (steps) => Text(
                  '${steps ?? 0}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                loading: () => const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                error: (_, __) => const Text('Error'),
              ),
            ),
          ),
          Expanded(
            child: recordsAsync.when(
              data: (records) {
                if (records.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('No records for today.'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.push('/add'),
                          child: const Text('Add Record'),
                        ),
                      ],
                    ),
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
                              Text('Recorded Steps: ${record.steps}'),
                            if (record.exerciseNote != null &&
                                record.exerciseNote!.isNotEmpty)
                              Text('Exercise: ${record.exerciseNote!}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // TODO: Edit record
                          },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

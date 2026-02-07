import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sdd_health_record/core/database/isar_provider.dart';
import 'package:sdd_health_record/features/records/models/health_record.dart';

part 'health_record_repository.g.dart';

@Riverpod(keepAlive: true)
Future<HealthRecordRepository> healthRecordRepository(
  HealthRecordRepositoryRef ref,
) async {
  final isar = await ref.watch(isarProvider.future);
  return HealthRecordRepository(isar);
}

class HealthRecordRepository {
  final Isar _isar;

  HealthRecordRepository(this._isar);

  Future<void> saveRecord(HealthRecord record) async {
    await _isar.writeTxn(() async {
      await _isar.healthRecords.put(record);
    });
  }

  Future<void> deleteRecord(Id id) async {
    await _isar.writeTxn(() async {
      await _isar.healthRecords.delete(id);
    });
  }

  Future<List<HealthRecord>> getRecordsByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return await _isar.healthRecords
        .filter()
        .dateGreaterThan(startOfDay, include: true)
        .and()
        .dateLessThan(endOfDay, include: false)
        .sortByDateDesc()
        .findAll();
  }

  Stream<List<HealthRecord>> watchRecordsByDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _isar.healthRecords
        .filter()
        .dateGreaterThan(startOfDay, include: true)
        .and()
        .dateLessThan(endOfDay, include: false)
        .sortByDateDesc()
        .watch(fireImmediately: true);
  }

  Future<List<HealthRecord>> getAllRecords() async {
    return await _isar.healthRecords.where().sortByDateDesc().findAll();
  }
}

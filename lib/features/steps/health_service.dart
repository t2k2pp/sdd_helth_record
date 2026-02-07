import 'package:health/health.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'health_service.g.dart';

@Riverpod(keepAlive: true)
HealthService healthService(HealthServiceRef ref) {
  return HealthService();
}

class HealthService {
  final Health _health = Health();

  Future<bool> requestPermissions() async {
    final types = [HealthDataType.STEPS];
    final permissions = [HealthDataAccess.READ];
    return await _health.requestAuthorization(types, permissions: permissions);
  }

  Future<int?> getDailySteps() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime.now();

    try {
      final steps = await _health.getTotalStepsInInterval(startOfDay, endOfDay);
      return steps;
    } catch (e) {
      return null;
    }
  }
}

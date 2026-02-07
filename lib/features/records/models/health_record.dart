import 'package:isar/isar.dart';

part 'health_record.g.dart';

@collection
class HealthRecord {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime date;

  double? weight;

  double? temperature;

  double? waistCircumference;

  int? steps;

  String? exerciseNote;

  String? diaryNote;

  late DateTime createdAt;
}

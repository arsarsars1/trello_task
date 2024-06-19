import 'package:hive/hive.dart';

part 'priority.g.dart';

@HiveType(typeId: 0)
enum Priority {
  @HiveField(0)
  High,
  @HiveField(1)
  Medium,
  @HiveField(2)
  Low
}

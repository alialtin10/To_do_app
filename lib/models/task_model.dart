import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
part 'task_model.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  final DateTime createdAt;
  @HiveField(3)
  bool isCompleted;
  @HiveField(4)
  DateTime? endTime;
  @HiveField(5)
  final Color? backgroundColor;
  @HiveField(6)
  final bool? isAllDay;

  Task(
      {required this.id,
      required this.name,
      required this.createdAt,
      required this.isCompleted,
      this.endTime,
      this.backgroundColor,
      this.isAllDay});

  factory Task.create({required String name, required DateTime createdAt}) {
    return Task(
        id: Uuid().v1(), name: name, createdAt: createdAt, isCompleted: false);
  }

  factory Task.createCalendarEvents(
      {required String eventName,
      required DateTime startTime,
      required DateTime endTime,
      required Color backgroundColor,
      required isAllDay}) {
    return Task(
        id: Uuid().v1(),
        name: eventName,
        createdAt: startTime,
        isCompleted: false,
        endTime: endTime,
        backgroundColor: backgroundColor,
        isAllDay: false);
  }
}

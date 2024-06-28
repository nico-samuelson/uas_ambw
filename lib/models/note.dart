import 'package:hive/hive.dart';
part "note.g.dart";

@HiveType(typeId: 1)
class Note extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  bool isPinned = false;

  @HiveField(4)
  DateTime? createdAt = DateTime.now();

  @HiveField(5)
  DateTime? updatedAt = DateTime.now();

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.isPinned,
    this.createdAt,
    this.updatedAt,
  });
}

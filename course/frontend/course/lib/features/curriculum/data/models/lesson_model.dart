import 'package:course/features/curriculum/domain/entities/lesson_entity.dart';

class LessonModel extends LessonEntity {
  const LessonModel({
    required super.id,
    super.levelId,
    required super.title,
    super.orderIndex,
    super.status,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as int? ?? 0,
      levelId: json['levelId'] as int?,
      title: json['title'] as String? ?? '',
      orderIndex: json['orderIndex'] as int?,
      status: json['status'] as String?,
    );
  }
}

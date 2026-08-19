import 'package:equatable/equatable.dart';

class LessonEntity extends Equatable {
  final int id;
  final int? levelId;
  final String title;
  final int? orderIndex;
  final String? status;

  const LessonEntity({
    required this.id,
    this.levelId,
    required this.title,
    this.orderIndex,
    this.status,
  });

  @override
  List<Object?> get props => [id, levelId, title, orderIndex, status];
}

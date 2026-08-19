import 'package:equatable/equatable.dart';

class LevelEntity extends Equatable {
  final int id;
  final String system;
  final String code;
  final String name;
  final String language;

  const LevelEntity({
    required this.id,
    required this.system,
    required this.code,
    required this.name,
    required this.language,
  });

  @override
  List<Object?> get props => [id, system, code, name, language];
}

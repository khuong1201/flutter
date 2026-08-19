import 'package:equatable/equatable.dart';

class ContributionEntity extends Equatable {
  final DateTime date;
  final int count;

  const ContributionEntity({
    required this.date,
    required this.count,
  });

  @override
  List<Object?> get props => [date, count];
}

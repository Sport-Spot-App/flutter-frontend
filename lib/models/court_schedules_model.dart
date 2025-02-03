class CourtSchedulesModel {
  final String day_of_week;
  final String? start_time;
  final String? end_time;
  final bool? blocked;

  CourtSchedulesModel({
    required this.day_of_week,
    this.start_time,
    this.end_time,
    this.blocked,
  });

  factory CourtSchedulesModel.fromMap(Map<String, dynamic> map) {
    return CourtSchedulesModel(
      day_of_week: map['day_of_week'],
      start_time: map['start_time'],
      end_time: map['end_time'],
      blocked: map['blocked'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'day_of_week': day_of_week,
      'start_time': start_time,
      'end_time': end_time,
      'blocked': blocked,
    };
  }
}

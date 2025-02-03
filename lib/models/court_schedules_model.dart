class CourtSchedulesModel {
  final String day_of_week;
  final String start_time;
  final String end_time;

  CourtSchedulesModel({
    required this.day_of_week,
    required this.start_time,
    required this.end_time,
  });

  factory CourtSchedulesModel.fromMap(Map<String, dynamic> map) {
    return CourtSchedulesModel(
      day_of_week: map['day_of_week'],
      start_time: map['start_time'],
      end_time: map['end_time'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'day_of_week': day_of_week,
      'start_time': start_time,
      'end_time': end_time,
    };
  }
}

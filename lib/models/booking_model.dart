class BookingModel {
  final int? id;
  final int? user_id;
  final int court_id;
  final DateTime start_time;
  final DateTime end_time;
  final bool? status;
  final DateTime? created_at;
  final DateTime? updated_at;
  BookingModel({
    this.id,
    this.user_id,
    required this.court_id,
    required this.start_time,
    required this.end_time,
    this.status,
    this.created_at,
    this.updated_at,
  });

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id'],
      user_id: map['user_id'],
      court_id: map['user_id'],
      start_time: DateTime.parse(map['start_time']),
      end_time: DateTime.parse(map['end_time']),
      status: map['status'],
      created_at: DateTime.parse(map['created_at']),
      updated_at: DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': user_id,
      'court_id': user_id,
      'start_time': start_time.toIso8601String(),
      'end_time': end_time.toIso8601String(),
      'status': status,
      'created_at': created_at?.toIso8601String(),
      'updated_at': updated_at?.toIso8601String(),
    };
  }
}

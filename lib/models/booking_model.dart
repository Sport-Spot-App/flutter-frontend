import 'package:intl/intl.dart';

class BookingModel {
  final int? id;
  final int? user_id;
  final int court_id;
  final DateTime start_datetime;
  final DateTime end_datetime;
  final bool? status;
  final DateTime? created_at;
  final DateTime? updated_at;

  BookingModel({
    this.id,
    this.user_id,
    required this.court_id,
    required this.start_datetime,
    required this.end_datetime,
    this.status,
    this.created_at,
    this.updated_at,
  });

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id'],
      user_id: map['user_id'],
      court_id: map['court_id'],
      start_datetime: DateTime.parse(map['start_datetime']),
      end_datetime: DateTime.parse(map['end_datetime']),
      status: map['status'] == 1,
      created_at: DateTime.parse(map['created_at']),
      updated_at: DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': user_id,
      'court_id': court_id,
      'start_datetime':
          DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(start_datetime),
      'end_datetime':
          DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(end_datetime),
      'status': status == true ? 1 : 0,
      'created_at': created_at?.toIso8601String(),
      'updated_at': updated_at?.toIso8601String(),
    };
  }
}

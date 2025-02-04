import 'dart:io';
import 'package:sport_spot/models/cep_model.dart';
import 'package:sport_spot/models/sport_model.dart';

class CourtModel {
  final int? id;
  final String name;
  final String description;
  final String zip_code;
  final String price_per_hour;
  final String street;
  final String number;
  final String? coordinate_x;
  final String? coordinate_y;
  final int? user_id;
  final DateTime? created_at;
  final DateTime? updated_at;
  final DateTime? deleted_at;
  final List<SportModel> sports;
  final List<File>? photos;
  final CepModel? cep;
  final String? initial_hour;
  final String? final_hour;
  final List<String>? blocked_days;

  CourtModel({
    this.id,
    required this.name,
    required this.description,
    required this.zip_code,
    required this.price_per_hour,
    required this.street,
    required this.number,
    this.coordinate_x,
    this.coordinate_y,
    this.user_id,
    this.created_at,
    this.updated_at,
    this.deleted_at,
    required this.sports,
    this.photos,
    this.cep,
    this.initial_hour,
    this.final_hour,
    this.blocked_days,
  });

  factory CourtModel.fromMap(Map<String, dynamic> map) {
    return CourtModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      zip_code: map['zip_code'],
      price_per_hour: map['price_per_hour'],
      street: map['street'],
      number: map['number'],
      coordinate_x: map['coordinate_x'],
      coordinate_y: map['coordinate_y'],
      user_id: map['user_id'],
      created_at: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updated_at: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
      deleted_at: map['deleted_at'] != null ? DateTime.parse(map['deleted_at']) : null,
      sports: List<SportModel>.from((map['sports'] as List<dynamic>).map((item) => SportModel.fromMap(item as Map<String, dynamic>))),
      photos: (map['photos'] as List<dynamic>?)
          ?.map((item) => File(item['path'] as String))
          .toList(),
      cep: map['cep'] != null ? CepModel.fromMap(map['cep'] as Map<String, dynamic>) : null,
      initial_hour: map['initialHour'],
      final_hour: map['finalHour'],
      blocked_days: (map['blockedDays'] as List<dynamic>?)?.map((item) => item as String).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'zip_code': zip_code,
      'price_per_hour': price_per_hour,
      'street': street,
      'number': number,
      'coordinate_x': coordinate_x,
      'coordinate_y': coordinate_y,
      'user_id': user_id,
      'created_at': created_at?.toIso8601String(),
      'updated_at': updated_at?.toIso8601String(),
      'deleted_at': deleted_at?.toIso8601String(),
      'sports': sports.map((sport) => sport.id).toList(),
      'photos': photos?.map((file) => {'path': file.path}).toList(),
      'cep': cep?.toMap(),
      'initialHour': initial_hour,
      'finalHour': final_hour,
      'blockedDays': blocked_days,
    };
  }
}

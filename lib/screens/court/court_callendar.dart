import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'dart:convert';

class CourtCallendar extends StatefulWidget {
  const CourtCallendar({super.key});

  @override
  State<CourtCallendar> createState() => _CourtCallendarState();
}

class _CourtCallendarState extends State<CourtCallendar> {
  DateTime? selectedDateTime;

  @override
  Widget build(BuildContext context) {
    final workingHours = _getWorkingHours();
    final startHour = workingHours['startHour']!.toDouble();
    final endHour = workingHours['endHour']!.toDouble();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecione o Horário Desejado'),
      ),
      body: SfCalendar(
        view: CalendarView.week,
        minDate: DateTime.now().add(const Duration(hours: 2)),
        maxDate: DateTime.now().add(const Duration(days: 30)),
        timeZone: 'Central Brazilian Standard Time',
        specialRegions: _getTimeRegions(),
        onTap: (CalendarTapDetails details) {
          setState(() {
            selectedDateTime = details.date;
          });
          if (selectedDateTime != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Selected: $selectedDateTime')),
            );
          }
        },
        timeSlotViewSettings: TimeSlotViewSettings(
          startHour: startHour,
          endHour: endHour,
          timeFormat: 'HH:mm',
          timeIntervalHeight: 60,
        ),
      ),
    );
  }
}

const String workingHoursJson = '''
{
  "monday": [{"start": "08:00", "end": "19:00"}],
  "tuesday": [{"start": "08:00", "end": "18:00"}],
  "wednesday": [{"start": "11:00", "end": "22:00"}],
  "thursday": [{"start": "06:00", "end": "18:00"}],
  "saturday": [{"start": "12:00", "end": "23:00"}],
  "friday": [],
  "sunday": [{"start": "14:00", "end": "22:00"}]
}
''';

List<TimeRegion> _getTimeRegions() {
  final List<TimeRegion> regions = <TimeRegion>[];

  final Map<String, dynamic> workingHours = jsonDecode(workingHoursJson);

  DateTime _parseTime(String time, DateTime date) {
    final parts = time.split(':');
    return DateTime(date.year, date.month, date.day, int.parse(parts[0]), int.parse(parts[1]));
  }

  const int numberOfWeeks = 5;

  for (int week = 0; week < numberOfWeeks; week++) {
    workingHours.forEach((day, slots) {
      final int weekday = _getWeekday(day);
      final DateTime now = DateTime.now();
      final DateTime currentDay = now.add(Duration(days: (weekday - now.weekday) + (week * 7)));

      if (slots.isEmpty) {
        regions.add(TimeRegion(
          startTime: DateTime(currentDay.year, currentDay.month, currentDay.day),
          endTime: DateTime(currentDay.year, currentDay.month, currentDay.day + 1),
          enablePointerInteraction: false,
          color: const Color.fromARGB(255, 125, 125, 125).withOpacity(0.2),
          text: 'Dia não disponível',
        ));
      } else {
        final startFirstSlot = _parseTime(slots.first['start'], currentDay).add(Duration(hours: 1));
        if (startFirstSlot.hour > 0) {
          regions.add(TimeRegion(
            startTime: DateTime(currentDay.year, currentDay.month, currentDay.day),
            endTime: startFirstSlot,
            enablePointerInteraction: false,
            color: const Color.fromARGB(255, 125, 125, 125).withOpacity(0.2),
          ));
        }

        final endLastSlot = _parseTime(slots.last['end'], currentDay).add(Duration(hours: 1));
        if (endLastSlot.hour < 24) {
          regions.add(TimeRegion(
            startTime: endLastSlot,
            endTime: DateTime(currentDay.year, currentDay.month, currentDay.day + 1),
            enablePointerInteraction: false,
            color: const Color.fromARGB(255, 125, 125, 125).withOpacity(0.2),
          ));
        }
      }
    });
  }

  return regions;
}

int _getWeekday(String day) {
  switch (day.toLowerCase()) {
    case 'monday':
      return DateTime.monday;
    case 'tuesday':
      return DateTime.tuesday;
    case 'wednesday':
      return DateTime.wednesday;
    case 'thursday':
      return DateTime.thursday;
    case 'friday':
      return DateTime.friday;
    case 'saturday':
      return DateTime.saturday;
    case 'sunday':
      return DateTime.sunday;
    default:
      throw ArgumentError('Invalid day: $day');
  }
}

Map<String, int> _getWorkingHours() {
  final Map<String, dynamic> workingHours = jsonDecode(workingHoursJson);
  int minStartHour = 24;
  int maxEndHour = 0;

  workingHours.forEach((day, slots) {
    for (var slot in slots) {
      final startHour = int.parse(slot['start'].split(':')[0]);
      final endHour = int.parse(slot['end'].split(':')[0]);
      if (startHour < minStartHour) {
        minStartHour = startHour;
      }
      if (endHour > maxEndHour) {
        maxEndHour = endHour;
      }
    }
  });

  return {
    'startHour': minStartHour - 1,
    'endHour': maxEndHour + 1,
  };
}

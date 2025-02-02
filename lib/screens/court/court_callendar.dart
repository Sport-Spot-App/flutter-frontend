import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CourtCallendar extends StatefulWidget {
  const CourtCallendar({super.key});

  @override
  State<CourtCallendar> createState() => _CourtCallendarState();
}

class _CourtCallendarState extends State<CourtCallendar> {
  DateTime? selectedDateTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservar Horário'),
      ),
      body: SfCalendar(
        view: CalendarView.day,
        minDate: DateTime.now(),
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
          startHour: 8,
          endHour: 18,
          timeFormat: 'HH:mm',
          timeIntervalHeight: 60,
        ),
      ),
    );
  }
}

List<TimeRegion> _getTimeRegions() {
  final List<TimeRegion> regions = <TimeRegion>[];

  final List<Map<String, DateTime>> blockedSlots = [
    {
      'start': DateTime(2025, 2, 3, 10, 0),
      'end': DateTime(2025, 2, 3, 11, 0),
    },
    {
      'start': DateTime(2025, 2, 3, 14, 0),
      'end': DateTime(2025, 2, 3, 15, 0),
    },
  ];

  blockedSlots.forEach((slot) {
    regions.add(TimeRegion(
      startTime: slot['start']!,
      endTime: slot['end']!,
      enablePointerInteraction: false,
      color: const Color.fromARGB(255, 233, 130, 13).withOpacity(0.2),
      text: 'Reservado',
    ));
  });

  return regions;
}

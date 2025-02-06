import 'package:flutter/material.dart';
import 'package:sport_spot/api/api.dart';
import 'package:sport_spot/models/court_model.dart';
import 'package:sport_spot/repositories/court_repository.dart';
import 'package:sport_spot/screens/court/court_booking.dart';
import 'package:sport_spot/screens/court/create_court_page.dart';
import 'package:dio/dio.dart';
import 'package:sport_spot/stores/court_store.dart';

class CourtOwnerCard extends StatefulWidget {
  final CourtModel court;


  const CourtOwnerCard(this.court, {super.key});

  @override
  State<CourtOwnerCard> createState() => _CourtOwnerCardState();
}

class _CourtOwnerCardState extends State<CourtOwnerCard> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          child: widget.court.photos!.isNotEmpty
              ? Image.network(
                  'https://sportspott.tech/storage/${widget.court.photos![0].path}',
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image_not_supported_outlined);
                  },
                )
              : const Icon(Icons.image_not_supported_outlined),
        ),
        title: Center(
          child: Text(widget.court.name),
        ),
        titleTextStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        subtitle: Column(
          children: [
            Text(widget.court.sports.map((sport) => sport.name).join(', ')),
            Text("${widget.court.street}, ${widget.court.number}"),
            Text("R\$ ${widget.court.price_per_hour} / hora"),
          ],
        ),
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.block),
                    title: const Text("Bloquear Horários"),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => CourtBookingPage(courtId: widget.court.id.toString())));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text("Editar Quadra"),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => CreateCourtPage(court: widget.court)));
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

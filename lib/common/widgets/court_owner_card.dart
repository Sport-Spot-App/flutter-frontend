import 'package:flutter/material.dart';
import 'package:sport_spot/models/court_model.dart';
import 'package:sport_spot/screens/court/create_court_page.dart';

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
              ? Image.network(widget.court.photos![0].path)
              : const Icon(Icons.image_not_supported),
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
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => CreateCourtPage(court: widget.court)));
        },
      ),
    );
  }
}

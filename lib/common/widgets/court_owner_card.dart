import 'package:flutter/material.dart';
import 'package:sport_spot/screens/court/create_court_page.dart';

class CourtOwnerCard extends StatefulWidget {
  final Map<String, dynamic> court;

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
          child: widget.court["image"] != null && widget.court["image"].isNotEmpty
              ? Image.network(widget.court["image"][0])
              : const Icon(Icons.image_not_supported),
        ),
        title: Center(
          child: Text(widget.court["name"]),
        ),
        titleTextStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        subtitle: Column(
          children: [
            const Text("Futebol, Volêi, Handebol, Basquete"),
            const Text("Nome da rua, 660"),
            Text("R\$ ${widget.court["price"]} / hora"),
          ],
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => CreateCourtPage(court: widget.court)));
        },
      ),
    );
  }
}
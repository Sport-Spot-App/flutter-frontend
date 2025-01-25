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
          borderRadius: BorderRadius.all(Radius.circular(5)),
          child: Image.network(widget.court["image"][0]),
        ),
        title: Center(
          child: Text(widget.court["name"]),
        ),
        titleTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        subtitle: Column(
          children: [
            Text("Futebol, Volêi, Handebol, Basquete"),
            Text("Nome da rua, 660"),
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
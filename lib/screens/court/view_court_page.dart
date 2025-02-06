import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sport_spot/api/api.dart';
import 'package:sport_spot/common/constants/app_colors.dart';
import 'package:sport_spot/models/court_model.dart';
import 'package:sport_spot/repositories/court_repository.dart';
import 'package:sport_spot/screens/court/court_booking.dart';
import 'package:sport_spot/screens/map/court_map_page.dart';
import 'package:sport_spot/stores/court_store.dart';

class ViewCourtPage extends StatefulWidget {
  final CourtModel court;

  const ViewCourtPage({required this.court, super.key});

  @override
  State<ViewCourtPage> createState() => _ViewCourtPageState();
}

class _ViewCourtPageState extends State<ViewCourtPage> {
  final CarouselSliderController _controller = CarouselSliderController();
  final CourtStore courtStore = CourtStore(repository: CourtRepository(Api()));
  bool isFavorite = false;
  int currentIndex = 0;
  List<String> diasFuncionamento = [];
  String initialHour = "";
  String finalHour = "";

  List<Map<String, dynamic>> dias = [
    { 'label': 'Domingo', 'key': 'sunday' },
    { 'label': 'Segunda-Feira', 'key': 'Monday' },
    { 'label': 'Terça-Feira', 'key': 'Tuesday' },
    { 'label': 'Quarta-Feira', 'key': 'Wednesday' },
    { 'label': 'Quinta-Feira', 'key': 'Thursday' },
    { 'label': 'Sexta-Feira', 'key': 'Friday' },
    { 'label': 'Sábado', 'key': 'Saturday' },
  ];

  @override
  void initState() {
    _checkIfFavorite();
    diasFuncionamento = dias.where((day) => widget.court.work_days!.contains( day["key"] ))
                          .map<String>((day) => day["label"])
                          .toList();

    List<String> hourParts = [];
    List<String> hourMinutes = [];
    bool isMorning = false;

    hourParts = widget.court.initial_hour!.split(' ');
    hourMinutes = hourParts[0].split(':');
    isMorning = hourParts[1] == "AM";
    int auxInitial = isMorning ? int.parse(hourMinutes[0]) : int.parse(hourMinutes[0]) + 12;
    initialHour = "${auxInitial}h${hourMinutes[1]}";

    hourParts = widget.court.final_hour!.split(' ');
    hourMinutes = hourParts[0].split(':');
    isMorning = hourParts[1] == "AM";
    int auxFinal = isMorning ? int.parse(hourMinutes[0]) : int.parse(hourMinutes[0]) + 12;
    finalHour = "${auxFinal}h${hourMinutes[1]}";
                  
    super.initState();
  }

  Future<void> _checkIfFavorite() async {
    await courtStore.getFavoriteCourts();
    setState(() {
      isFavorite = courtStore.favoriteCourtIds.value.contains(widget.court.id);
    });
  }

  Future<void> _toggleFavorite() async {
    await courtStore.favoriteCourt(widget.court.id!);
    _checkIfFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarouselSlider(
                carouselController: _controller,
                options: CarouselOptions(
                  viewportFraction: 1,
                  aspectRatio: 1.5,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
                items: _getListImages(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _getIndicatorImages(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      widget.court.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                      _toggleFavorite();
                    },
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_outline,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "R\$ ${widget.court.price_per_hour.toString()}",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(" / hora"),
                ],
              ),
              Text(widget.court.description),
              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 10),
              Text("Esportes:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(widget.court.sports.map((e) => e.name).join(", ")),
              SizedBox(height: 20),
              Text("Horário de funcionamento:", style: TextStyle(fontWeight: FontWeight.bold)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(diasFuncionamento.join(', ')),
                  Text("das $initialHour às $finalHour"),
                ],
              ),
              SizedBox(height: 20),
              Text("Endereço:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("${widget.court.street}, N° ${widget.court.number}, ${widget.court.bairro}"),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize:
                    Size(MediaQuery.of(context).size.width / 2 - 25, 50),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => CourtMapPage(widget.court)));
              },
              child: Text("Ver no mapa", style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkOrange,
                minimumSize:
                    Size(MediaQuery.of(context).size.width / 2 - 25, 50),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => CourtBookingPage(court: widget.court)));
              },
              child: Text("Reservar", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  _getListImages() {
    List<Widget> listImages = [];

    if (widget.court.photos!.isNotEmpty) {
      for (var file in widget.court.photos ?? []) {
        final path = file.path;
        final url = 'https://sportspott.tech/storage/$path';
        Widget wdgt = ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Image.network(
            url,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.image_not_supported_outlined,
                  size: 50, color: Colors.grey);
            },
          ),
        );

        listImages.add(wdgt);
      }
    } else {
      Widget wdgt = Container(
        margin: EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported_outlined,
                color: Colors.grey,
                size: 50,
              ),
            ],
          ),
        ),
      );

      listImages.add(wdgt);
    }

    return listImages;
  }

  _getIndicatorImages() {
    List<Widget> indicators = [];

    var length = widget.court.photos!.length;
    for (var i = 0; i < length; i++) {
      Widget wdgt = Container(
        width: 6.0,
        height: 6.0,
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: (Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black)
              .withOpacity(currentIndex == i ? 0.9 : 0.4),
        ),
      );

      indicators.add(wdgt);
    }

    return indicators;
  }
}

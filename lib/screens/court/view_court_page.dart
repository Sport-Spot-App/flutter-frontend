import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sport_spot/common/constants/app_colors.dart';
import 'package:sport_spot/models/court_model.dart';
import 'package:sport_spot/screens/map/court_map_page.dart';

class ViewCourtPage extends StatefulWidget {
  final CourtModel court;

  const ViewCourtPage({required this.court, super.key});

  @override
  State<ViewCourtPage> createState() => _ViewCourtPageState();
}

class _ViewCourtPageState extends State<ViewCourtPage> {
  final CarouselSliderController _controller = CarouselSliderController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
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
                  onPageChanged:(index, reason) {
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
                  Text(
                    widget.court.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {

                    },
                    icon: Icon(Icons.favorite_outline),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "R\$ ${widget.court.price_per_hour}",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    " / hora"
                  ),
                ],
              ),
              Text(widget.court.description),
              Text(widget.court.description),
              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 10),
              Text("Esportes:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(widget.court.sports.join(', ')),
              Text(widget.court.sports.join(', ')),
              SizedBox(height: 20),
              Text("Horário de funcionamento:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("De segunda à sexta\nDas 14h às 16h"),
              SizedBox(height: 20),
              Text("Endereço:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("${widget.court.street}, N° ${widget.court.number}"),
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
                minimumSize: Size(MediaQuery.of(context).size.width / 2 - 25, 50),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => CourtMapPage(widget.court)));
              },
              child: Text("Ver no mapa", style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkOrange,
                minimumSize: Size(MediaQuery.of(context).size.width / 2 - 25, 50),
              ),
              onPressed: () {
                // Reservar
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

    if (widget.court.photos.isNotEmpty) {
      for (var image in widget.court.photos) {
        Widget wdgt = ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Image.network(
            image,
            width: double.infinity,
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
                size: 200,
              ),
              Text('Nenhuma imagem cadastrada!'),
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

    var length = widget.court.photos.length;
    for (var i = 0; i < length; i++) {

      Widget wdgt = Container(
        width: 6.0,
        height: 6.0,
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: (
            Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black
          ).withOpacity(currentIndex == i ? 0.9 : 0.4),
        ),
      );

      indicators.add(wdgt);
    }

    return indicators;
  }
}
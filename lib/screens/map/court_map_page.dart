import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sport_spot/common/constants/app_colors.dart';
import 'package:sport_spot/models/court_model.dart';

class CourtMapPage extends StatefulWidget {
  final CourtModel court;

  const CourtMapPage(this.court, {super.key});

  @override
  State<CourtMapPage> createState() => _CourtMapPageState();
}

class _CourtMapPageState extends State<CourtMapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkOrange,
        title: Text("Localização", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(
                  double.parse(widget.court.coordinate_x!),
                  double.parse(widget.court.coordinate_y!),
                ),
                initialZoom: 17,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.sport_spot',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(
                        double.parse(widget.court.coordinate_x!),
                        double.parse(widget.court.coordinate_y!),
                      ),
                      child: Icon(
                        Icons.location_on,
                        size: 30,
                        color: AppColors.darkOrange,
                      ),
                    ),
                  ]
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppColors.darkOrange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  widget.court.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(widget.court.street),
                    Text(" • Foz do Iguaçu, Paraná", style: TextStyle(color: AppColors.darkOrange)),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
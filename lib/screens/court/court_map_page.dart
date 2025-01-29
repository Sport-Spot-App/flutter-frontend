import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sport_spot/common/constants/app_colors.dart';

class CourtMapPage extends StatefulWidget {
  const CourtMapPage({super.key});

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
                initialCenter: LatLng(-25.518243922290036, -54.554903249502345),
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
                      point: LatLng(-25.518243922290036, -54.554903249502345),
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
                  "Nome da quadra",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text("Nome da rua"),
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
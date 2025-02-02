import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:sport_spot/common/constants/app_colors.dart';

class AllCourtsMapPage extends StatefulWidget {
  const AllCourtsMapPage({super.key});

  @override
  State<AllCourtsMapPage> createState() => _AllCourtsMapPageState();
}

class _AllCourtsMapPageState extends State<AllCourtsMapPage> {
  LatLng? myLocation;
  Map<String, dynamic>? courtSelected;
  List<Map<String, dynamic>> courtList = [
    {"lat": -25.54783490595641, "long": -54.56449992657674, "name": "Planeta Bola"},
    {"lat": -25.548570570762557, "long": -54.545230939133624, "name": "Templo Esportes e BeachBar"},
    {"lat": -25.54977085627922, "long": -54.55960757787181, "name": "Quadra do Nenezão"},
    {"lat": -25.539548685291482, "long": -54.556560588766104, "name": "Orla Foz"},
    {"lat": -25.518243922290036, "long": -54.554903249502345, "name": "Ginásio de Esportes Costa Cavalcanti"},
  ];

  Future _getPosition() async {
    try {
      await Geolocator.requestPermission();
      Position myPosition = await Geolocator.getCurrentPosition();
      setState(() {
        myLocation = LatLng(myPosition.latitude, myPosition.longitude);
      });
    } catch (e) {
      setState(() {
        myLocation = LatLng(-25.542731084056662, -54.58501349777966);
      });
    }
  }

  @override
  void initState() {
    _getPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          if (myLocation == null) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.darkOrange,
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: myLocation!,
                    initialZoom: 17,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.sport_spot',
                    ),
                    MarkerLayer(
                      markers: _getMarkerList(),
                    ),
                  ],
                ),
              ),
              Builder(
                builder: (context) {
                  if (courtSelected == null) {
                    return Container();
                  }

                  return SingleChildScrollView(
                    child: Container(
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
                          SizedBox(height: 10),
                          Text(
                            "${courtSelected!['name']}",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text("Nome da rua"),
                              Text(" • Foz do Iguaçu, Paraná", style: TextStyle(color: AppColors.darkOrange)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
              )
            ],
          );
        }
      ),
    );
  }

  _getMarkerList() {
    List<Marker> markerList = [];

    for (var court in courtList) {
      Marker mkr = Marker(
        point: LatLng(court["lat"], court["long"]),
        child: GestureDetector(
          onTap: () {
            setState(() {
              courtSelected = court;
            });
          },
          child: Icon(
            Icons.location_on,
            size: 30,
            color: AppColors.darkOrange,
          ),
        ),
      );

      markerList.add(mkr);
    }

    return markerList;
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:sport_spot/api/api.dart';
import 'package:sport_spot/common/constants/app_colors.dart';
import 'package:sport_spot/models/cep_model.dart';
import 'package:sport_spot/models/court_model.dart';
import 'package:sport_spot/repositories/cep_repository.dart';
import 'package:sport_spot/repositories/court_repository.dart';
import 'package:sport_spot/stores/cep_store.dart';

class AllCourtsMapPage extends StatefulWidget {
  const AllCourtsMapPage({super.key});

  @override
  State<AllCourtsMapPage> createState() => _AllCourtsMapPageState();
}

class _AllCourtsMapPageState extends State<AllCourtsMapPage> {
  final CourtRepository courtRepository = CourtRepository(Api());
  final CepStore cepStore = CepStore(repository: CepRepository(Api()));
  LatLng? myLocation;
  List<CourtModel> courtList = [];
  CourtModel? courtSelected;
  CepModel? cepCourtSelected;

  Future<void> _getCEP() async {
    await cepStore.findCep(courtSelected!.zip_code);
    setState(() {
      cepCourtSelected = cepStore.state.value;
    });
  }

  Future<void> _getCourts() async {
    try {
      final courts = await courtRepository.getCourts();
      if (mounted) {
        setState(() {
          courtList = courts;
        });
      }
    } catch (e) {
      // Handle error
      print('Error fetching courts: $e');
    }
  }

  Future<void> _getPosition() async {
    try {
      await Geolocator.requestPermission();
      Position myPosition = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() {
          myLocation = LatLng(myPosition.latitude, myPosition.longitude);
        });
      }
    } catch (e) {
      if (courtList.isNotEmpty) {
        if (mounted) {
          setState(() {
            myLocation = LatLng(double.parse(courtList[0].coordinate_x!), double.parse(courtList[0].coordinate_y!));
          });
        }
      } else {
        if (mounted) {
          setState(() {
            myLocation = LatLng(-25.530553, -54.561060);
          });
        }
      }
    }
  }

  @override
  void initState() {
    _getPosition();
    _getCourts();
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
                            courtSelected!.name,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Builder(
                            builder: (_) {
                              if (cepStore.isLoading.value) {
                                return Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: AppColors.darkOrange,
                                    ),
                                  ),
                                );
                              }

                              return Row(
                                children: [
                                  Text(cepCourtSelected!.logradouro),
                                  Text(" • ${cepCourtSelected!.localidade}, ${cepCourtSelected!.estado}", style: TextStyle(color: AppColors.darkOrange)),
                                ],
                              );
                            },
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

  List<Marker> _getMarkerList() {
    List<Marker> markerList = [];

    Marker myMkr = Marker(
      point: myLocation!,
      child: GestureDetector(
        child: Icon(
          Icons.my_location,
          size: 30,
          color: Colors.blueAccent,
        ),
      ),
    );

    markerList.add(myMkr);

    for (var court in courtList) {
      Marker mkr = Marker(
        point: LatLng(double.parse(court.coordinate_x!), double.parse(court.coordinate_y!)),
        child: GestureDetector(
          onTap: () {
            setState(() {
              courtSelected = court;
            });
            _getCEP();
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
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class CustomSafeBox extends StatelessWidget {
  final String name;
  final NLatLng start;
  final NLatLng end;
  final GestureTapCallback onTap;
  final GestureTapCallback onLongPress;

  const CustomSafeBox(
      {super.key,
      required this.name,
      required this.start,
      required this.end,
      required this.onTap,
      required this.onLongPress});

  @override
  Widget build(BuildContext context) {
    NaverMapController? mapController;

    void _onMapCreated(NaverMapController controller) {
      mapController = controller;
      final startmarker = NMarker(id: 'start', position: start);
      final endmarker = NMarker(id: 'end', position: end);

      mapController!.addOverlay(startmarker);
      mapController!.addOverlay(endmarker);
    }

    return InkWell(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(name, style: TextStyle(fontSize: 20),),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                height: 150,
                child: Expanded(
                  child: NaverMap(

                    onMapReady: _onMapCreated,
                    options: NaverMapViewOptions(
                      initialCameraPosition: NCameraPosition(
                          target: NLatLng((start.latitude + end.latitude) / 2,
                              (start.longitude + end.longitude) / 2),
                          zoom: 12),
                        rotationGesturesEnable: false,
                      scrollGesturesEnable: false,
                      tiltGesturesEnable: false,
                      stopGesturesEnable: false,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

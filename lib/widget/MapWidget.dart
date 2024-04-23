import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatefulWidget {
  final Function(LatLng) onPositionChanged;

  MapWidget({
    required this.onPositionChanged,
  });

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  LatLng _selectedPosition = LatLng(45.4554, 8.8908);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(45.4554, 8.8908),
        initialZoom: 9.2,
        onTap: _handleTap,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 100.0,
              height: 100.0,
              point: _selectedPosition,
              child: Icon(
                Icons.location_pin,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _handleTap(TapPosition tapPosition, LatLng tappedPosition) {
    setState(() {
      _selectedPosition = tappedPosition;
    });
    widget.onPositionChanged(tappedPosition);
  }

}

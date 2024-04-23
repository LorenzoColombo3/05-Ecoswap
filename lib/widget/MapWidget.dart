import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatefulWidget {
  final LatLng initialPosition;  // Aggiunto per prendere la posizione iniziale come input
  final Function(LatLng) onPositionChanged;

  MapWidget({
    required this.initialPosition, // Questo sarà il nuovo parametro per la posizione iniziale
    required this.onPositionChanged,
  });

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late LatLng _selectedPosition;

  @override
  void initState() {
    super.initState();
    _selectedPosition = widget.initialPosition; // Imposta la posizione iniziale dal parametro
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: _selectedPosition,
        initialZoom: 9.2,
        onTap: _handleTap,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://mt1.google.com/vt/lyrs=r&x={x}&y={y}&z={z}&key=<YOUR_API_KEY>',
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

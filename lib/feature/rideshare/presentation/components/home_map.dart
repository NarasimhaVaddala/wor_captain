import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wor_captain/core/location.dart';

class HomeMap extends StatefulWidget {
  const HomeMap({super.key});

  @override
  State<HomeMap> createState() => _HomeMapState();
}

class _HomeMapState extends State<HomeMap> {
  GoogleMapController? mapController;

  // Default center (used until user location is available)
  static const LatLng _defaultCenter =
      LatLng(37.7749, -122.4194); // San Francisco

  // Set to hold markers
  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // Animate map to the given coordinates
  void _moveToLocation(LatLng location) {
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: location,
          zoom: 15.0, // Closer zoom for user location
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocConsumer<LocationBloc, LocationState>(
          listener: (context, state) {
            if (state is LocationLoaded) {
              final LatLng userLocation = LatLng(
                state.position.latitude,
                state.position.longitude,
              );
              // Move map to user location
              _moveToLocation(userLocation);
              // Add marker for user location
              _markers.clear();
              _markers.add(
                Marker(
                  markerId: const MarkerId('user_location'),
                  position: userLocation,
                  infoWindow: const InfoWindow(title: 'Your Location'),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is LocationLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // Default to _defaultCenter for non-loading states
            LatLng center = _defaultCenter;
            if (state is LocationLoaded) {
              center =
                  LatLng(state.position.latitude, state.position.longitude);
            }

            return SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: center,
                  zoom: 11.0,
                ),
                markers: _markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                mapType: MapType.normal,
              ),
            );
          },
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            onPressed: () {
              // Trigger FetchLocation to get the latest user location
              context.read<LocationBloc>().add(FetchLocation());
            },
            tooltip: 'Go to My Location',
            child: const Icon(Icons.my_location),
          ),
        ),
      ],
    );
  }
}

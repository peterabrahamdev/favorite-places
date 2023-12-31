import 'dart:convert';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/place_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationInput extends ConsumerStatefulWidget {
  const LocationInput({super.key, required this.onPickLocation});

  final void Function(PlaceLocation location) onPickLocation;

  @override
  ConsumerState<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends ConsumerState<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  String get locationImage {
    if (_pickedLocation == null) {
      return '';
    }

    final lat = _pickedLocation!.latitude;
    final lng = _pickedLocation!.longitude;
    final key = FlutterConfig.get('GOOGLE_MAPS_API_KEY');

    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng=&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:S%7C$lat,$lng&key=$key';
  }

  void _getLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;
    final locationCache = ref.read(placeLocationCacheProvider);

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });
    locationData = await location.getLocation();

    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) {
      return;
    }

    if (locationCache.containsKey('$lat,$lng')) {
      setState(() {
        _pickedLocation = locationCache['$lat,$lng'];
        _isGettingLocation = false;
      });
    } else {
      final key = FlutterConfig.get('GOOGLE_MAPS_API_KEY');

      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$key');

      final response = await http.get(url);
      final resData = json.decode(response.body);

      final address = resData['results'][0]['formatted_address'];

      setState(() {
        _pickedLocation = PlaceLocation(
          latitude: lat,
          longitude: lng,
          address: address,
        );
        _isGettingLocation = false;
      });
      ref
          .watch(placeLocationCacheProvider.notifier)
          .cache('$lat,$lng', _pickedLocation!);
    }

    widget.onPickLocation(_pickedLocation!);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'No location chosen.',
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.onBackground),
    );

    if (_pickedLocation != null) {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Get Current Location'),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/widgets/place_item.dart';
import 'package:flutter/material.dart';

class PlaceList extends StatelessWidget {
  const PlaceList({super.key, required this.places});
  final List<Place> places;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ListView.builder(
        itemBuilder: (context, index) => PlaceItem(place: places[index]),
        itemCount: places.length,
      ),
    );
  }
}

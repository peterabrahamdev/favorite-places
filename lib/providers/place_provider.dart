import 'package:favorite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaceNotifier extends StateNotifier<List<Place>> {
  PlaceNotifier() : super([]);

  void addPlace(Place place) {
    state = [...state, place];
    for (Place place in state) {
      print(place.title);
    }
  }
}

final placeProvider =
    StateNotifierProvider<PlaceNotifier, List<Place>>((ref) => PlaceNotifier());

class PlaceLocationCacheNotifier
    extends StateNotifier<Map<String, PlaceLocation>> {
  PlaceLocationCacheNotifier() : super({});

  void cache(String key, PlaceLocation location) {
    state = {...state, key: location};
  }
}

final placeLocationCacheProvider = StateNotifierProvider<
    PlaceLocationCacheNotifier,
    Map<String, PlaceLocation>>((ref) => PlaceLocationCacheNotifier());

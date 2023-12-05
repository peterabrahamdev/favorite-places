import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/place_provider.dart';
import 'package:favorite_places/screens/add_new_place.dart';
import 'package:favorite_places/widgets/place_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void _addNewPlace() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddNewPlaceScreen(),
      ),
    );
  }

  Widget _emptyBody() {
    return Center(
        child: Text(
      'No places added yet',
      style:
          Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
    ));
  }

  Widget _dataBody(List<Place> places) {
    return PlaceList(places: places);
  }

  @override
  Widget build(BuildContext context) {
    final places = ref.watch(placeProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Your places'), actions: [
        IconButton(
          onPressed: _addNewPlace,
          icon: const Icon(Icons.add),
        ),
      ]),
      body: places.isEmpty ? _emptyBody() : _dataBody(places),
    );
  }
}

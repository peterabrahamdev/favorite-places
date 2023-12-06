import 'dart:io';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/place_provider.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewPlaceForm extends ConsumerStatefulWidget {
  const NewPlaceForm({super.key});

  @override
  ConsumerState<NewPlaceForm> createState() => _NewPlaceFormState();
}

class _NewPlaceFormState extends ConsumerState<NewPlaceForm> {
  final _formKey = GlobalKey<FormState>();
  var _placeTitle = '';
  File? _selectedImage;
  PlaceLocation? _selectedLocation;

  void _submit() {
    var isValid = _formKey.currentState!.validate();
    if (!isValid || _selectedImage == null || _selectedLocation == null) {
      return;
    }
    _formKey.currentState!.save();
    ref.read(placeProvider.notifier).addPlace(Place(
        title: _placeTitle,
        image: _selectedImage!,
        location: _selectedLocation!));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              onSaved: (value) {
                _placeTitle = value!;
              },
            ),
            const SizedBox(
              height: 30,
            ),
            ImageInput(onPickImage: (image) {
              _selectedImage = image;
            }),
            const SizedBox(
              height: 30,
            ),
            LocationInput(onPickLocation: (location) {
              _selectedLocation = location;
            }),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.add),
              label: const Text('Add Place'),
            ),
          ],
        ),
      ),
    );
  }
}

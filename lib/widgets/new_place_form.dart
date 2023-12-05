import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/place_provider.dart';
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

  void _submit() {
    var isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    ref.watch(placeProvider.notifier).addPlace(Place(title: _placeTitle));
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
            ElevatedButton(
              style: const ButtonStyle(
                  fixedSize: MaterialStatePropertyAll(Size(150, 10))),
              onPressed: _submit,
              child: const Row(
                children: [
                  Icon(Icons.add),
                  SizedBox(width: 5),
                  Text('Add Place'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

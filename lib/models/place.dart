import 'package:uuid/uuid.dart';

class Place {
  Place({required this.title});

  final String id = const Uuid().v4();
  final String title;
}

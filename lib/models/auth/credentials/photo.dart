//  photo.dart
//  AgroShare
//
//  Create by Vinicius Bruno on 06/09/2026
//

class Photo {
  final String _photo;

  Photo({required this._photo}) {
    _validate();
  }

  String get getValue => _photo;

  void _validate() {}
}

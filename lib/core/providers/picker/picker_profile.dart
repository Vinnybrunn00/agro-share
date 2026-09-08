import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class PickerProfile with ChangeNotifier {
  File? _image;
  File? get image => _image;

  Future<void> handlePicker() async {
    final ImagePicker picker = ImagePicker();

    final XFile? pickerImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxHeight: 140,
    );

    if (pickerImage != null) {
      _image = File(pickerImage.path);
      notifyListeners();
    }
  }
}

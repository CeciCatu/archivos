import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelector extends StatelessWidget {
  final Function(List<XFile>?) onSelectImages;

  ImageSelector({required this.onSelectImages});

  Future<void> _selectImages() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final List<XFile>? pickedFiles = await _picker.pickMultiImage();

      onSelectImages(pickedFiles);
    } catch (e) {
      // errores aca
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _selectImages,
      heroTag: 'imageSelector',
      tooltip: 'Pick Images from gallery',
      child: const Icon(Icons.photo),
    );
  }
}

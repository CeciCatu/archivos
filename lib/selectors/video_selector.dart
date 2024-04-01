import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VideoSelector extends StatelessWidget {
  final Function(XFile?) onSelectVideo;

  VideoSelector({required this.onSelectVideo});

  Future<void> _selectVideo() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? pickedFile = await _picker.pickVideo(source: ImageSource.gallery);

      onSelectVideo(pickedFile);
    } catch (e) {
      // errores aca
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _selectVideo,
      heroTag: 'videoSelector',
      tooltip: 'Pick Video from gallery',
      child: const Icon(Icons.videocam),
    );
  }
}

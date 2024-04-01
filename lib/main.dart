import 'package:flutter/material.dart';
import 'selectors/image_selector.dart';
import 'selectors/video_selector.dart';
import 'selectors/media_preview.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Media Selector Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<File> _selectedImages = [];
  List<File> _selectedVideos = [];

  void _handleImageSelection(List<XFile>? selectedFiles) {
    if (selectedFiles != null) {
      setState(() {
        _selectedImages =
            selectedFiles.map((xFile) => File(xFile.path)).toList();
      });
    }
  }

  void _handleVideoSelection(XFile? selectedFile) {
    if (selectedFile != null) {
      setState(() {
        _selectedVideos.add(File(selectedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Selector Home Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ImageSelector(onSelectImages: _handleImageSelection),
            if (_selectedImages.isNotEmpty)
              Expanded(
                child: Column(
                  children: _selectedImages
                      .map(
                        (imagen) => ImagePreview(images: _selectedImages),
                      )
                      .toList(),
                ),
              ),
            VideoSelector(onSelectVideo: _handleVideoSelection),
            if (_selectedVideos.isNotEmpty)
              Expanded(
                child: Column(
                  children: _selectedVideos
                      .map(
                        (video) => VideoPreview(videoFile: video),
                      )
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

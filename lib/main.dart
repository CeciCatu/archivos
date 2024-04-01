// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'selectors/image_selector.dart';
import 'selectors/video_selector.dart';
import 'selectors/media_preview.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

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
      print(selectedFiles.length);
      print(selectedFiles.first.name);
      print(selectedFiles[1].name);

      setState(() {
        _selectedImages =
            selectedFiles.map((xFile) => File(xFile.path)).toList();
        print(_selectedImages[0]);
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

  nombres(List<File> imagen) {
    List<String> nombresDeImagenes = [];

    for (var imagen in imagen) {
      String nombre = path.basename(imagen.path);
      nombresDeImagenes.add(nombre);
    }

    return nombresDeImagenes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Selector Home Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ImageSelector(onSelectImages: _handleImageSelection),
            // if (_selectedImages.isNotEmpty)
              const Text("nombres de archivos"),
              ListView.builder(
                itemCount: _selectedImages.length,
                itemBuilder: (context, index) {
                  print(_selectedImages.length);
                  return Text(nombres(_selectedImages)[index]);
                },
              )
            // ImagePreview(images: _selectedImages),
            // VideoSelector(onSelectVideo: _handleVideoSelection),
            // if (_selectedVideos.isNotEmpty)
            //   Column(
            //     children: _selectedVideos.map((video) => VideoPreview(videoFile: video)).toList(),
            //   ),
          ],
        ),
      ),
    );
  }
}

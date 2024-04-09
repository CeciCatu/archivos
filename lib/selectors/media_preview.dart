import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

class ImagePreview extends StatelessWidget {
  final List<File> images;

  const ImagePreview({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    // List<String> imageNames =
    //     images.map((file) => file.path.split('/').last).toList();

    return Column(
      children: [
        const Text("nombres de archivos"),
        ListView.builder(
          itemCount: nombres(images).length,
          itemBuilder: (context, index) {
            print(images.length);
            return Column(
              children: [
                Text(nombres(images)[index]),
                // Image.file(images[index]),
              ],
            );
          },
        ),
      ],
    );
  }

  nombres(List<File> imagen) {
    List<String> nombresDeImagenes = [];

    for (var imagen in imagen) {
      String nombre = path.basename(imagen.path);
      nombresDeImagenes.add(nombre);
    }

    return nombresDeImagenes;
  }
}

class VideoPreview extends StatefulWidget {
  final File videoFile;

  VideoPreview({required this.videoFile});

  @override
  _VideoPreviewState createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : Container();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

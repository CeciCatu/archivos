import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class ImagePreview extends StatefulWidget {
  final List<File> images;

  ImagePreview({required this.images});

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.images.length,
      itemBuilder: (context, index) {
        return Image.file(widget.images[index]);
      },
    );
  }
}

// class _ImagePreviewState extends State<ImagePreview> {
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: widget.images.length,
//       itemBuilder: (context, index) {
//         return Image.file(widget.images[index]);
//       },
//     );
//   }
// }

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

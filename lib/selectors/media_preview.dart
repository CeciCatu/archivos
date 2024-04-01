import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class ImagePreview extends StatelessWidget {
  final List<File> images;

  ImagePreview({required this.images});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: images.length,
      itemBuilder: (context, index) {
        return Image.file(images[index]);
      },
    );
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

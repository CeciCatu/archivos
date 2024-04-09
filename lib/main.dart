import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interactive Cards',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: InteractiveGrid(),
    );
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    final Meeting meeting = appointments![index] as Meeting;
    return meeting.from;
  }

  @override
  DateTime getEndTime(int index) {
    final Meeting meeting = appointments![index] as Meeting;
    return meeting.to;
  }

  @override
  String getSubject(int index) {
    final Meeting meeting = appointments![index] as Meeting;
    return meeting.eventName;
  }

  @override
  Color getColor(int index) {
    final Meeting meeting = appointments![index] as Meeting;
    return meeting.background;
  }

  @override
  bool isAllDay(int index) {
    final Meeting meeting = appointments![index] as Meeting;
    return meeting.isAllDay;
  }
}


class InteractiveGrid extends StatefulWidget {
  @override
  _InteractiveGridState createState() => _InteractiveGridState();

}

class _InteractiveGridState extends State<InteractiveGrid> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedImages = [];
  List<XFile> _selectedVideos = [];
  List<String> _videoThumbnails = [];
  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    // Populate your meetings here
    return meetings;
  }
  void _showSyncfusionCalendar(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SfCalendar(
            view: CalendarView.month,
            dataSource: MeetingDataSource(_getDataSource()),
            // Other calendar settings
          ),
        );
      },
    );
  }


  void _pickMedia(BuildContext context, int index) async {
    if (index == 0) {
      final List<XFile>? images = await _picker.pickMultiImage();
      if (images != null && images.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(images);
        });
      }
    } else if (index == 1) {
      _pickVideos(context);
    }
  }

  void _showCalendarDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),
            ),
          ),
        );
      },
    );
  }

  void _pickVideos(BuildContext context) async {
    bool selecting = true;
    while (selecting) {
      final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        setState(() {
          _selectedVideos.add(video);
          _generateThumbnail(video.path);
        });
      } else {
        selecting = false;
      }

    }
  }

  void _viewFullScreenImage(BuildContext context, String imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImagePage(imagePath: imagePath),
      ),
    );
  }

  void _generateThumbnail(String videoPath) async {
    final String? thumbnail = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
    );

    if (thumbnail != null) {
      setState(() {
        _videoThumbnails.add(thumbnail);
      });
    }
  }

  void _playVideo(BuildContext context, String videoPath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenVideoPlayerPage(videoPath: videoPath),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int itemCount = 6 + _selectedImages.length + _selectedVideos.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Interactive Cards Grid'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          if (index == 2) {
            // esto muestra el calendario
            return GestureDetector(
              onTap: () => _showCalendarDialog(context),
              child: Card(
                color: Colors.blue[200],
                child: Center(child: Text('Card $index')),
              ),
            );
          }
          if (index == 3) {
            return GestureDetector(
              onTap: () => _showSyncfusionCalendar(context),
              child: Card(
                // Card styling
                child: Center(child: Text('Card $index')),
              ),
            );
          }

          if (index >= 6) {
            int imageIndex = index - 6;
            if (imageIndex < _selectedImages.length) {
              String imagePath = _selectedImages[imageIndex].path;
              return GestureDetector(
                onTap: () => _viewFullScreenImage(context, imagePath),
                child: Image.file(File(imagePath)),
              );
            } else {
              int videoIndex = imageIndex - _selectedImages.length;
              if (videoIndex < _selectedVideos.length) {
                String videoThumbnailPath = _videoThumbnails[videoIndex];
                String videoPath = _selectedVideos[videoIndex].path;
                return GestureDetector(
                  onTap: () => _playVideo(context, videoPath),
                  child: Image.file(File(videoThumbnailPath)),
                );
              }
            }
          }

          return GestureDetector(
            onTap: () => _pickMedia(context, index),
            child: Card(
              color: Colors.blue[100 * (index % 9)],
              child: Center(child: Text('Card $index')),
            ),
          );
        },
      ),
    );
  }
}

class FullScreenImagePage extends StatelessWidget {
  final String imagePath;

  const FullScreenImagePage({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Full Screen Image'),
      ),
      body: Center(
        child: Image.file(File(imagePath)),
      ),
    );
  }
}

class FullScreenVideoPlayerPage extends StatefulWidget {
  final String videoPath;

  const FullScreenVideoPlayerPage({Key? key, required this.videoPath}) : super(key: key);

  @override
  _FullScreenVideoPlayerPageState createState() => _FullScreenVideoPlayerPageState();
}

class _FullScreenVideoPlayerPageState extends State<FullScreenVideoPlayerPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {});
      })
      ..play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video Player')),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class CustomGalleryScreen extends StatefulWidget {
  @override
  _CustomGalleryScreenState createState() => _CustomGalleryScreenState();
}

class _CustomGalleryScreenState extends State<CustomGalleryScreen> {
  List<AssetEntity> videos = [];

  @override
  void initState() {
    super.initState();
    _fetchVideos();
  }

  Future<void> _fetchVideos() async {
    final PermissionState permission = await PhotoManager.requestPermissionExtend();
    if (permission.isAuth) {
      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(type: RequestType.video);
      final List<AssetEntity> fetchedVideos = await albums.first.getAssetListRange(start: 0, end: 100);

      setState(() {
        videos = fetchedVideos;
      });
    } else {
      PhotoManager.openSetting();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Videos")),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: videos.length,
        itemBuilder: (_, index) {
          return FutureBuilder<Uint8List?>(
            future: videos[index].thumbnailData,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return InkWell(
                  onTap: () {
                    //Seleccion de video
                  },
                  child: snapshot.data != null
                      ? Image.memory(snapshot.data!)
                      : Center(child: CircularProgressIndicator()),
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }
}

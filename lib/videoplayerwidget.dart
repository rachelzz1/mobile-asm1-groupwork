import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);
  final String videoUrl;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.asset(widget.videoUrl);
    _initializeVideoPlayerFuture = _videoPlayerController.initialize().then((
      _,
    ) async {
      _videoPlayerController.setVolume(1.0);
      _videoPlayerController.play();
      _videoPlayerController.setLooping(true);
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Center(
            child: AspectRatio(
              aspectRatio: _videoPlayerController.value.aspectRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  VideoPlayer(_videoPlayerController),
                  _ControlsOverlay(controller: _videoPlayerController),
                  VideoProgressIndicator(
                    _videoPlayerController,
                    allowScrubbing: true,
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class VideoPlayerPage extends StatelessWidget {
  final String videoUrl;
  const VideoPlayerPage({Key? key, required this.videoUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("video player")),
      body: Center(child: VideoPlayerWidget(videoUrl: videoUrl)),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.value.isPlaying ? controller.pause() : controller.play();
      },
      child: Stack(
        children: <Widget>[
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            reverseDuration: const Duration(milliseconds: 200),
            child:
                controller.value.isPlaying
                    ? const SizedBox.shrink()
                    : Container(
                      color: Colors.black26,
                      child: const Center(
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 60.0,
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}

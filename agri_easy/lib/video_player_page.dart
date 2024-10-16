import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoPath;

  const VideoPlayerPage({super.key, required this.videoPath});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _showControls = true;
  bool _isVideoReady = false;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {
          _isVideoReady = true;
        });
        _controller.play();
        _isPlaying = true;
        _enterFullScreen();
      }).catchError((error) {
        if (kDebugMode) {
          print("Error loading video: $error");
        }
        setState(() {
          _isError = true;
        });
        // Hide the error screen after a delay of 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          // ignore: use_build_context_synchronously
          Navigator.pop(context); // Navigate back or hide the error
        });
      });

    // Lock the orientation to portrait mode
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playPauseVideo() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  void _seekTo(double value) {
    final position = Duration(seconds: value.toInt());
    _controller.seekTo(position);
    if (!_controller.value.isPlaying) {
      _controller.play();
      _isPlaying = true;
    }
  }

  void _enterFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  void _exitFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  void _rotateVideo() {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
    setState(() {});
  }

  Widget _buildResponsivePlayer(Size screenSize) {
    double aspectRatio = _controller.value.aspectRatio;
    if (aspectRatio > 1.5) {
      aspectRatio = 16 / 9;
    } else {
      aspectRatio = 4 / 3;
    }

    return Center(
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: VideoPlayer(_controller),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_isError)
            const Center(
              child: Text(
                "Error loading video. Please try again later.",
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            )
          else if (_isVideoReady)
            GestureDetector(
              onTap: () {
                _toggleControls();
                if (_showControls) {
                  _exitFullScreen();
                } else {
                  _enterFullScreen();
                }
              },
              child: Center(
                child: _buildResponsivePlayer(screenSize),
              ),
            )
          else
            // Display a loading screen while video is processing
            const Center(
              child: CircularProgressIndicator(),
            ),
          if (_showControls && _isVideoReady)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black.withOpacity(0.7),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ValueListenableBuilder<VideoPlayerValue>(
                      valueListenable: _controller,
                      builder: (context, value, child) {
                        final currentPosition = _formatDuration(value.position);
                        final totalDuration = _formatDuration(value.duration);
                        return Column(
                          children: [
                            Text(
                              "$currentPosition / $totalDuration",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14.0),
                            ),
                            Slider(
                              value: value.position.inSeconds.toDouble(),
                              min: 0.0,
                              max: value.duration.inSeconds.toDouble(),
                              onChanged: (newValue) {
                                _seekTo(newValue);
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                          ),
                          onPressed: _playPauseVideo,
                        ),
                        IconButton(
                          icon: const Icon(Icons.rotate_right,
                              color: Colors.white),
                          onPressed: _rotateVideo,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          if (_showControls)
            Positioned(
              top: 40,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
        ],
      ),
    );
  }
}

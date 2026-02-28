import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String? videoUrl;
  final String? filePath;
  final String dataSourceType; // 'network' or 'file'

  const VideoPlayerScreen({
    super.key,
    this.videoUrl,
    this.filePath,
    required this.dataSourceType,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      if (widget.dataSourceType == 'network') {
        _videoPlayerController = VideoPlayerController.networkUrl(
          Uri.parse(widget.videoUrl!),
        );
      } else if (widget.dataSourceType == 'file') {
        if (kIsWeb) {
          throw Exception("File playback from path not supported on Web in this demo.");
        }
        _videoPlayerController = VideoPlayerController.file(
          File(widget.filePath!),
        );
      } else {
        throw Exception("Unknown data source type");
      }

      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      );

      setState(() {});
    } catch (e) {
      setState(() {
        _isError = true;
        _errorMessage = e.toString();
      });
      debugPrint('Error initializing video player: $e');
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Video Player'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Center(
          child: _isError
              ? Text(
                  'Error: $_errorMessage',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                )
              : _chewieController != null &&
                      _chewieController!.videoPlayerController.value.isInitialized
                  ? Chewie(controller: _chewieController!)
                  : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}

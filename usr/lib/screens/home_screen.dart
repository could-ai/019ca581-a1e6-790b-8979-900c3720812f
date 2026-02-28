import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:couldai_user_app/screens/video_player_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Sample public video URL for testing
  final String sampleVideoUrl =
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';

  Future<void> _pickVideo(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayerScreen(
                filePath: result.files.single.path,
                dataSourceType: 'file',
              ),
            ),
          );
        }
      } else {
        // User canceled the picker
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking file: $e')),
        );
      }
    }
  }

  void _playSampleVideo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(
          videoUrl: sampleVideoUrl,
          dataSourceType: 'network',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Video Player'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.play_circle_fill,
              size: 100,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => _playSampleVideo(context),
              icon: const Icon(Icons.web),
              label: const Text('Play Sample Network Video'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _pickVideo(context),
              icon: const Icon(Icons.folder_open),
              label: const Text('Pick Video from Gallery'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Note: File picking might not work in web preview mode due to browser security restrictions. Use the sample video for testing.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

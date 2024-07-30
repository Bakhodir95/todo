import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todo/models/lesson.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LessonPage extends StatefulWidget {
  final Lesson lesson;

  LessonPage({super.key, required this.lesson});

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  late YoutubePlayerController youtubePlayerController;
  late bool isVideoUrlValid;

  @override
  void initState() {
    super.initState();
    isVideoUrlValid = YoutubePlayer.convertUrlToId(widget.lesson.videoUrl) != null;

    if (isVideoUrlValid) {
      youtubePlayerController = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.lesson.videoUrl)!,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false, // Changed to start with audio
        ),
      );
      youtubePlayerController.addListener(() {
        if (!mounted) return;
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    if (isVideoUrlValid) {
      youtubePlayerController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isVideoUrlValid)
              YoutubePlayer(
                controller: youtubePlayerController,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.amber,
                progressColors: const ProgressBarColors(
                  playedColor: Colors.amber,
                  handleColor: Colors.amberAccent,
                ),
              )
            else
              const Center(
                child: Text(
                  'Invalid video URL',
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              ),
            const Gap(15),
            Text(
              widget.lesson.description,
              style: const TextStyle(fontSize: 22),
            ),
          ],
        ),
      ),
    );
  }
}

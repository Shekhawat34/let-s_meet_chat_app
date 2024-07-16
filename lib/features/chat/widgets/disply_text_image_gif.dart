import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lets_meet/features/chat/widgets/video_player_item.dart';
import '../../../common/enums/messageEnum.dart';

class DisplayTextImageGIF extends StatefulWidget {
  final String message;
  final MessageEnum type;

  const DisplayTextImageGIF({
    super.key,
    required this.message,
    required this.type,
  });

  @override
  _DisplayTextImageGIFState createState() => _DisplayTextImageGIFState();
}

class _DisplayTextImageGIFState extends State<DisplayTextImageGIF> {
  late AudioPlayer audioPlayer;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.type == MessageEnum.text
        ? Text(
      widget.message,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.white, // Adjust text color
      ),
    )
        : widget.type == MessageEnum.audio
        ? IconButton(
      constraints: const BoxConstraints(
        minWidth: 100,
      ),
      onPressed: () async {
        if (isPlaying) {
          await audioPlayer.pause();
          setState(() {
            isPlaying = false;
          });
        } else {
          await audioPlayer.play(UrlSource(widget.message));
          setState(() {
            isPlaying = true;
          });
        }
      },
      icon: Icon(
        isPlaying ? Icons.pause_circle : Icons.play_circle,
        color: Colors.red, // Adjust icon color
      ),
    )
        : widget.type == MessageEnum.video
        ? VideoPlayerItem(
      videoUrl: widget.message,
    )
        : CachedNetworkImage(
      imageUrl: widget.message,
      placeholder: (context, url) =>
      const CircularProgressIndicator(),
      errorWidget: (context, url, error) =>
      const Icon(Icons.error),
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

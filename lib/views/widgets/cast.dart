import 'package:flutter/material.dart';
import 'package:flutter_cast_video/flutter_cast_video.dart';
import 'package:looneytube/application/local_storage.dart';

class Cast extends StatefulWidget {
  const Cast({
    Key? key,
    required this.onSessionStarted,
    required this.onSessionEnded
  }) : super(key: key);

  final VoidCallback onSessionStarted;
  final VoidCallback onSessionEnded;

  @override
  _CastState createState() => _CastState();
}

class _CastState extends State<Cast> {
  late ChromeCastController _controller;

  void loadVideo(String? videoUrl) {
    if (videoUrl != null) {
      _controller.loadMedia(videoUrl);
      widget.onSessionStarted();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChromeCastButton(
      color: Colors.black,
      onButtonCreated: (controller) {
        setState(() => _controller = controller);
        _controller.addSessionListener();
      },
      onSessionStarted: () {
        getSingleFromLocalStorage('video', 'last').then(loadVideo);
      },
      onSessionEnded: () {
        widget.onSessionEnded();
      },
    );
  }
}

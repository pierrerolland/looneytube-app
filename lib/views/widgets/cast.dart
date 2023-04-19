import 'package:flutter/material.dart';
import 'package:flutter_cast_video/flutter_cast_video.dart';

class Cast extends StatefulWidget {
  const Cast({
    Key? key,
    required this.videoUrl,
    required this.onSessionStarted,
    required this.onSessionEnded
  }) : super(key: key);

  final String videoUrl;
  final VoidCallback onSessionStarted;
  final VoidCallback onSessionEnded;

  @override
  _CastState createState() => _CastState();
}

class _CastState extends State<Cast> {
  late ChromeCastController _controller;

  @override
  Widget build(BuildContext context) {
    return ChromeCastButton(
      color: Colors.black,
      onButtonCreated: (controller) {
        setState(() => _controller = controller);
        _controller.addSessionListener();
      },
      onSessionStarted: () {
        _controller.loadMedia(widget.videoUrl);
        widget.onSessionStarted();
      },
      onSessionEnded: () {
        widget.onSessionEnded();
      },
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

final rewindKeySet = LogicalKeySet(
  LogicalKeyboardKey.arrowLeft,
);

final forwardKeySet = LogicalKeySet(
  LogicalKeyboardKey.arrowRight
);

class RewindIntent extends Intent {}
class ForwardIntent extends Intent {}

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key, required this.videoUrl}) : super(key: key);

  final String videoUrl;

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  late double _lastDoubleTapX;

  @override
  void initState() {
    Wakelock.enable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _controller = VideoPlayerController.network(
      widget.videoUrl
    );

    _initializeVideoPlayerFuture = _controller.initialize().then((_) => {
      setState(() {
        _controller.play();
      })
    });
    _controller.setLooping(false);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    Wakelock.disable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void _pauseOrPlay() {
      setState(() {
        if (_controller.value.isPlaying) {
          _controller.pause();
        } else {
          _controller.play();
        }
      });
    }
    void _rewind() async {
      await _controller.seekTo(((await _controller.position) ?? const Duration()) - const Duration(seconds: 30));
    }
    void _forward () async {
      await _controller.seekTo(((await _controller.position) ?? const Duration()) + const Duration(seconds: 30));
    }

    return GestureDetector(
      onTap: _pauseOrPlay,
      onDoubleTapDown: (TapDownDetails details) => {
        _lastDoubleTapX = details.globalPosition.dx
      },
      onDoubleTap: () => {
        _lastDoubleTapX < MediaQuery.of(context).size.width / 2 ? _rewind() : _forward()
      },
      child: FocusableActionDetector(
        autofocus: true,
        shortcuts: {
          rewindKeySet: RewindIntent(),
          forwardKeySet: ForwardIntent()
        },
        actions: {
          RewindIntent: CallbackAction(onInvoke: (_) => _rewind.call()),
          ForwardIntent: CallbackAction(onInvoke: (_) => _forward.call()),
          ActivateIntent: CallbackAction(onInvoke: (_) => _pauseOrPlay.call()),
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
              child: FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )
          ),
        )
      ),
    );
  }
}
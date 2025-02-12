import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:looneytube/application/local_storage.dart';
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
  late VlcPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  late double _lastDoubleTapX;

  @override
  void initState() {
    Wakelock.enable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _controller = VlcPlayerController.network(
      widget.videoUrl
    );

    storeSingle(widget.videoUrl, 'watched', 'watched');

    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {
        storeSingle('video', 'last', widget.videoUrl);
        _controller.play();
      });
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
      await _controller.seekTo((await _controller.getPosition()) - const Duration(seconds: 30));
    }
    void _forward () async {
      await _controller.seekTo((await _controller.getPosition()) + const Duration(seconds: 30));
    }
    Stack _getStack() {
      final screenSize = MediaQuery.of(context).size;

      return Stack(children: [
        VlcPlayer(
            controller: _controller,
            aspectRatio: screenSize.width / screenSize.height,
            placeholder: const Center(
              child: CircularProgressIndicator(color: Colors.redAccent),
            ),
        ),
      ]);
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
                      aspectRatio: 16 / 9,
                      child: _getStack(),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.redAccent),
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
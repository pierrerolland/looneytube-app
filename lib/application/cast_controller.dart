import 'dart:async';

import 'package:cast/cast.dart';
import 'package:looneytube/application/cast_messenger.dart';
import 'package:looneytube/application/client.dart';
import 'package:looneytube/application/local_storage.dart';

class CastController {
  bool _sessionSet = false;

  bool _videoLoaded = false;

  CastController({
    required this.sessionStartedListener,
    required this.sessionEndedListener,
  });

  final Function sessionStartedListener;

  final Function sessionEndedListener;

  late CastSession _session;

  late CastMessenger _messenger;

  Future<void> startSession(CastDevice device) async {
    _session = await CastSessionManager().startSession(device);

    _messenger = CastMessenger(session: _session);

    _sessionSet = true;

    _session.stateStream.listen((state) {
      if (state == CastSessionState.closed) {
        _videoLoaded = false;
        sessionEndedListener();
      }
    });

    _session.messageStream.listen((message) async {
      if (message['type'] == 'RECEIVER_STATUS' && !_videoLoaded) {
        if (message['status'] != null && message['status']['applications'] != null) {
          final app = message['status']['applications'][0];

          if (app != null && app['namespaces'] != null) {
            for (var namespace in app['namespaces']) {
              if (namespace['name'] == CastSession.kNamespaceMedia) {
                sessionStartedListener();

                loadLastStored();

                return;
              }
            }
          }
        }
      }
    });

    _messenger.launch();
  }

  Future<void> endSession() async {
    await _session.close();
    _sessionSet = false;
  }

  loadMedia(String videoUrl, String? imageUrl, String title) async {
    final videoTrueUrl = await fetchRedirectionUrl(videoUrl);
    var imageTrueUrl = imageUrl;

    if (imageUrl != null) {
      imageTrueUrl = await fetchRedirectionUrl(imageUrl);
    }

    _messenger.loadMedia(videoTrueUrl, imageTrueUrl, title);

    _videoLoaded = true;
  }

  loadLastStored() async {
    final videoUrl = await getSingleFromLocalStorage('last-video', 'video-url');
    final imageUrl = await getSingleFromLocalStorage('last-video', 'image-url');
    final title = await getSingleFromLocalStorage('last-video', 'title');

    if (videoUrl != null) {
      loadMedia(videoUrl, imageUrl, title ?? '');
    }
  }

  isSessionConnected () {
    return _sessionSet && _session.state == CastSessionState.connected;
  }
}

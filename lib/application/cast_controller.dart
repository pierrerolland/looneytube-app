import 'dart:async';

import 'package:cast/cast.dart';
import 'package:looneytube/application/cast_messenger.dart';
import 'package:looneytube/application/client.dart';
import 'package:looneytube/application/local_storage.dart';

class CastController {
  bool _sessionSet = false;

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
        sessionEndedListener();
      }
    });

    _session.messageStream.listen((message) {
      if (message['type'] == 'RECEIVER_STATUS') {
        if (message['status'] != null && message['status']['applications'] != null) {
          final app = message['status']['applications'][0];

          if (app != null && app['namespaces'] != null) {
            for (var namespace in app['namespaces']) {
              if (namespace['name'] == CastSession.kNamespaceMedia) {
                sessionStartedListener();

                getSingleFromLocalStorage('video', 'last').then((String? videoUrl) {
                  if (videoUrl != null) {
                    loadMedia(videoUrl);
                  }
                });

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

  loadMedia(String videoUrl) async {
    final url = await fetchRedirectionUrl(videoUrl);

    _messenger.loadMedia(url);
  }

  isSessionConnected () {
    return _sessionSet && _session.state == CastSessionState.connected;
  }
}

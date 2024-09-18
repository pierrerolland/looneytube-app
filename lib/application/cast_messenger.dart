import 'package:cast/cast.dart';

class CastMessenger {
  CastMessenger({
    required this.session
  });

  final CastSession session;

  int _castRequestId = 1;

  launch() {
    session.sendMessage(CastSession.kNamespaceReceiver, {
      'type': 'LAUNCH',
      'appId': '0C0DAC2A',
    });
  }

  loadMedia(String mediaUrl, String? imageUrl, String title) {
    Map<String, dynamic> message = {
      'requestId': _id(),
      'type': 'LOAD',
      'media': {
        'contentId': mediaUrl,
        'streamType': 'BUFFERED',
        'contentType': 'video/mp4',
        'metadata': {
          'metadataType': 0,
          'title': title,
          'images': [{
            'url': imageUrl
          }]
        },
      },
      'autoplay': true,
      'currentTime': 0,
    };

    session.sendMessage(CastSession.kNamespaceMedia, message);
  }

  _id() {
    return (_castRequestId++);
  }
}

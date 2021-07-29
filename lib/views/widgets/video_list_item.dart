import 'package:flutter/material.dart';
import 'package:looneytube/application/entities/video.dart';

class VideoListItemWidget extends StatelessWidget {
  const VideoListItemWidget({Key? key, required this.video, required this.onTap}) : super(key: key);

  final Video video;

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          onTap(video);
        },
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 128,
                height: 128,
                child: Image.network(
                  video.picture ?? '',
                  height: 128,
                ),
                margin: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8))
                ),
              ),
              Expanded(
                  child: Text(
                    video.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
              )
            ],
          ),
          decoration: const BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 1, offset: Offset(2, 1))],
              color: Colors.white
          ),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
        )
    );
  }
}

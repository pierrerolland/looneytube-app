import 'package:flutter/material.dart';
import 'package:looneytube/application/entities/video.dart';
import 'package:looneytube/application/local_storage.dart';

class VideoListItemWidget extends StatefulWidget {
  const VideoListItemWidget({Key? key, required this.video, required this.onTap}) : super(key: key);

  final Video video;

  final Function onTap;

  @override
  _VideoListItemWidgetState createState() => _VideoListItemWidgetState();
}

class _VideoListItemWidgetState extends State<VideoListItemWidget> {
  bool _watched = false;

  @override
  void initState() {
    getSingleFromLocalStorage(widget.video.fileName, 'watched').then((v) => {
      setState(() {
        _watched = v == 'watched';
      })
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          widget.onTap(widget.video);
        },
        child: Container(
          height: 128,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                  child: Text(
                    widget.video.name,
                    style: const TextStyle(
                      color: Colors.white,
                      backgroundColor: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )
              )
            ],
          ),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(widget.video.picture ?? ''),
                  fit: BoxFit.cover
              ),
              boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 1, offset: Offset(2, 1))],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _watched ? Colors.green : Colors.white, width: 2)
          ),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
        )
    );
  }
}

import 'package:flutter/material.dart';
import 'package:looneytube/application/entities/video.dart';
import 'package:looneytube/views/pages/video.dart';
import 'package:looneytube/views/widgets/video_list.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({Key? key, required this.categorySlug}) : super(key: key);

  final String categorySlug;

  @override
  Widget build(BuildContext context) {
    void _handleVideoTap(Video video) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return VideoPage(videoUrl: video.fileName);
        }),
      );
    }

    return Scaffold(
      body: Center(
        child: ListView(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(20),
                child: Image.asset(
                  'images/logo.png',
                  alignment: AlignmentDirectional.center,
                  height: 64,
                )
            ),
            VideoListWidget(onVideoTap: _handleVideoTap, categorySlug: categorySlug)
          ],
        ),
      ),
    );
  }
}

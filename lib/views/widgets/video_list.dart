import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:looneytube/application/client.dart';
import 'package:looneytube/application/entities/category.dart';
import 'package:looneytube/views/widgets/video_list_item.dart';

class VideoListWidget extends StatefulWidget {
  const VideoListWidget({Key? key, required this.categorySlug, required this.onVideoTap}) : super(key: key);

  final String categorySlug;
  final Function onVideoTap;

  @override
  _VideoListWidgetState createState() => _VideoListWidgetState();
}

class _VideoListWidgetState extends State<VideoListWidget> {
  late Future<Category> futureCategory;

  @override
  void initState() {
    super.initState();
    futureCategory = fetchCategory(widget.categorySlug);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Category>(
        future: futureCategory,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Expanded(child: Column(
                children: [
                  Text(snapshot.data!.name, style: Theme.of(context).textTheme.headlineMedium),
                  GridView.count(
                    shrinkWrap: true,
                    childAspectRatio: 4,
                    crossAxisCount: 2,
                    children: snapshot.data!.videos!.map((e) => VideoListItemWidget(video: e, onTap: widget.onVideoTap)).toList(),
                  ),
                ]
            ));
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return Column(children: const [CircularProgressIndicator()]);
        }
    );
  }
}

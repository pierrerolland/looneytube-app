import 'dart:math';

import 'package:flutter/material.dart';
import 'package:looneytube/application/client.dart';
import 'package:looneytube/application/entities/category.dart';
import 'package:looneytube/application/entities/video.dart';
import 'package:looneytube/views/widgets/video_list_item.dart';

class VideoListWidget extends StatefulWidget {
  static const itemsPerPage = 12;
  const VideoListWidget({Key? key, required this.categorySlug, required this.onVideoTap}) : super(key: key);

  final String categorySlug;
  final Function onVideoTap;

  @override
  _VideoListWidgetState createState() => _VideoListWidgetState();
}

class _VideoListWidgetState extends State<VideoListWidget> {
  late Future<Category> futureCategory;
  List<Video> allVideos = [];
  int page = 1;
  int totalPages = 1;

  List<Video> currentPageVideos() {
    return allVideos.sublist(
        (page - 1) * VideoListWidget.itemsPerPage,
        min(allVideos.length, (page - 1) * VideoListWidget.itemsPerPage + VideoListWidget.itemsPerPage)
    );
  }

  @override
  void initState() {
    super.initState();
    futureCategory = fetchCategory(widget.categorySlug);
    futureCategory.then((category) => {
        setState(() {
          allVideos = category.videos!;
          totalPages = category.videos!.length == (category.videos!.length / VideoListWidget.itemsPerPage).floor() * VideoListWidget.itemsPerPage
              ? (category.videos!.length / VideoListWidget.itemsPerPage).floor()
              : (category.videos!.length / VideoListWidget.itemsPerPage).ceil();
        })
    });
  }

  Widget buildPaginationButtons() {
    List<IconButton> children = [];

    if (page > 1) {
      children.add(
          IconButton(
            icon: const Icon(Icons.arrow_left),
            tooltip: 'Page précédente',
            onPressed: () {
              setState(() {
                page--;
              });
            },
          )
      );
    }

    if (page < totalPages) {
      children.add(
          IconButton(
            icon: const Icon(Icons.arrow_right),
            tooltip: 'Page suivante',
            onPressed: () {
              setState(() {
                page++;
              });
            },
          )
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Category>(
        future: futureCategory,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
                children: [
                  Text(snapshot.data!.name, style: Theme.of(context).textTheme.headlineMedium),
                  GridView.count(
                    shrinkWrap: true,
                    childAspectRatio: 2,
                    crossAxisCount: 4,
                    children: currentPageVideos().map((e) => VideoListItemWidget(video: e, onTap: widget.onVideoTap)).toList(),
                  ),
                  buildPaginationButtons()
                ]
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return Column(children: const [CircularProgressIndicator()]);
        }
    );
  }
}

import 'package:flutter/material.dart';
import 'package:looneytube/application/client.dart';
import 'package:looneytube/application/entities/category.dart';
import 'package:looneytube/views/widgets/category_list_item.dart';

class CategoryListWidget extends StatefulWidget {
  const CategoryListWidget({Key? key, required this.onCategoryTap}) : super(key: key);

  final Function onCategoryTap;

  @override
  _CategoryListWidgetState createState() => _CategoryListWidgetState();
}

class _CategoryListWidgetState extends State<CategoryListWidget> {
  late Future<List<Category>> futureCollection;

  @override
  void initState() {
    super.initState();
    futureCollection = fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
        future: futureCollection,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
                children: snapshot.data!.map((e) => CategoryListItemWidget(category: e, onTap: widget.onCategoryTap)).toList()
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return Column(children: const [CircularProgressIndicator()]);
        }
    );
  }
}

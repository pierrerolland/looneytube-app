import 'package:flutter/material.dart';
import 'package:looneytube/application/entities/category.dart';
import 'package:looneytube/views/pages/category.dart';
import 'package:looneytube/views/widgets/category_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _handleCategoryTap(Category category) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return CategoryPage(categorySlug: category.slug);
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
            CategoryListWidget(onCategoryTap: _handleCategoryTap)
          ],
        ),
      ),
    );
  }
}

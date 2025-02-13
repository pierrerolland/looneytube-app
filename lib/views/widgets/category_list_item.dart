import 'package:flutter/material.dart';
import 'package:looneytube/application/entities/category.dart';

class CategoryListItemWidget extends StatelessWidget {
  const CategoryListItemWidget({Key? key, required this.category, required this.onTap}) : super(key: key);

  final Category category;

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap(category);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 1),
        child: Container(
          width: 36,
          height: 36,
          margin: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8))
          ),
          child: Image.network(
            category.picture ?? '',
            height: 36,
            semanticLabel: category.name,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Column(
                children: [
                  CircularProgressIndicator(
                    color: Colors.white54,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                  Text(category.name, style: TextStyle(fontSize: 7),)
                ],
              );
            },
          ),
        ),
      )
    );
  }
}

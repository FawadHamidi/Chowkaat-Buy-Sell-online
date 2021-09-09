import 'package:chowkaat/provider/firebase_provider.dart';
import 'package:chowkaat/screens/sub_category_screen/sub_category_screen.dart';
import 'package:chowkaat/utilis/my_colors.dart';
import 'package:flutter/material.dart';

class CategoryListCard extends StatefulWidget {
  CategoryListCard({
    Key? key,
    required this.provider,
  });

  final DataProvider provider;

  @override
  _CategoryListCardState createState() => _CategoryListCardState();
}

class _CategoryListCardState extends State<CategoryListCard> {
  List _iconList = [
    Icons.phone_android,
    Icons.location_city,
    Icons.directions_car,
    Icons.format_paint,
    Icons.home,
    Icons.watch_rounded,
    Icons.videogame_asset,
    Icons.shopping_bag,
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 15, left: 10, right: 10),
        height: 100,
        color: Colors.grey.withOpacity(0.1),
        child: ListView.builder(
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: widget.provider.categoryList?.length,
          itemBuilder: (context, index) {
            return Container(
              child: Column(
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: kBlackish,
                          borderRadius: BorderRadius.circular(100)),
                      child: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SubCategories(id: 1,
                                          model: widget
                                              .provider.categoryList![index],
                                        )));
                          },
                          icon: Icon(
                            _iconList[index],
                            color: kWhite,
                          ))),
                  SizedBox(
                    width: 90,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(widget.provider.categoryList?[index].name ?? ''),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

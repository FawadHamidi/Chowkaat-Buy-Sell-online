import 'package:chowkaat/provider/firebase_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/category_list_card.dart';
import 'components/product_list_card.dart';

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  Future? categories;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var provider = Provider.of<DataProvider>(context, listen: false);
    categories = provider.loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<DataProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: categories,
      builder: (context, snapShot) {
        return snapShot.data != null
            ? Column(
                children: [
                  CategoryListCard(
                    provider: provider,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'پیشنهاد ها',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ProductListCard()
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}

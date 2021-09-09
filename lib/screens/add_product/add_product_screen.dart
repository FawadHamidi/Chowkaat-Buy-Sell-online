import 'package:chowkaat/provider/firebase_provider.dart';
import 'package:chowkaat/screens/sub_category_screen/sub_category_screen.dart';
import 'package:chowkaat/utilis/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
          backgroundColor: kBlackish,
          title: Text('چی می خواهید عرضه کنید؟'),
        ),
        body: FutureBuilder(
            future: categories,
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.done
                  ? Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          itemCount: provider.categoryList!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                provider.category = provider.categoryList![index].name;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SubCategories(
                                            id: 2,
                                            model: provider
                                                .categoryList![index])));
                              },
                              child: Card(
                                color: kBlackish,
                                child: Center(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _iconList[index],
                                      color: kWhite,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      provider.categoryList![index].name ?? '',
                                      style: TextStyle(color: kWhite),
                                    ),
                                  ],
                                )),
                              ),
                            );
                          }),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    );
            }),
      ),
    );
  }
}

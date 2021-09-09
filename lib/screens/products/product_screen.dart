import 'package:chowkaat/models/product_model.dart';
import 'package:chowkaat/provider/firebase_provider.dart';
import 'package:chowkaat/screens/product_detail/product_detail_screen.dart';
import 'package:chowkaat/utilis/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatefulWidget {
  final String subCategory;

  ProductsScreen({required this.subCategory});

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  Future? getFilteredProducts;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var provider = Provider.of<DataProvider>(context, listen: false);
    getFilteredProducts = provider.loadFilteredProducts(widget.subCategory);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var provider = Provider.of<DataProvider>(context, listen: false);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: kWhite,
          appBar: AppBar(
            backgroundColor: kBlackish,
            title: Text(
              widget.subCategory,
            ),
          ),
          body: FutureBuilder(
            future: getFilteredProducts,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(
                      color: kBlackish,
                    ),
                  );
                default:
                  if (provider.filteredProductList!.isEmpty) {
                    return Center(
                        child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/nodata.png',
                          scale: 6,
                        ),
                        Positioned(
                            top: 270,
                            right: 120,
                            child: Text(
                              'تبلیغی موخود نیست',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: kBlackish),
                            )),
                      ],
                    ));
                  } else if (snapshot.hasData) {
                    return Column(
                      children: List.generate(
                        provider.filteredProductList!.length,
                        (index) => InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductDetailScreen(
                                          product: provider
                                              .filteredProductList![index],
                                        )));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: kWhite,
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey.withOpacity(0.3),
                                        style: BorderStyle.solid))),
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: size.width / 2.5,
                                    width: size.width / 2.5,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            provider.filteredProductList![index]
                                                .images![0],
                                          ),
                                        )),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 200,
                                          height: 50,
                                          child: Text(
                                            provider.filteredProductList![index]
                                                    .name ??
                                                '',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          width: 200,
                                          height: 50,
                                          child: Text(
                                            ' قیمت: ${provider.filteredProductList![index].price}افغانی  ',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            'لحظاتی پیش در هرات',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}

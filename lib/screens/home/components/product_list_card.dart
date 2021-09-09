import 'package:chowkaat/models/product_model.dart';
import 'package:chowkaat/provider/firebase_provider.dart';
import 'package:chowkaat/screens/global_components/image_place_holder.dart';
import 'package:chowkaat/screens/product_detail/product_detail_screen.dart';
import 'package:chowkaat/utilis/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:intl/intl.dart' as intl;

class ProductListCard extends StatefulWidget {
  const ProductListCard({
    Key? key,
  }) : super(key: key);

  @override
  _ProductListCardState createState() => _ProductListCardState();
}

class _ProductListCardState extends State<ProductListCard> {
  Future? products;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var provider = Provider.of<DataProvider>(context, listen: false);
    products = provider.loadProducts();

    // Gregorian g = Gregorian(2002, 03, 04);
    // var gg = g.toJalali().toString();
    //
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<DataProvider>(context, listen: false);

    var size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: products!,
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? Column(
                  children:
                      List.generate(provider.productList!.length, (index) {
                    var date = intl.DateFormat('yyyy-MM-dd')
                        .format(provider.productList![index].date!.toDate());
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductDetailScreen(
                                      product: provider.productList![index],
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
                            MyImagePlaceHolder(
                              height: size.width / 2.5,
                              width: size.width / 2.5,
                              imageLink:
                                  provider.productList![index].images![0],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 200,
                                      height: 50,
                                      child: Text(
                                        provider.productList![index].name ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                    Container(
                                      width: 200,
                                      height: 50,
                                      child: Text(
                                        ' قیمت: ${provider.productList![index].price} افغانی  ',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        'تاریخ: ${date}  ',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        });
  }
}

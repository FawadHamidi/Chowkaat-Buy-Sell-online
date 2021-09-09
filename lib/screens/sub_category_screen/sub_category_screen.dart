import 'package:chowkaat/models/category_model.dart';
import 'package:chowkaat/provider/firebase_provider.dart';
import 'package:chowkaat/screens/add_product/add_product_details.dart';
import 'package:chowkaat/screens/products/product_screen.dart';
import 'package:chowkaat/utilis/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubCategories extends StatefulWidget {
  Category? model;
  int? id;

  SubCategories({this.model, this.id});

  @override
  _SubCategoriesState createState() => _SubCategoriesState();
}

class _SubCategoriesState extends State<SubCategories> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var provider = Provider.of<DataProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<DataProvider>(context, listen: false);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kBlackish,
            title: Text(
              widget.model?.name ?? '',
            ),
          ),
          body: Container(
            child: ListView.builder(
              itemCount: widget.model!.subCategory!.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    if (widget.id == 2) {
                      provider.subCategory = widget.model?.subCategory?[index];
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddProductDetails()));
                    } else if (widget.id == 1) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductsScreen(
                                  subCategory:
                                      widget.model!.subCategory?[index])));
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Colors.grey.withOpacity(0.1),
                              style: BorderStyle.solid)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: ListTile(
                      title: Text(
                        widget.model?.subCategory?[index],
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

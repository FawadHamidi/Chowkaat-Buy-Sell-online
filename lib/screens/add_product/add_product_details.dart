import 'package:chowkaat/models/product_model.dart';
import 'package:chowkaat/models/user_model.dart';
import 'package:chowkaat/provider/firebase_provider.dart';
import 'package:chowkaat/provider/images_provider.dart';
import 'package:chowkaat/screens/landing/landing_screen.dart';
import 'package:chowkaat/screens/user_products/user_products.dart';
import 'package:chowkaat/services/share_services.dart';
import 'package:chowkaat/utilis/constants.dart';
import 'package:chowkaat/utilis/my_colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:provider/provider.dart';

import 'components/my_text_field.dart';
import 'components/pick_images_card.dart';

class AddProductDetails extends StatefulWidget {
  @override
  _AddProductDetailsState createState() => _AddProductDetailsState();
}

class _AddProductDetailsState extends State<AddProductDetails> {
  Product? _productModel;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController? _phoneNumberController = TextEditingController();
  String? value = 'هرات';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _productModel = Product();
    var provider = Provider.of<DataProvider>(context, listen: false);

    // print('${provider.imageUrls[0]}####################');
  }

  bool _isLoading = false;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<DataProvider>(context, listen: false);
    Future<UserModel?> getUserData = UserPreferences().getUser();
    var size = MediaQuery.of(context).size;
    return ChangeNotifierProvider<PhotoProvider>(
        create: (context) => PhotoProvider(),
        builder: (context, widget) {
          var imageProvider =
              Provider.of<PhotoProvider>(context, listen: false);
          return Directionality(
            textDirection: TextDirection.rtl,
            child: SafeArea(
              child: Scaffold(
                key: scaffoldKey,
                backgroundColor: kWhite,
                appBar: AppBar(
                  backgroundColor: kBlackish,
                  title: Text('ثبت تبلیغ'),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomImagePicker(),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              MyTextField(
                                controller: _nameController,
                                maxLines: 1,
                                title: 'عنوان تبلیغ',
                                textInputType: TextInputType.text,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              MyTextField(
                                controller: _priceController,
                                maxLines: null,
                                title: 'قیمت',
                                textInputType: TextInputType.number,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              MyTextField(
                                controller: _phoneNumberController,
                                maxLines: null,
                                title: 'شماره تماس',
                                textInputType: TextInputType.number,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: Text(
                                        'شهر',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      )),
                                  Container(
                                    width: size.width - 10,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            width: 1, color: kBlackish)),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: value,
                                        items: kCities.map((String item) {
                                          return DropdownMenuItem<String>(
                                            value: item,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Text(
                                                item,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            this.value = value;
                                            // snapshot.data!
                                            //     .userCity = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  MyTextField(
                                    height: 150,
                                    controller: _descController,
                                    maxLines: null,
                                    title: 'توضیحات',
                                    textInputType: TextInputType.text,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  FutureBuilder<UserModel?>(
                                      future: getUserData,
                                      builder: (context, snapshot) {
                                        return Container(
                                          width: size.width,
                                          height: 50,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: kBlackish,
                                                  elevation: 0),
                                              onPressed: () async {
                                                setState(() {
                                                  _isLoading = true;
                                                });
                                                await imageProvider
                                                    .uploadFiles();
                                                _productModel?.name =
                                                    _nameController.text;
                                                _productModel?.price =
                                                    _priceController.text;
                                                _productModel?.description =
                                                    _descController.text;
                                                _productModel?.city =
                                                    this.value;
                                                _productModel?.images =
                                                    imageProvider.imageUrlList;
                                                _productModel?.userName =
                                                    snapshot.data!.userName;
                                                _productModel!.userPhoto =
                                                    snapshot.data!.userPhoto;
                                                _productModel?.userUid =
                                                    snapshot.data!.userUid;
                                                _productModel?.category =
                                                    provider.category;
                                                _productModel?.subCategory =
                                                    provider.subCategory;
                                                _productModel?.userPhoneNumber =
                                                    _phoneNumberController
                                                        ?.text;
                                                await provider
                                                    .addProduct(_productModel!);
                                                setState(() {
                                                  _isLoading = false;
                                                });
                                                showSnackBar();
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LandingScreen()));
                                              },
                                              child: _isLoading
                                                  ? Container(
                                                      height: 20,
                                                      width: 20,
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: kWhite,
                                                      ))
                                                  : Text(
                                                      'ذخیره',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16),
                                                    )),
                                        );
                                      })
                                ],
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
        });
  }

  void showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        shape: StadiumBorder(),
        behavior: SnackBarBehavior.floating,
        content: Text("تبلیغ شما فرستاده شد.")));
  }
}

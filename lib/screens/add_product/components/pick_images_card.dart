import 'package:chowkaat/provider/firebase_provider.dart';
import 'package:chowkaat/provider/images_provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class CustomImagePicker extends StatefulWidget {
  @override
  _CustomImagePickerState createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  List<XFile>? _images = [];
  ImagePicker _picker = ImagePicker();
  bool isLoading = false;
  // List<Asset> images = <Asset>[];
  // String _error = 'No Error Dectected';
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Row(
            children: [
              InkWell(
                onTap: () async {
                  await getPhoto();
                },
                child: DottedBorder(
                    radius: Radius.circular(15),
                    strokeCap: StrokeCap.round,
                    strokeWidth: 2,
                    borderType: BorderType.RRect,
                    dashPattern: [5, 5, 5, 5],
                    child: Container(
                      child: Center(
                        child: Icon(Icons.add_a_photo),
                      ),
                      height: 70,
                      width: 70,
                    )),
              ),
              SizedBox(
                width: 10,
              ),
              _images!.isEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'انتخاب عکس های تبلیغ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          'شش عدد عکس برای تبلیغ خود وارد کنید',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    )
                  : Expanded(
                      child: Container(
                        height: 90,
                        width: 300,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _images!.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.all(5),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: FileImage(
                                            File(
                                              _images![index].path,
                                            ),
                                          ),
                                        ),
                                      )
                                      // child: Image.file(
                                      //   File(
                                      //     _images![index].path,
                                      //   ),
                                      //   fit: BoxFit.cover,
                                      // ),
                                      ),
                                ),
                              );
                            }),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  getPhoto() async {
    try {
      var provider = Provider.of<PhotoProvider>(context, listen: false);
      _images = await _picker.pickMultiImage();
      provider.imagesList = _images!;
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  // Future<void> loadAssets() async {
  //   List<Asset> resultList = <Asset>[];
  //   String error = 'No Error Detected';
  //   var provider = Provider.of<DataProvider>(context, listen: false);
  //   try {
  //     resultList = await MultiImagePicker.pickImages(
  //       maxImages: 6,
  //       enableCamera: true,
  //       selectedAssets: images,
  //       cupertinoOptions: CupertinoOptions(
  //         takePhotoIcon: "chat",
  //         doneButtonTitle: "Fatto",
  //       ),
  //       materialOptions: MaterialOptions(
  //         actionBarColor: "#abcdef",
  //         actionBarTitle: "Example App",
  //         allViewTitle: "All Photos",
  //         useDetailsView: false,
  //         selectCircleStrokeColor: "#000000",
  //       ),
  //     );
  //   } on Exception catch (e) {
  //     error = e.toString();
  //   }
  //
  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;
  //
  //   setState(() {
  //     images = resultList;
  //     print(resultList[0].name);
  //     _error = error;
  //   });
  // }
}

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PhotoProvider extends ChangeNotifier {
  List<XFile> imagesList = [];
  List<String>? imageUrlList = [];

  Future<List<dynamic>?> uploadFiles() async {
    var imagePaths = await Future.wait(
        imagesList.map((_image) => uploadImageToFirebase(_image)));
    return imagePaths;
  }

  Future uploadImageToFirebase(XFile _image) async {
    var storageReference =
        FirebaseStorage.instance.ref().child('posts/${_image.name}');
    var uploadTask = storageReference.putFile(File(_image.path));
    await uploadTask.whenComplete(() async {
      getImages(await storageReference.getDownloadURL());
      notifyListeners();
    });
  }

  //
  getImages(url) async {
    this.imageUrlList!.add(url);
    notifyListeners();
    return imageUrlList;
  }
}

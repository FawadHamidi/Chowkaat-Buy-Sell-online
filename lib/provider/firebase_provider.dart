import 'package:chowkaat/models/category_model.dart';
import 'package:chowkaat/models/chat_model.dart';
import 'package:chowkaat/models/chat_room_model.dart';
import 'package:chowkaat/models/product_model.dart';
import 'package:chowkaat/models/user_model.dart';
import 'package:chowkaat/services/firestore_services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'dart:io';

class DataProvider extends ChangeNotifier {
  List<Category>? categoryList;
  List<Product>? productList;
  List<Product>? filteredProductList;
  List<Product>? userProducts;

  String? userUid;
  String? phoneNumber;
  String? userName;
  String? userPhoto;
  String? category;
  String? subCategory;
  String? userCity;
  String? userBio;
  String? cityForMyAccountDropDown;

  loadCategories() async {
    try {
      categoryList = await DataServices().getCategories();
      notifyListeners();
      return categoryList;
    } catch (e) {
      print(e);
    }
  }

  // resetStream() async {
  //   imagesList = [];
  //   notifyListeners();
  // }

  loadProducts() async {
    try {
      productList = await DataServices().getProducts();
      notifyListeners();
      return productList;
    } catch (e) {
      print(e);
    }
  }

  loadFilteredProducts(String subCategory) async {
    try {
      filteredProductList =
          await DataServices().getFilteredProducts(subCategory);
      notifyListeners();
      return filteredProductList;
    } catch (e) {
      print(e);
    }
  }

  loadUserProducts(String userUid) async {
    try {
      userProducts = await DataServices().getUserProducts(userUid);
      notifyListeners();
      return userProducts;
    } catch (e) {
      print(e);
    }
  }

  addProduct(Product productModel) async {
    try {
      await DataServices().addProduct(productModel);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  addUserDetails(UserModel userModel, String userUid) async {
    try {
      await DataServices().addUser(userModel, userUid);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  updateChatRoom(ChatRoom chatRoom, String chatRoomId) async {
    try {
      await DataServices().updateChatRoom(chatRoom, chatRoomId);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  addChat(ChatModel chatModel, String chatRoom) async {
    try {
      await DataServices().addChat(chatModel, chatRoom);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  createChatRoom(String chatRoom, chatRoomInfoMap) async {
    try {
      await DataServices().createChatRoom(chatRoom, chatRoomInfoMap);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}

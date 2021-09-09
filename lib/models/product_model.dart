import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String? name;
  String? city;
  String? price;
  Timestamp? date;
  String? description;
  String? userName;
  int? id;
  List<dynamic>? images;
  String? userPhoto;
  String? userUid;
  String? category;
  String? subCategory;
  String? userPhoneNumber;
  Product(
      {this.name,
      this.city,
      this.category,
      this.price,
      this.date,
      this.subCategory,
      this.description,
      this.userName,
      this.id,
      this.userPhoneNumber,
      this.images,
      this.userUid,
      this.userPhoto});

  Product.fromMap(Map<dynamic, dynamic> data) {
    name = data['name'];
    city = data['city'];
    id = data['id'];
    date = data['date'];
    description = data['description'];
    userName = data['user_name'];
    userPhoto = data['user_photo'];
    price = data['price'];
    images = data['images'];
    userUid = data['user_uid'];
    category = data['category'];
    subCategory = data['sub_category'];
    userPhoneNumber = data['user_phone_number'];
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? userName;
  String? userUid;
  String? phoneNumber;
  Timestamp? date;
  String? userPhoto;
  String? userBio;
  String? userCity;

  UserModel(
      {this.userName,
      this.userUid,
      this.userBio,
      this.phoneNumber,
        this.userCity,
      this.date,
      this.userPhoto});

  UserModel.fromMap(Map<dynamic, dynamic> data) {
    userName = data['user_name'];
    userBio = data['user_bio'];
    userPhoto = data['user_photo'];
    date = data['date'];
    userUid = data['user_uid'];
    userCity = data['user_city'];
  }
}

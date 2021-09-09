import 'package:chowkaat/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  Future<bool> saveUser(UserModel model) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("user_name", model.userName!);
    prefs.setString("user_bio", model.userBio ?? '');
    prefs.setString("user_photo", model.userPhoto ?? '');
    prefs.setString("user_uid", model.userUid ?? '');
    prefs.setString("user_city", model.userCity ?? '');
    prefs.setString("phone_number", model.phoneNumber ?? '');
    return prefs.commit();
  }

  Future<UserModel> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userName = prefs.getString("user_name");
    String? userBio = prefs.getString("user_bio");
    String? userPhoto = prefs.getString("user_photo");
    String? userUid = prefs.getString("user_uid");
    String? userCity = prefs.getString("user_city");
    String? phoneNumber = prefs.getString("phone_number");

    return UserModel(
        userName: userName,
        userBio: userBio,
        userPhoto: userPhoto,
        userUid: userUid,
        userCity: userCity,
        phoneNumber: phoneNumber);
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("user_name");
    prefs.remove('user_bio');
    prefs.remove("user_photo");
    prefs.remove("user_uid");
    prefs.remove("user_city");
    prefs.remove("phone_number");
  }

  Future<String> getUserUid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userUid = prefs.getString("user_uid");
    return userUid ?? "";
  }

  Future<bool> setUserName(String userName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user_name", userName);
    return prefs.commit();
  }

  Future<String> getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString("user_name");
    return userName ?? "";
  }

  Future<String> getUserPhoto() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userPhoto = prefs.getString("user_photo");
    return userPhoto ?? "";
  }

  Future<String> getUserBio() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userBio = prefs.getString("user_bio");
    return userBio ?? "";
  }

  Future<bool> setUserBio(String userBio) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user_bio", userBio);
    return prefs.commit();
  }

  Future<String> getUserCity() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userCity = prefs.getString("user_city");
    return userCity ?? "";
  }

  Future<bool> setUserCity(String userCity) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user_city", userCity);
    return prefs.commit();
  }

  Future<String> getUserNumber() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userNumber = prefs.getString("phone_number");
    return userNumber ?? "";
  }
}

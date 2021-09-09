import 'package:chowkaat/models/category_model.dart';
import 'package:chowkaat/models/chat_model.dart';
import 'package:chowkaat/models/chat_room_model.dart';
import 'package:chowkaat/models/product_model.dart';
import 'package:chowkaat/models/user_model.dart';
import 'package:chowkaat/services/share_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DataServices {
  Future<List<Category>?> getCategories() async {
    List<Category> _categoryList = [];
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('categories')
          .orderBy('id')
          .get();
      snapshot.docs.forEach((element) {
        Category category =
            Category.fromMap(element.data() as Map<String, dynamic>);
        _categoryList.add(category);
      });

      return _categoryList;
    } catch (e) {
      print(e);
    }
  }

  Future<List<Product>?> getFilteredProducts(String subCategory) async {
    List<Product> _productList = [];
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where(
            "sub_category",
            isEqualTo: "$subCategory",
          )
          .get();
      snapshot.docs.forEach((element) {
        Product product =
            Product.fromMap(element.data() as Map<String, dynamic>);
        _productList.add(product);
      });

      return _productList;
    } catch (e) {
      print(e);
    }
  }

  Future<List<Product>?> getProducts() async {
    var myUid = await UserPreferences().getUserUid();
    List<Product> _productList = [];
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where("user_uid", isNotEqualTo: myUid)
          .get();
      snapshot.docs.forEach((element) {
        Product product =
            Product.fromMap(element.data() as Map<String, dynamic>);
        _productList.add(product);
      });

      return _productList;
    } catch (e) {
      print(e);
    }
  }

  Future<Product?> addProduct(Product? productModel) async {
    try {
      var snapshot =
          FirebaseFirestore.instance.collection('products').doc().set({
        'name': productModel!.name,
        'city': productModel.city,
        'date': DateTime.now(),
        'description': productModel.description,
        'user_name': productModel.userName,
        'user_photo': productModel.userPhoto,
        'price': productModel.price,
        'images': productModel.images,
        'user_uid': productModel.userUid,
        'category': productModel.category,
        'sub_category': productModel.subCategory,
        'user_phone_number': productModel.userPhoneNumber,
      });

      // snapshot.add({
      //   'name': productModel!.name,
      //   'city': productModel.city,
      //   'date': DateTime.now(),
      //   'description': productModel.description,
      //   'user_name': productModel.userName,
      //   'user_photo': productModel.userPhoto,
      //   'price': productModel.price,
      //   'images': productModel.images,
      //   'user_uid': productModel.userUid,
      //   'category': productModel.category,
      //   'sub_category': productModel.subCategory,
      //   'user_phone_number': productModel.userPhoneNumber,
      // });

      return productModel;
    } catch (e) {
      print(e);
    }
  }

  Future<UserModel?> addUser(UserModel? userModel, String userUid) async {
    try {
      var snapshot =
          FirebaseFirestore.instance.collection('users').doc(userUid).set({
        'user_name': userModel!.userName,
        'date': DateTime.now(),
        'phone_number': userModel.phoneNumber,
        'user_photo': userModel.userPhoto,
        'user_uid': userModel.userUid,
        'user_city': userModel.userCity,
        'user_bio': userModel.userBio,
      });

      // snapshot.add({
      //   'user_name': userModel!.userName,
      //   'date': DateTime.now(),
      //   'phone_number': userModel.phoneNumber,
      //   'user_photo': userModel.userPhoto,
      //   'user_uid': userModel.userUid,
      //   'user_city': userModel.userCity,
      //   'user_bio': userModel.userBio,
      // });

      return userModel;
    } catch (e) {
      print(e);
    }
  }

  Future<QuerySnapshot<Object?>?> getUser(String userNumber) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where("phone_number", isEqualTo: "$userNumber")
          .get();

      return snapshot;
    } catch (e) {
      print(e);
    }
  }

  Future<List<Product>?> getUserProducts(String userUid) async {
    List<Product> _productList = [];
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where(
            "user_uid",
            isEqualTo: "$userUid",
          )
          .get();
      snapshot.docs.forEach((element) {
        Product product =
            Product.fromMap(element.data() as Map<String, dynamic>);
        _productList.add(product);
      });

      return _productList;
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateChatRoom(ChatRoom? chatRoom, String chatRoomId) async {
    try {
      FirebaseFirestore.instance
          .collection('chatRooms')
          .doc(chatRoomId)
          .update({
        'last_message': chatRoom!.lastMessage,
        'last_message_ts': DateTime.now(),
        'last_message_sendby': chatRoom.lastMessageSendBy,
        'users': chatRoom.users,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<ChatModel?> addChat(ChatModel? chatModel, String chatRoomId) async {
    try {
      CollectionReference snapshot = FirebaseFirestore.instance
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('chats');

      snapshot.add({
        'message': chatModel!.message,
        'time_stamp': DateTime.now(),
        'sendBy': chatModel.sendBy,
      });

      return chatModel;
    } catch (e) {
      print(e);
    }
  }

  createChatRoom(
      String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoomId)
        .get();
    if (snapShot.exists) {
      return true;
    } else {
      return FirebaseFirestore.instance
          .collection("chatRooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  Future<Stream<QuerySnapshot>> getChatRoomMessages(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoomId)
        .collection('chats')
        .orderBy("time_stamp", descending: true)
        .snapshots();
  }

  Future<QuerySnapshot> getChatRooms(userUid) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection("chatRooms")
        // .orderBy("last_message_ts", descending: true)
        .where("users", arrayContains: userUid)
        .get();

    return result;
  }

  Future<QuerySnapshot?> getUserByUid(String userUid) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where("user_uid", isEqualTo: "$userUid")
          .get();

      return snapshot;
    } catch (e) {
      print(e);
    }
  }

  // update details functions
  Future<void> updateUserName(
      {required String userName, required String userUid}) async {
    try {
      FirebaseFirestore.instance.collection('users').doc(userUid).update({
        'user_name': userName,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateUserBio(
      {required String userBio, required String userUid}) async {
    try {
      FirebaseFirestore.instance.collection('users').doc(userUid).update({
        'user_bio': userBio,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateUserCity(
      {required String userCity, required String userUid}) async {
    try {
      FirebaseFirestore.instance.collection('users').doc(userUid).update({
        'user_city': userCity,
      });
    } catch (e) {
      print(e);
    }
  }
}

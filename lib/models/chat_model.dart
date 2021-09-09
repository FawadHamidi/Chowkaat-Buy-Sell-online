import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String? message;
  String? sendBy;
  Timestamp? messageTimestamp;

  ChatModel({
    this.message,
    this.sendBy,
    this.messageTimestamp,
  });

  ChatModel.fromMap(Map<dynamic, dynamic> data) {
    message = data['message'];
    sendBy = data['sendBy'];
    messageTimestamp = data['time_stamp'];
  }
}

import 'dart:convert';

ChatModel chatModelFromJson(String str) => ChatModel.fromJson(json.decode(str));

String chatModelToJson(ChatModel data) => json.encode(data.toJson());

class ChatModel {
  String? senderId;
  String? receiverId;
  String? message;
  String? status;
  String? photo_url;
  String? message_type;
  DateTime? dateTime;


  ChatModel({
    this.senderId,
    this.receiverId,
    this.message,
    this.status,
    this.dateTime,
    this.message_type,
    this.photo_url
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
    senderId: json["sender_id"],
    receiverId: json["receiver_id"],
    message: json["message"],
    status: json["status"],
    message_type: "${json["message_type"]}",
    photo_url: "${json["photo_url"]}",
    dateTime: json["dateTime"],
  );

  Map<String, dynamic> toJson() => {
    "sender_id": senderId,
    "receiver_id": receiverId,
    "message": message,
    "status": status,
    "message_type": message_type,
    "photo_url": photo_url,
    "dateTime": DateTime.timestamp().toIso8601String(),
  };
}
import 'package:flutter/material.dart';

class UserModel {
  String name;
  String email;
  String bio;
  String profilePic;
  String createdAt;
  String phoneNumber;
  String userId;

  UserModel({
    required this.name,
    required this.email,
    required this.bio,
    required this.profilePic,
    required this.createdAt,
    required this.phoneNumber,
    required this.userId});

  //from map
  factory UserModel.fromMap(Map<String, dynamic> map){
    return UserModel(
        name: map['name'] ?? '',
        email: map['email'] ?? '',
        bio: map['bio'] ?? '',
        profilePic: map['profilePic'] ?? '',
        createdAt: map['createdAt'] ?? '',
        phoneNumber: map['phoneNumber'] ?? '',
        userId: map['userId'] ?? '',
    );
  }

//  to map
  Map<String, dynamic> toMap() {
    return {
      "name" : name,
      "email" : email,
      "bio" : bio,
      "profilePic": profilePic,
      "createdAt" : createdAt,
      "phoneNumber" : phoneNumber,
      "userId" : userId,
    };

  }
}
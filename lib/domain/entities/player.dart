import 'package:flutter/material.dart';

class Player {
  final String id;
  final String nickname;
  final String fullName;
  final String contactNumber;
  final String email;
  final String address;
  final String remarks;
  final RangeValues skillLevel; // slider values

  Player({
    required this.id,
    required this.nickname,
    required this.fullName,
    required this.contactNumber,
    required this.email,
    required this.address,
    required this.remarks,
    required this.skillLevel,
  });

  static String skillLabel(double value) {
    int v = value.round();
    String level;
    if (v <= 3) {
      level = "Beginner";
    } else if (v <= 6) {
      level = "Intermediate";
    } else if (v <= 9) {
      level = "Level G";
    } else if (v <= 12) {
      level = "Level F";
    } else if (v <= 15) {
      level = "Level E";
    } else if (v <= 18) {
      level = "Level D";
    } else {
      level = "Open";
    }

    int tickIndex = (v - 1) % 3;
    String tick;
    switch (tickIndex) {
      case 0:
        tick = "Weak";
        break;
      case 1:
        tick = "Mid";
        break;
      default:
        tick = "Strong";
    }

    return "$level-$tick";
  }

  /// Returns the skill level as a readable string
  String get skillLevelString =>
      "${skillLabel(skillLevel.start)}, ${skillLabel(skillLevel.end)}";

  /// Convert Player instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'fullName': fullName,
      'contactNumber': contactNumber,
      'email': email,
      'address': address,
      'remarks': remarks,
      'skillLevelStart': skillLevel.start,
      'skillLevelEnd': skillLevel.end,
    };
  }

  /// Create Player instance from JSON
  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] ?? '',
      nickname: json['nickname'] ?? '',
      fullName: json['fullName'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      remarks: json['remarks'] ?? '',
      skillLevel: RangeValues(
        (json['skillLevelStart'] ?? 0).toDouble(),
        (json['skillLevelEnd'] ?? 0).toDouble(),
      ),
    );
  }

  /// Copy method for immutability convenience
  Player copyWith({
    String? id,
    String? nickname,
    String? fullName,
    String? contactNumber,
    String? email,
    String? address,
    String? remarks,
    RangeValues? skillLevel,
  }) {
    return Player(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      fullName: fullName ?? this.fullName,
      contactNumber: contactNumber ?? this.contactNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      remarks: remarks ?? this.remarks,
      skillLevel: skillLevel ?? this.skillLevel,
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? phoneNumber;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final String role;
  final UserPreferences preferences;
  final UserProfile profile;

  const UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.phoneNumber,
    required this.createdAt,
    required this.lastLoginAt,
    this.role = 'user',
    required this.preferences,
    required this.profile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
      phoneNumber: user.phoneNumber,
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
      preferences: const UserPreferences(),
      profile: UserProfile.fromFirebaseUser(user),
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromJson({
      'id': doc.id,
      ...data,
    });
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLoginAt': Timestamp.fromDate(lastLoginAt),
      'role': role,
      'preferences': preferences.toJson(),
      'profile': profile.toJson(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    String? role,
    UserPreferences? preferences,
    UserProfile? profile,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      role: role ?? this.role,
      preferences: preferences ?? this.preferences,
      profile: profile ?? this.profile,
    );
  }
}

@JsonSerializable()
class UserPreferences {
  final String language;
  final String region;
  final bool notificationsEnabled;
  final bool autoPlayEnabled;
  final String videoQuality;
  final List<String> interests;
  final bool darkModeEnabled;

  const UserPreferences({
    this.language = 'en',
    this.region = 'US',
    this.notificationsEnabled = true,
    this.autoPlayEnabled = true,
    this.videoQuality = 'auto',
    this.interests = const [],
    this.darkModeEnabled = false,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) => _$UserPreferencesFromJson(json);
  Map<String, dynamic> toJson() => _$UserPreferencesToJson(this);
}

@JsonSerializable()
class UserProfile {
  final String firstName;
  final String lastName;
  final String? bio;
  final String? location;
  final DateTime? dateOfBirth;
  final String gender;
  final List<String> socialLinks;

  const UserProfile({
    this.firstName = '',
    this.lastName = '',
    this.bio,
    this.location,
    this.dateOfBirth,
    this.gender = 'not_specified',
    this.socialLinks = const [],
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  factory UserProfile.fromFirebaseUser(User user) {
    final nameParts = (user.displayName ?? '').split(' ');
    return UserProfile(
      firstName: nameParts.isNotEmpty ? nameParts.first : '',
      lastName: nameParts.length > 1 ? nameParts.skip(1).join(' ') : '',
    );
  }

  String get fullName => '$firstName $lastName'.trim();
}

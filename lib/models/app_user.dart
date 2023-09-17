import 'dart:convert';

class AppUser {
  final String userId;
  final String userName;
  final String? profileImageURL;
  final String userEmail;
  final String? userAbout;
  AppUser({
    required this.userId,
    required this.userName,
    this.profileImageURL,
    required this.userEmail,
    this.userAbout,
  });

  AppUser copyWith({
    String? userId,
    String? userName,
    String? profileImageURL,
    String? userEmail,
    String? userAbout,
  }) {
    return AppUser(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      profileImageURL: profileImageURL ?? this.profileImageURL,
      userEmail: userEmail ?? this.userEmail,
      userAbout: userAbout ?? this.userAbout,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'profileImageURL': profileImageURL,
      'userEmail': userEmail,
      'userAbout': userAbout,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      profileImageURL: map['profileImageURL'],
      userEmail: map['userEmail'] ?? '',
      userAbout: map['userAbout'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppUser(userId: $userId, userName: $userName, profileImageURL: $profileImageURL, userEmail: $userEmail, userAbout: $userAbout)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppUser &&
        other.userId == userId &&
        other.userName == userName &&
        other.profileImageURL == profileImageURL &&
        other.userEmail == userEmail &&
        other.userAbout == userAbout;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        userName.hashCode ^
        profileImageURL.hashCode ^
        userEmail.hashCode ^
        userAbout.hashCode;
  }
}

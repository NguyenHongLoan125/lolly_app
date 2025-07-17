class UserModel {
  final String? id;
  final String? email;
  final String? username;
  final String? gender;
  final String? address;
  final String? introduction;
  String? profileImg;
  final DateTime? createAt;

  UserModel(
      this.id,
      this.email,
      this.username,
      this.gender,
      this.address,
      this.introduction,
      this.profileImg,
      this.createAt,
      );

  factory UserModel.fromMap(Map<String, dynamic> map) {
    final String? firstname = map['firstname'];
    final String? lastname = map['lastname'];
    final String name = [lastname, firstname]
        .where((e) => e != null && e.trim().isNotEmpty)
        .join(' ')
        .trim();

    return UserModel(
      map['user_id'],
      map['email'],
      name.isNotEmpty ? name : 'Không rõ',
      map['gender'],
      map['address'],
      map['introduction'],
      map['profile_image'],
      map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
    );
  }
}

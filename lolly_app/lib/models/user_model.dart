class UserModel {
  final String? userId;
  String? firstname;
  String? lastname;
  final String? email;
  String? address;
  String? gender;
  String? introduction;
  String? profileImage;

  UserModel({
    required this.userId,
    this.firstname,
    this.lastname,
    required this.email,
    this.address,
    this.gender,
    this.introduction,
    this.profileImage,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['user_id'],
      firstname: map['firstname'],
      lastname: map['lastname'],
      email: map['email'],
      address: map['address'],
      gender: map['gender'],
      introduction: map['introduction'],
      profileImage: map['profile_image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'address': address,
      'gender': gender,
      'introduction': introduction,
      'profile_image': profileImage,
    };
  }
}

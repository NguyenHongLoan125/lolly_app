
class User{
  String ? username;
  String ? firstname;
  String ? lastname;
  String ? email;
  String ? address;
  String ? gender;
  String ? introduction;
  String ? profileImage;
  String ? _password;


  String ? get passWord => _password;

  set passWord(String ? value) {
    _password = value;
  }

  User(this.username, this.firstname, this.lastname, this.email, this.address,
      this.gender, this.introduction, this.profileImage,this._password);

}
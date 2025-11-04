class UserModel {
  int? id; // ID interno autoincremental
  String email;
  //String password;
  String? name;
  String? lastName;
  String? gender;
  double? height;
  double? weight;

  UserModel({
    this.id,
    required this.email,
    //required this.password,
    this.name,
    this.lastName,
    this.gender,
    this.height,
    this.weight,
  });



  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'email': email,
      //'password': password,
      'name': name,
      'lastName': lastName,
      'gender': gender,
      'height': height,
      'weight': weight,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      //password: map['password'],
      name: map['name'],
      lastName: map['lastName'],
      gender: map['gender'],
      height: map['height'] != null ? map['height'] * 1.0 : null,
      weight: map['weight'] != null ? map['weight'] * 1.0 : null,
    );
  }
}

class UserProfile {
  dynamic name, email, uid, phone,password;
  bool isAdmin;
  bool block;

  UserProfile({
    required this.phone,
    required this.name,
    required this.email,
    required this.uid,
    required this.isAdmin,
    required this.password,
    required this.block,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'uid': uid,
      'phone': phone,
      'password': password,
      'isAdmin': isAdmin,
      'block': block,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['name'] ,
      email: map['email'] ,
      uid: map['uid'] ,
      phone: map['phone'] ,
      password: map['password'] ,
      isAdmin: map['isAdmin'] ,
      block: map['block'] ,
    );
  }
}

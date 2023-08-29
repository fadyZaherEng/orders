class UserProfile
{
  dynamic name,email,uid,phone;
  UserProfile({required this.phone,required this.name,required this.email,required this.uid});

  UserProfile.fromJson(Map<String,dynamic>?json)
  {
    name=json!['name'];
    phone=json!['phone'];
    email=json['email'];
    uid=json['uid'];
  }
  Map<String,dynamic> toMap(){
    return{
      'uid':uid,
      'email':email,
      'name':name,
      'phone':phone,
    };
  }
}
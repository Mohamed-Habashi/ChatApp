class ChatUserModel{
  String ? name;
  String ? email;
  String ? phone;
  String ? uId;

  ChatUserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.uId,
});

  ChatUserModel.fromJson(Map<String,dynamic>json){
    name=json['name'];
    email=json['email'];
    phone=json['phone'];
    uId=json['uId'];
  }

  Map<String,dynamic>? toMap(){
    return {
      'name':name,
      'email':email,
      'phone':phone,
      'uId':uId,
    };
  }
}
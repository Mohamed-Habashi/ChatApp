class MessageModel{
  String ?senderId;
  String ?receiverId;
  String ?dateTime;
  String ?text;
  String ? image;

  MessageModel({
   required this.senderId,
    required this.receiverId,
    required this.dateTime,
    required this.text,
    required this.image,
});

  MessageModel.fromJson(Map<String,dynamic>json){
    senderId=json['senderId'];
    receiverId=json['receiverId'];
    dateTime=json['dateTime'];
    text=json['text'];
    image=json['image'];
  }

  Map<String,dynamic>toMap(){
    return {
      'senderId':senderId,
      'receiverId':receiverId,
      'dateTime':dateTime,
      'text':text,
      'image':image,
    };
  }
}
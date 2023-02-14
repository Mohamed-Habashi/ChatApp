import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget defaultButton({
  double width=double.infinity,
  double height=40,
  double radius=20,
  Color backColor=Colors.red,
  Color textColor=Colors.white ,
  required String label,
  required void Function()? function,
}){
  return Container(
    width: width,
    height: height,
    child: ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(backColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      ),
      onPressed: function,
      child:  Text(
        label.toUpperCase(),
        style: TextStyle(
          color: textColor,
        ),
      ),
    ),
  );
}

Widget defaultFormField({
  required var controller,
  required bool obscure,
  required var keyboardType,
  required String label,
  required String? Function(String?)? validator,
  void Function()? onTap,
  Icon ? prefixIcon,
  var  suffixIcon,
  double radius=10,
  bool isClickable=true,
  void Function(String)? onSubmit,
  void Function(String)? onChange,
  context,
}){
  return TextFormField(
    style: const TextStyle(
      color: Colors.black,
    ),
    cursorColor: Colors.black,
    //style: Theme.of(context).textTheme.bodyText1,
    decoration:  InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.black,
      ),
      focusColor: Colors.black,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(
            color: Colors.black,
          )
      ),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(
            color: Colors.black,
          )
      ),
    ),
    controller: controller,
    onFieldSubmitted: onSubmit,
    onChanged: onChange,
    keyboardType: keyboardType,
    enabled: isClickable,
    obscureText: obscure,
    validator: validator,
    onTap: onTap,
  );
}

 navigateTo(context,Widget widget)=>Navigator.push(context, MaterialPageRoute(builder: (context){
  return widget;
}));

navigateToFinish(context,Widget widget)=>Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
  return widget;
}), (route) => false);

Future<bool?> showToast({
required String message,
  Color color=Colors.green,
}){
  return Fluttertoast.showToast(
    msg: message,
    timeInSecForIosWeb: 2,
    toastLength: Toast.LENGTH_LONG,
    backgroundColor: color,
    gravity: ToastGravity.BOTTOM,
  );
}

PreferredSizeWidget? defaultAppBar({
  required BuildContext context,
  String ? title,
  List<Widget>?action,
})=>AppBar(
  backgroundColor: Colors.red,
  leading: IconButton(
    onPressed: (){
      Navigator.pop(context);
    },
    icon: const Icon(
      Icons.arrow_back,
      color: Colors.white,
    ),
  ),
  title:  Text(
      title!
  ),
  actions: action,
);
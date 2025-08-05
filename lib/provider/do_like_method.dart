import 'package:flutter/cupertino.dart';

class DoLikeMethod with ChangeNotifier{

  Map pushLike = {};

  void getPushIsLike(Map pushIsLike){
    pushLike = pushIsLike;
    notifyListeners();
  }

  Map popIsLike = {};

  void getPopIsLike(Map map){
    popIsLike = map;
    notifyListeners();
  }


}
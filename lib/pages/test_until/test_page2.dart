import 'dart:async';
import '../../utils/global.dart';
import 'package:flutter/material.dart';


class TestPage2 extends StatefulWidget {
  TestPage2({Key key}) : super(key: key);

  @override
  createState() => _TestPage2State();

}


class _TestPage2State extends State<TestPage2> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async{

    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: customAppbar(context: context,title: 'TestPage2'),
      body: Text('TestPage2'),
    );

  }



}
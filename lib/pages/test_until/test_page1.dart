import 'dart:async';
import '../../utils/global.dart';
import 'package:flutter/material.dart';

class TestPage1 extends StatefulWidget {
  TestPage1({Key? key}) : super(key: key);

  @override
  createState() => _TestPage1State();
}

class _TestPage1State extends State<TestPage1> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: 'TestPage1'),
      body: Text('TestPage1'),
    );
  }
}

import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/src/foundation/constants.dart';

import './player_widget.dart';
import '../../utils/global.dart';

class AAudioView {
  final BuildContext context;

  /// 图片URL
  final String url;
  AAudioView.show(this.context, {@required this.url}) {
    Widget aview = new AAudioViewScreen(url: url);
    final route = new CupertinoPageRoute(
      builder: (BuildContext context) => aview,
      settings: new RouteSettings(
        name: aview.toStringShort(),
        //        isInitialRoute: false,
      ),
    );

    G.getCurrentState().push(route);
  }
}

class AAudioViewScreen extends StatefulWidget {
  String url;
  AAudioViewScreen({Key key, this.url = ''}) : super(key: key);
  @override
  createState() => _AAudioViewScreenState();
}

class _AAudioViewScreenState extends State<AAudioViewScreen> {
  AudioCache audioCache = AudioCache();
  AudioPlayer advancedPlayer = AudioPlayer();
  String localFilePath;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      // Calls to Platform.isIOS fails on web
      return;
    }
    if (Platform.isIOS) {
      if (audioCache.fixedPlayer != null) {
        audioCache.fixedPlayer.startHeadlessService();
      }
      advancedPlayer.startHeadlessService();
    }
  }

  Future<int> _getDuration() async {
    File audiofile = await audioCache.load('audio2.mp3');
    await advancedPlayer.setUrl(audiofile.path);
    int duration = await Future.delayed(
      Duration(seconds: 2),
      () => advancedPlayer.getDuration(),
    );
    return duration;
  }

  getLocalFileDuration() {
    return FutureBuilder<int>(
      future: _getDuration(),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('No Connection...');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Text('Awaiting result...');
          case ConnectionState.done:
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            return Text(
              'audio2.mp3 duration is: ${Duration(milliseconds: snapshot.data)}',
            );
        }
        return null; // unreachable
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<Duration>.value(
          initialData: Duration(),
          value: advancedPlayer.onAudioPositionChanged,
        ),
      ],
      child: Scaffold(
        appBar: customAppbar(context: context, title: '音頻'),
        body: Container(
          padding: EdgeInsets.only(top: 20.0),
          child: PlayerWidget(url: widget.url),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/global.dart'; // Assuming this import is correct

class AAudioView {
  final BuildContext context;
  final String url;

  AAudioView.show(this.context, {required this.url}) {
    Widget aview = AAudioViewScreen(url: url);
    final route = CupertinoPageRoute(
      builder: (BuildContext context) => aview,
      settings: RouteSettings(name: aview.toStringShort()),
    );
    G.getCurrentState().push(
      route,
    ); // Assuming G.getCurrentState() is correctly defined
  }
}

class AAudioViewScreen extends StatefulWidget {
  final String url;
  const AAudioViewScreen({Key? key, required this.url}) : super(key: key);
  @override
  State<AAudioViewScreen> createState() => _AAudioViewScreenState();
}

class _AAudioViewScreenState extends State<AAudioViewScreen> {
  final AudioPlayer advancedPlayer = AudioPlayer();
  Duration _duration = Duration.zero;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAudio(widget.url);
  }

  Future<void> _loadAudio(String url) async {
    try {
      if (url.startsWith('assets/')) {
        await advancedPlayer.setSourceAsset(url);
      } else {
        // CORRECTED:  Handles headers correctly
        await advancedPlayer.setSourceUrl(url);
      }
      final duration = await advancedPlayer.getDuration();
      setState(() {
        _duration = duration ?? Duration.zero;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error loading audio: $e';
        _duration = Duration.zero;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<Duration>.value(
          initialData: Duration.zero,
          value: advancedPlayer
              .onPositionChanged, // Corrected: Use onPositionChanged
        ),
        Provider.value(value: _duration),
      ],
      child: Scaffold(
        appBar: customAppbar(
          context: context,
          title: '音頻',
        ), // Assuming customAppbar is defined
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
            ? Center(child: Text(_errorMessage!))
            : Column(
                children: [
                  Text('Audio duration: $_duration'),
                  Container(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: PlayerWidget(
                      url: widget.url,
                      player: advancedPlayer,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    advancedPlayer.dispose();
    super.dispose();
  }
}

class PlayerWidget extends StatefulWidget {
  final String url;
  final AudioPlayer player;

  const PlayerWidget({Key? key, required this.url, required this.player})
    : super(key: key);

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  bool isPlaying = false;
  String? position;
  String? duration;

  @override
  void initState() {
    super.initState();
    widget.player.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
    widget.player.onDurationChanged.listen((duration) {
      setState(() {
        this.duration = duration.toString();
      });
    });
    widget.player.onPositionChanged.listen((position) {
      setState(() {
        this.position = position.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Position: $position'),
        Text('Duration: $duration'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: () async {
                if (isPlaying) {
                  await widget.player.pause();
                } else {
                  await widget.player.resume();
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.stop),
              onPressed: () async {
                await widget.player.stop();
                setState(() {
                  isPlaying = false;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    widget.player.dispose();
    super.dispose();
  }
}

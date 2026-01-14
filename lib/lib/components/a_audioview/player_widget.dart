import 'dart:async';
//import 'package:flutter/cupertino.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

// No need for a custom PlayerState enum; use the one from audioplayers
// enum PlayerState { stopped, playing, paused, completed }

class PlayerWidget extends StatefulWidget {
  final String url;
  final PlayerMode mode;

  const PlayerWidget({
    Key? key,
    required this.url,
    this.mode = PlayerMode.mediaPlayer,
  }) : super(key: key);

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  late AudioPlayer _audioPlayer;
  PlayerState _playerState =
      PlayerState.stopped; // Use audioplayers' PlayerState
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerStateSubscription;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              key: const Key('play_button'),
              onPressed: _playerState == PlayerState.playing ? null : _play,
              iconSize: 64.0,
              icon: const Icon(Icons.play_arrow),
              color: Colors.teal,
            ),
            IconButton(
              key: const Key('pause_button'),
              onPressed: _playerState == PlayerState.playing ? _pause : null,
              iconSize: 64.0,
              icon: const Icon(Icons.pause),
              color: Colors.teal,
            ),
            IconButton(
              key: const Key('stop_button'),
              onPressed: _playerState != PlayerState.stopped ? _stop : null,
              iconSize: 64.0,
              icon: const Icon(Icons.stop),
              color: Colors.teal,
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Slider(
                onChanged: (v) {
                  final position = v * _duration.inMilliseconds;
                  _audioPlayer.seek(Duration(milliseconds: position.round()));
                },
                value: _duration.inMilliseconds == 0
                    ? 0.0
                    : _position.inMilliseconds / _duration.inMilliseconds,
              ),
            ),
            Text(
              '${_position.inSeconds} / ${_duration.inSeconds}',
              style: const TextStyle(fontSize: 24.0),
            ),
          ],
        ),
        Text(_playerState.toString()),
      ],
    );
  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer();
    _audioPlayer.setPlayerMode(widget.mode);

    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _positionSubscription = _audioPlayer.onPositionChanged.listen((position) {
      setState(() => _position = position);
    });

    _playerStateSubscription = _audioPlayer.onPlayerStateChanged.listen((
      state,
    ) {
      setState(() {
        _playerState =
            state; // Correct assignment using audioplayers' PlayerState
        if (state == PlayerState.completed) {
          _onComplete();
        } else if (state == PlayerState.stopped &&
            _playerState != PlayerState.stopped) {
          _onError('Playback stopped unexpectedly');
        }
      });
    });
  }

  void _onComplete() {
    setState(() {
      _playerState = PlayerState.stopped;
      _position = Duration.zero;
    });
  }

  void _onError(String message) {
    print('Audio player error: $message');
    _onComplete();
  }

  Future<void> _play() async {
    final playPosition = _position;
    await _audioPlayer.play(
      UrlSource(widget.url),
      position: playPosition,
    ); // Corrected play method
  }

  Future<void> _pause() async {
    await _audioPlayer.pause();
  }

  Future<void> _stop() async {
    await _audioPlayer.stop();
    _onComplete();
  }
}

import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayerView extends StatefulWidget {
  static const routeName = '/player';

  final String _videoURL;

  const PlayerView({super.key, required String videoURL})
      : _videoURL = videoURL;

  @override
  State<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  late final YoutubePlayerController _playerController;

  @override
  void initState() {
    assert(widget._videoURL.contains("https://www.youtube.com/watch?v="));

    final videoID = Uri.parse(widget._videoURL).queryParameters['v'] as String;
    _playerController = YoutubePlayerController(
      initialVideoId: videoID,
      flags: const YoutubePlayerFlags(autoPlay: true),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: YoutubePlayer(controller: _playerController),
      ),
    );
  }
}

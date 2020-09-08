import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:r_b_music_player/albumPane.dart';
import 'package:r_b_music_player/controlPane.dart';

class RBHome extends StatefulWidget {
  @override
  _RBHomeState createState() => _RBHomeState();
}

class _RBHomeState extends State<RBHome> with TickerProviderStateMixin {
  AnimationController animationController; //animation controller

  Curve animationStyle = Curves.easeInOutBack;

  FlutterAudioQuery audioQuery;
  List<SongInfo> allSongs;

  void initAnimation() {
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
  }

  Future<List<SongInfo>> getAllSongs() async {
    allSongs = await audioQuery.getSongs();
    return allSongs;
  }

  Widget stackBody() {
    return Stack(
      fit: StackFit.expand,
      children: [
        AlbumPane(
          animationController: animationController,
          animationStyle: animationStyle,
        ),
        ControlPane(
          animationController: animationController,
          animationStyle: animationStyle,
          allSongs: allSongs,
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    audioQuery = FlutterAudioQuery();
    initAnimation();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getAllSongs(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            allSongs = snapshot.data;
            return AnimatedBuilder(
              animation: animationController,
              builder: (context, child) => stackBody(),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

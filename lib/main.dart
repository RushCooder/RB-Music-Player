import 'package:flutter/material.dart';
import 'package:r_b_music_player/rbHome.dart';

void main() => runApp(RBMusic());

class RBMusic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "RB Music Player",
      home: RBHome(),
    );
  }
}

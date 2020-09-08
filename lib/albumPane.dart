import 'dart:ui';

import 'package:flutter/material.dart';

class AlbumPane extends StatefulWidget {
  final AnimationController animationController;
  final Curve animationStyle;
  AlbumPane({
    Key key,
    @required this.animationController,
    @required this.animationStyle,
  });
  @override
  _AlbumPaneState createState() => _AlbumPaneState();
}

class _AlbumPaneState extends State<AlbumPane> {
  Animation albumAnimation;
  Animation albumImageBlurAnimation;

  Curve animationStyle = Curves.easeInOutBack;

  void initAnimation() {
    albumAnimation = Tween(begin: 1.0, end: 0.7).animate(CurvedAnimation(
        parent: widget.animationController, curve: widget.animationStyle));

    albumImageBlurAnimation =
        Tween(begin: 0.0, end: 5.0).animate(widget.animationController);
  }

  @override
  void initState() {
    super.initState();
    initAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: albumAnimation.value,
      alignment: Alignment.topCenter,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ExactAssetImage("assets/img/profile.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: albumImageBlurAnimation.value,
              sigmaY: albumImageBlurAnimation.value),
          child: Container(
            color: Colors.white.withOpacity(0.0),
          ),
        ),
      ),
    );
  }
}

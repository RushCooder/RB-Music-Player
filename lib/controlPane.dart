import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class ControlPane extends StatefulWidget {
  final AnimationController animationController;
  final Curve animationStyle;
  final allSongs;
  ControlPane({
    Key key,
    @required this.animationController,
    @required this.animationStyle,
    @required this.allSongs,
  });

  @override
  _ControlPaneState createState() => _ControlPaneState(allSongs);
}

class _ControlPaneState extends State<ControlPane>
    with SingleTickerProviderStateMixin {
  List<SongInfo> allSongs;
  _ControlPaneState(this.allSongs);
  AnimationController playPauseAnimationController;
  Animation sliderActiveColorAnimation;
  Animation sliderInactiveColorAnimation;
  double val = 0.0;

  Animation controlPaneAnimation;
  Animation controlPaneColorAnimation;
  Animation controlPaneTextColorAnimation;

  bool isPlaying;
  AudioPlayer audioPlayer;

  int index = 0;

  Duration totalDuration = Duration();
  Duration currentDuration = Duration();
  double minValue = 0;
  String playStatus = "Stopped";
  String totallTime = "00:00";
  String currentTime = "00:00";

  // play pause music
  void playMusic() {
    if (isPlaying == false) {
      audioPlayer.play(allSongs[index].filePath);
      isPlaying
          ? playPauseAnimationController.reverse()
          : playPauseAnimationController.forward();
      isPlaying ? playStatus = "Paused Music" : playStatus = "Now Playing";
      isPlaying = true;
    } else {
      audioPlayer.pause();
      isPlaying = false;
    }
    // setState(() {
    //   isPlaying
    //       ? playPauseAnimationController.reverse()
    //       : playPauseAnimationController.forward();
    //   isPlaying ? playStatus = "Paused Music" : playStatus = "Now Playing";
    // });
  }

  // next music
  void nextMusic() {
    if ((index + 1) < allSongs.length) {
      index += 1;
      isPlaying = false;
      playMusic();
    }
  }

  // previous music
  void previousMusic() {
    if ((index - 1) >= 0) {
      index -= 1;
      isPlaying = false;
      playMusic();
    }
  }

  // initializing animations
  void initAnimation() {
    // play pause animation
    playPauseAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    // pane color animation
    controlPaneColorAnimation =
        ColorTween(begin: Colors.black87, end: Colors.white.withOpacity(0.5))
            .animate(widget.animationController);

    // pane text color animation
    controlPaneTextColorAnimation =
        ColorTween(begin: Colors.white, end: Colors.black87)
            .animate(widget.animationController);

    // slider animation
    sliderActiveColorAnimation =
        ColorTween(begin: Colors.red.shade700, end: Colors.red.shade900)
            .animate(widget.animationController);

    sliderInactiveColorAnimation =
        ColorTween(begin: Colors.brown, end: Colors.brown.shade900)
            .animate(widget.animationController);
  }

  // starting animation
  void startAnimation() {
    setState(() {
      if (widget.animationController.isCompleted) {
        widget.animationController.reverse();
      } else {
        widget.animationController.forward();
      }
    });
  }

  // songs details text
  Widget playSongInfo(details, fontSize, pd) {
    return Padding(
      padding: EdgeInsets.all(pd),
      child: Text(
        details,
        style: TextStyle(
          color: controlPaneTextColorAnimation.value,
          fontSize: fontSize,
        ),
      ),
    );
  }

  // song list
  Widget songList() {
    return ListView.builder(
      itemCount: allSongs.length,
      itemBuilder: (context, songIndex) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              index = songIndex;
              isPlaying = false;
              playMusic();
            },
            splashColor: Colors.green,
            highlightColor: Colors.blue,
            child: ListTile(
              leading: Image.asset(
                "assets/img/profile.jpg",
                fit: BoxFit.cover,
              ),
              title: playSongInfo(allSongs[songIndex].title, 16.0, 0.0),
              subtitle: playSongInfo(allSongs[songIndex].artist, 13.0, 0.0),
            ),
          ),
        );
      },
    );
  }

  // slider or seek bar
  Widget sliderBar() {
    return Slider(
      value: currentDuration.inSeconds.toDouble(),
      min: 0.0,
      max: totalDuration.inSeconds.toDouble(),
      activeColor: sliderActiveColorAnimation.value,
      inactiveColor: sliderInactiveColorAnimation.value,
      onChanged: (value) {
        setState(() {
          Duration newDuration = Duration(seconds: value.toInt());
          try {
            audioPlayer.seek(newDuration);
          } catch (e) {
            print("Error");
          }
        });
      },
    );
  }

  // control button
  Widget songControllerBtn(btnIcon, onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Icon(
        btnIcon,
        size: 50.0,
        color: controlPaneTextColorAnimation.value,
      ),
    );
  }

  Widget playButton() {
    return InkWell(
      onTap: () {
        isPlaying
            ? playPauseAnimationController.reverse()
            : playPauseAnimationController.forward();
        isPlaying ? playStatus = "Paused Music" : playStatus = "Now Playing";
        playMusic();
      },
      child: AnimatedIcon(
        icon: AnimatedIcons.play_pause,
        progress: playPauseAnimationController,
        size: 50.0,
        color: controlPaneTextColorAnimation.value,
      ),
    );
  }

  // all content pane here
  Widget songPaneContent() {
    return Column(
      children: [
        playSongInfo(playStatus, 15.0, 5.0),
        playSongInfo(allSongs[index].title, 16.5, 8.0),
        playSongInfo(allSongs[index].artist, 13.5, 0.0),
        sliderBar(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            songControllerBtn(Icons.skip_previous, previousMusic),
            playButton(),
            songControllerBtn(Icons.skip_next, nextMusic),
          ],
        ),
        Text(
          "$totallTime / $currentTime",
          style: TextStyle(
            color: controlPaneTextColorAnimation.value,
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height / 2.5,
          child: songList(),
        ),
      ],
    );
  }

  Widget controlPane() {
    return Positioned(
      bottom: controlPaneAnimation.value,
      child: GestureDetector(
        onTap: () {
          startAnimation();
        },
        child: Container(
          // height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: controlPaneColorAnimation.value,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0)),
          ),
          child: songPaneContent(),
        ),
      ),
    );
  }

  void reset() {
    isPlaying = false;
    totalDuration = Duration();
    currentDuration = Duration();
    totallTime = "00:00";
    currentTime = "00:00";
  }

  // play audio duration
  void getAudioData() {
    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        totalDuration = duration;
        totallTime = duration.toString().split(".")[0];
      });
    });

    audioPlayer.onAudioPositionChanged.listen((Duration duration) {
      setState(() {
        currentDuration = duration;
        currentTime = duration.toString().split(".")[0];
      });

      if (totalDuration.inSeconds.toDouble() ==
              currentDuration.inSeconds.toDouble() &&
          isPlaying == true) {
        reset();
        nextMusic();
      }
    });
  }

  // init method
  @override
  void initState() {
    super.initState();

    // initializing conponents
    audioPlayer = AudioPlayer();
    isPlaying = false;
    initAnimation();
    setState(() {
      isPlaying ? playStatus = "Paused Music" : playStatus = "Now Playing";
    });
    getAudioData();
  }

  // build method
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 2;
    // pane animation
    controlPaneAnimation = Tween(begin: -height * 0.7, end: 0.0).animate(
        CurvedAnimation(
            parent: widget.animationController, curve: widget.animationStyle));

    return controlPane();
  }
}

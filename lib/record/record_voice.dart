import 'package:dotted_border/dotted_border.dart';
import 'package:fetch_voice_data/constants.dart';
import 'package:fetch_voice_data/firebase/model.dart';
import 'package:fetch_voice_data/record/play_button.dart';
import 'package:fetch_voice_data/utils/utils.dart';
import 'package:fetch_voice_data/utils/utils_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class RecordPage extends StatefulWidget {
  final VoiceState voiceState;
  const RecordPage({Key? key, required this.voiceState}) : super(key: key);

  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> with TickerProviderStateMixin {
  late Color backgroundColor;
  late AnimationController animationControllerSize;
  late Animation shadowAnimation;
  late AnimationController animationControllerShadow;

  List<String> imagesUrls = [
    "https://www.macobserver.com/wp-content/uploads/2019/09/workfeatured-iOS-13-memoji.png",
    "http://andc-scale.livewallcampaigns.com/imageScaled/scale?site=andc&w=1200&h=630&cropped=1&file=1537355257_animoji-header.jpg",
    //"https://i.pinimg.com/originals/2d/9c/f1/2d9cf10d9a21f2c704b3c64f5b838705.jpg",
    "https://cdn131.picsart.com/318342880280201.jpg?type=webp&to=crop&r=256",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTcrE0PW5HgoZSUsvbReIhaTG51xFGKfGcCBQ&usqp=CAU",
    // "https://cdn141.picsart.com/350586194089201.jpg",
    // "https://www.the-sun.com/wp-content/uploads/sites/6/2020/02/DD-COMPOSITE-EYE-ROLL-EMOJI-2.jpg?strip=all&quality=100&w=1200&h=800&crop=1",
  ];

  List<Widget> widgets = [];
  List<Map<String, double>> coords = [];

  @override
  void dispose() {
    animationControllerSize.dispose();
    animationControllerShadow.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    backgroundColor = RecordUI.voiceStateToColor(widget.voiceState);

    // Animation
    animationControllerShadow = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        setState(() {});
      });
    shadowAnimation = MaterialPointArcTween(
      begin: const Offset(5, 5),
      end: const Offset(-5, -5),
    ).animate(
      CurvedAnimation(
          parent: animationControllerShadow, curve: Curves.easeInOutQuart),
    );
    animationControllerSize = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    animationControllerSize.repeat();
    animationControllerShadow.repeat();

    // WIDGETS
    int n = imagesUrls.length;
    double d = 1 / (n + 1);
    List<double> delays = List.generate(n, (index) => d * index);
    double dmax = 80;
    double padding = 20;
    List<double> radii = [1.5 * (dmax + padding)];
    coords = NodeDisposition.defineCoordsRecordPage(imagesUrls.length,
        Constants.height, Constants.width, dmax, radii.first);
    List<Widget> circles = radii
        .map((radius) => Align(
              alignment: Alignment.center,
              child: DottedBorder(
                borderType: BorderType.Circle,
                color: Colors.white,
                dashPattern: const [10, 5],
                strokeWidth: 1,
                child: Container(
                  height: 2 * radius,
                  width: 2 * radius,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ))
        .toList();

    List<Widget> storyCards = coords
        .asMap()
        .map((index, coord) {
          return MapEntry(
            index,
            index == 0
                ? Center(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple[100]!,
                            offset: shadowAnimation.value,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      height: 100,
                      width: 100,
                      child: PlayButton(
                        initialIsPlaying: ValueNotifier<bool>(true),
                        pauseIcon: const Icon(Icons.mic,
                            color: Colors.black, size: 30),
                        playIcon: const Icon(Icons.mic_off,
                            color: Colors.black, size: 30),
                        onPressed: () {},
                        gradient: const LinearGradient(
                            colors: [Colors.white70, Colors.white70]),
                      ),
                    ),
                  )
                : Positioned(
                    bottom: coord["y"]! - (coord["size"]! ~/ 2),
                    left: coord["x"]! - (coord["size"]! ~/ 2),
                    child: ScaleTransition(
                      scale: BackAndForthTween(
                        begin: 0.90,
                        end: 1.00,
                        delay: delays.elementAt(index),
                      ).animate(animationControllerSize),
                      child: Container(
                        height: coord["size"]!,
                        width: coord["size"]!,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.purple[100]!.withOpacity(0.92),
                                offset: const Offset(0.0, 3.0),
                                blurRadius: 25)
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(imagesUrls.elementAt(index)),
                          ),
                        ),
                      ),
                    ),
                  ),
          );
        })
        .values
        .toList();
    widgets.addAll(circles);
    widgets.addAll(storyCards);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: backgroundColor,
        child: Stack(
          children: widgets +
              [
                const Positioned.fill(
                  top: 100,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "Tap on the record button\n to record your voice",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  bottom: 200,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      "Mood: ${describeEnum(widget.voiceState).firstUpperCase()}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
        ),
      ),
    );
  }
}

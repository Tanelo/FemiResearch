import 'package:dotted_border/dotted_border.dart';
import 'package:fetch_voice_data/constants.dart';
import 'package:fetch_voice_data/firebase/model.dart';
import 'package:fetch_voice_data/record/play_button.dart';
import 'package:fetch_voice_data/record/voice_button.dart';
import 'package:fetch_voice_data/utils/utils.dart';
import 'package:fetch_voice_data/utils/utils_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class RecordPage extends StatefulWidget {
  final VoiceState voiceState;
  final double height;
  final double width;
  const RecordPage({
    Key? key,
    required this.voiceState,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> with TickerProviderStateMixin {
  late Color backgroundColor;
  late AnimationController animationControllerSize;
  late Animation shadowAnimation;
  late AnimationController animationControllerShadow;

  List<String> imagesUrls = [];
  List<Widget> allWidgets = [];
  // List<Widget> widgets = [];
  List<Map<String, double>> coords = [];
  late Widget cwidget;

  @override
  void dispose() {
    animationControllerSize.dispose();
    animationControllerShadow.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    double width = widget.width;
    double height = widget.height;
    backgroundColor = Constants.voiceColor[widget.voiceState]!;
    imagesUrls = Constants.imagesUrls[widget.voiceState]!;

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

    // widgets.add(Center(
    //   child: Container(
    //     decoration: BoxDecoration(
    //       shape: BoxShape.circle,
    //       boxShadow: [
    //         BoxShadow(
    //           color: Colors.deepPurple[100]!,
    //           offset: shadowAnimation.value,
    //           blurRadius: 10,
    //         ),
    //       ],
    //     ),
    //     height: 100,
    //     width: 100,
    //     child: PlayButton(
    //       initialIsPlaying: ValueNotifier<bool>(true),
    //       pauseIcon: const Icon(Icons.mic, color: Colors.black, size: 30),
    //       playIcon: const Icon(Icons.mic_off, color: Colors.black, size: 30),
    //       onPressed: () {},
    //       gradient:
    //           const LinearGradient(colors: [Colors.white70, Colors.white70]),
    //     ),
    //   ),
    // ));

    int n = imagesUrls.length;
    double d = 1 / (n + 1);
    List<double> delays = List.generate(n, (index) => d * index);
    double dmax = 80;
    double padding = 20;
    double currentRadius = 1.2 * (dmax + padding);
    coords = NodeDisposition.defineCoordsRecordPage(
        imagesUrls.length, width, width, dmax, currentRadius);

    Widget circle = Align(
      alignment: Alignment.center,
      child: DottedBorder(
        borderType: BorderType.Circle,
        color: Colors.white,
        dashPattern: const [10, 5],
        strokeWidth: 1,
        child: Container(
          height: 2 * currentRadius,
          width: 2 * currentRadius,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
          ),
        ),
      ),
    );

    List<Widget> imageCards = coords
        .asMap()
        .map((index, coord) {
          return MapEntry(
            index,
            Positioned(
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
    allWidgets = [
          // const Align(alignment: Alignment.center, child: VoiceButton()),
          circle
        ] +
        imageCards;
  }

  @override
  Widget build(BuildContext context) {
    // allWidgets
    //     .add(const Align(alignment: Alignment.center, child: VoiceButton()));
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 40, left: 20, right: 20),
            child: Text(
              "Tape sur le bouton central \npour enregistrer ta voix",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "Mood : ${describeEnum(widget.voiceState).firstUpperCase()}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              // fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
              width: widget.width,
              height: widget.width,
              child: Stack(
                children: allWidgets +
                    [Align(alignment: Alignment.center, child: VoiceButton())],
              )),
          // VoiceButton(),
        ],
      ),

      // child: Stack(
      //   children: widgets +
      //       [
      //         Positioned.fill(
      //           top: 100,
      //           child: Align(
      //             alignment: Alignment.topCenter,
      //             child: Column(
      //               children: [
      //                 const Text(
      //                   "Tape sur le bouton central\n pour enregistrer ta voix",
      //                   textAlign: TextAlign.center,
      //                   style: TextStyle(
      //                     color: Colors.white,
      //                     fontSize: 22,
      //                     fontWeight: FontWeight.bold,
      //                   ),
      //                 ),
      //                 const SizedBox(height: 30),
      //                 Text(
      //                   "Mood: ${describeEnum(widget.voiceState).firstUpperCase()}",
      //                   textAlign: TextAlign.center,
      //                   style: const TextStyle(
      //                     color: Colors.white,
      //                     fontSize: 22,
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ],
      // ),
    );
  }
}

import 'package:dotted_border/dotted_border.dart';
import 'package:fetch_voice_data/constants.dart';
import 'package:fetch_voice_data/utils_ui.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  String profileImageUrl =
      "https://i.pinimg.com/736x/68/16/3e/68163efb3c2201721d8e681cde6aef2b.jpg";

  late AnimationController animationControllerSize;
  late Animation shadowAnimation;
  late AnimationController animationControllerShadow;

  List<String> imagesUrls = [
    "https://www.macobserver.com/wp-content/uploads/2019/09/workfeatured-iOS-13-memoji.png",
    "http://andc-scale.livewallcampaigns.com/imageScaled/scale?site=andc&w=1200&h=630&cropped=1&file=1537355257_animoji-header.jpg",
    "https://i.pinimg.com/originals/2d/9c/f1/2d9cf10d9a21f2c704b3c64f5b838705.jpg",
    "https://cdn131.picsart.com/318342880280201.jpg?type=webp&to=crop&r=256",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTcrE0PW5HgoZSUsvbReIhaTG51xFGKfGcCBQ&usqp=CAU",
    "https://cdn141.picsart.com/350586194089201.jpg",
    "https://www.the-sun.com/wp-content/uploads/sites/6/2020/02/DD-COMPOSITE-EYE-ROLL-EMOJI-2.jpg?strip=all&quality=100&w=1200&h=800&crop=1",
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

    int n = imagesUrls.length;
    double d = 1 / (n + 1);
    List<double> delays = List.generate(n, (index) => d * index);
    double dmax = 80;
    double padding = 20;
    List<double> radii = [2 * (dmax + padding), 4 * dmax + 2 * padding];
    coords = defineCoords(imagesUrls.length, Constants.height,
        Constants.width * 0.965, dmax, padding);
    List<Widget> circles = radii
        .map(
          (radius) => Center(
            child: DottedBorder(
              borderType: BorderType.Circle,
              color: Colors.white,
              dashPattern: const [10, 5],
              strokeWidth: 1,
              child: Container(
                height: radius,
                width: radius,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
        )
        .toList();
    List<Widget> storyCards = coords
        .asMap()
        .map((index, coord) {
          return MapEntry(
            index,
            Positioned(
              bottom: coord["y"]! - (coord["size"]! ~/ 2),
              left: coord["x"]! - (coord["size"]! ~/ 2),
              child: ScaleTransition(
                scale: BackAndForthTween(
                        begin: 0.90, end: 1.00, delay: delays.elementAt(index))
                    .animate(animationControllerSize),
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print(height);
    print(width);
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.pink[400]!.withOpacity(0.800),
            Colors.blue[300]!.withOpacity(0.800),
          ],
        )),
        child: Stack(
          children: [
            Stack(
              children: widgets,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: height * 0.12,
                      left: width * 0.07,
                      right: width * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome to Femi",
                        style: TextStyle(
                          fontFamily: "MuseoSans700",
                          color: Colors.white,
                          fontSize: width * 0.07,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => AddMessagePage(
                      //                 myUser: widget.myUser,
                      //                 relationships: widget.relationships,
                      //                 friends: friends)));
                      //   },
                      //   child: Row(
                      //     children: [
                      //       Icon(
                      //         Icons.message_rounded,
                      //         color: Colors.grey[750],
                      //         size: 30,
                      //       ),
                      //       Icon(
                      //         Icons.person_search_outlined,
                      //         size: 30,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),

                // } else {
              ],
            ),
          ],
        ),
      ),
    );
  }
}

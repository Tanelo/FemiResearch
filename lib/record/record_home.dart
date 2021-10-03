import 'package:fetch_voice_data/constants.dart';
import 'package:fetch_voice_data/firebase/firbase_api.dart';
import 'package:fetch_voice_data/firebase/model.dart';
import 'package:fetch_voice_data/record/record_voice.dart';
import 'package:fetch_voice_data/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../final_page.dart';

class RecordHome extends StatefulWidget {
  final String userId;
  final double height;
  final double width;
  const RecordHome({
    Key? key,
    required this.userId,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  _RecordHomeState createState() => _RecordHomeState();
}

class _RecordHomeState extends State<RecordHome> {
  PageController pageController = PageController();
  PanelController pc = PanelController();
  ScrollController sc = ScrollController();
  List<Widget> pages = [];
  int _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
    List<Widget> pages1 = VoiceState.values
        .map((state) {
          return RecordPage(
            voiceState: state,
            width: widget.width,
            height: widget.height,
          );
        })
        .toList()
        .cast();

    pages = pages1 + [FinalPage(height: widget.height, width: widget.width)];
    print(pages);

    texts2say = Map.fromEntries(VoiceState.values.map((state) {
      List<String> possibleTexts = Constants.textAssociatedToState[state]!;
      String text2say =
          possibleTexts.elementAt(Utils.randint(0, possibleTexts.length));
      return MapEntry(state, text2say);
    }));
    // Future.delayed(const Duration(seconds: 2), () {
    //   if (pc.isAttached) {
    //     pc.open();
    //   }
    // });
  }

  @override
  void dispose() {
    pageController.dispose();

    super.dispose();
  }

  _onPageViewChange(int page) {
    setState(() {
      _selectedPageIndex = page;
    });
    // print(_selectedPageIndex);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SlidingUpPanel(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        isDraggable: false,
        controller: pc,
        minHeight: 0,
        maxHeight: height * 0.33,
        backdropEnabled: false,
        panel: _panel(_selectedPageIndex),
        body: Stack(
          children: [
            PageView.builder(
              controller: pageController,
              onPageChanged: _onPageViewChange,
              itemBuilder: (context, index) {
                return pages.elementAt(index);
              },
              itemCount: pages.length,
            ),
            Positioned(
              bottom: 30,
              child: SizedBox(
                width: width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      pageIndicator(pages.length),
                      const Spacer(),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          side: const BorderSide(color: Colors.white, width: 1),
                        ),
                        onPressed: () async {
                          if (voiceFile != null) {
                            VoiceState state =
                                VoiceState.values.elementAt(_selectedPageIndex);
                            Voice voice = Voice(
                                text: text2say!,
                                userId: widget.userId,
                                state: state);
                            _showSnackBarSuccessfulyRecorded(context);
                            await FirebaseApi.addVoice(voiceFile!, voice);
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          }
                          setState(() {
                            voiceFile = null;
                          });
                          if (_selectedPageIndex == pages.length - 1) {
                            setState(() {
                              _selectedPageIndex = 0;
                            });
                            await pc.close();
                            await pageController.animateToPage(
                              0,
                              duration: const Duration(milliseconds: 2000),
                              curve: Curves.easeInOutQuad,
                            );
                            Navigator.pop(context);
                          } else {
                            pageController.animateToPage(
                              _selectedPageIndex >= pages.length
                                  ? 0
                                  : _selectedPageIndex + 1,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOutQuad,
                            );
                          }
                        },
                        child: const SizedBox(
                          height: 40,
                          width: 80,
                          child: Center(
                            child: Text(
                              "Suivant",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                // fontFamily: "MuseoSans700"),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // RawMaterialButton(
                      //   elevation: 2.0,
                      //   onPressed: () async {
                      //     if (voiceFile != null) {
                      //       Voice voice = Voice(
                      //           text: text2Say,
                      //           userId: widget.userId,
                      //           state: VoiceState.values
                      //               .elementAt(_selectedPageIndex));
                      //       _showSnackBarSuccessfulyRecorded(context);
                      //       await FirebaseApi.addVoice(voiceFile!, voice);
                      //       ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      //     }
                      //     setState(() {
                      //       voiceFile = null;
                      //     });
                      //     if (_selectedPageIndex == pages.length - 1) {
                      //       setState(() {
                      //         _selectedPageIndex = 0;
                      //       });
                      //       await pc.close();
                      //       await pageController.animateToPage(
                      //         0,
                      //         duration: const Duration(milliseconds: 2000),
                      //         curve: Curves.easeInOutQuad,
                      //       );
                      //       Navigator.pop(context);
                      //     } else {
                      //       pageController.animateToPage(
                      //         _selectedPageIndex >= pages.length
                      //             ? 0
                      //             : _selectedPageIndex + 1,
                      //         duration: const Duration(milliseconds: 400),
                      //         curve: Curves.easeInOutQuad,
                      //       );
                      //     }
                      //   },
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(30),
                      //   ),
                      //   fillColor: Colors.deepPurple[300]!,
                      //   child: const SizedBox(
                      //     height: 40,
                      //     width: 120,
                      //     child: Center(
                      //       child: Text(
                      //         "Suivant",
                      //         style: TextStyle(
                      //           color: Colors.white,
                      //           fontSize: 16,
                      //           fontWeight: FontWeight.bold,
                      //           // fontFamily: "MuseoSans700"),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _panel(int index) {
    String? text;
    if (index < pages.length - 1) {
      List<String> possibleTexts =
          Constants.textAssociatedToState[VoiceState.values.elementAt(index)]!;
      text = possibleTexts.elementAt(Utils.randint(0, possibleTexts.length));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          index < pages.length - 1
              ? Text(
                  "Sors nous ton meilleur jeu d'acteur possible en récitant le texte ci-dessous avec le mood associé.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.deepPurple[300],
                    fontWeight: FontWeight.bold,
                  ),
                )
              : const SizedBox.shrink(),
          const Spacer(),
          index < pages.length - 1
              ? Align(
                  alignment: Alignment.center,
                  child: Text(
                    text!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.deepPurple[200],
                      fontSize: 18,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          const Spacer(),
          Row(
            children: [
              pageIndicator(pages.length),
              const Spacer(),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  side: const BorderSide(color: Colors.white, width: 1),
                ),
                onPressed: () async {
                  if (voiceFile != null) {
                    Voice voice = Voice(
                        text: text!,
                        userId: widget.userId,
                        state: VoiceState.values.elementAt(_selectedPageIndex));
                    _showSnackBarSuccessfulyRecorded(context);
                    await FirebaseApi.addVoice(voiceFile!, voice);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  }
                  setState(() {
                    voiceFile = null;
                  });
                  if (_selectedPageIndex == pages.length - 1) {
                    setState(() {
                      _selectedPageIndex = 0;
                    });
                    await pc.close();
                    await pageController.animateToPage(
                      0,
                      duration: const Duration(milliseconds: 2000),
                      curve: Curves.easeInOutQuad,
                    );
                    Navigator.pop(context);
                  } else {
                    pageController.animateToPage(
                      _selectedPageIndex + 1,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOutQuad,
                    );
                  }
                },
                child: const SizedBox(
                  height: 40,
                  width: 120,
                  child: Center(
                    child: Text(
                      "Suivant",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        // fontFamily: "MuseoSans700"),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget pageIndicator(int length) {
    return Row(
      children: List.generate(
        2 * length - 1,
        (index) => index % 2 == 0
            ? AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 2 * _selectedPageIndex == index ? 20 : 7,
                height: 4,
                decoration: BoxDecoration(
                  color: 2 * _selectedPageIndex == index
                      ? Colors.white
                      : Colors.white70,
                  borderRadius: BorderRadius.circular(30),
                ),
              )
            : const SizedBox(width: 7),
      ),
    );
  }
}

void _showSnackBarSuccessfulyRecorded(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: const EdgeInsets.only(bottom: 20, left: 30, right: 30),
      backgroundColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      content: SizedBox(
        height: 30,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                "Envoi en cours",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              SizedBox(width: 20),
              SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                    color: Colors.black, strokeWidth: 1.5),
              ),
            ],
          ),
        ),
      ),
      duration: const Duration(seconds: 20),
    ),
  );
}

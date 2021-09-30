import 'package:fetch_voice_data/constants.dart';
import 'package:fetch_voice_data/firebase/firbase_api.dart';
import 'package:fetch_voice_data/firebase/model.dart';
import 'package:fetch_voice_data/record/record_voice.dart';
import 'package:fetch_voice_data/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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
    pages = VoiceState.values
        .map((state) => RecordPage(
              voiceState: state,
              width: widget.width,
              height: widget.height,
            ))
        .toList();

    Future.delayed(const Duration(seconds: 2), () {
      if (pc.isAttached) {
        pc.open();
      }
    });
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
        body: PageView.builder(
          controller: pageController,
          onPageChanged: _onPageViewChange,
          itemBuilder: (context, index) {
            return pages.elementAt(index);
          },
          itemCount: pages.length,
        ),
      ),
    );
  }

  Widget _panel(int index) {
    List<String> possibleTexts =
        Constants.textAssociatedToState[VoiceState.values.elementAt(index)]!;
    String text2Say =
        possibleTexts.elementAt(Utils.randint(0, possibleTexts.length));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
              "Sors nous ton meilleur jeu d'acteur possible en récitant le texte ci-dessous avec le mood associé.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.deepPurple[300],
                fontWeight: FontWeight.bold,
              )),
          const Spacer(),
          Align(
            alignment: Alignment.center,
            child: Text(
              text2Say,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.deepPurple[200],
                fontSize: 18,
              ),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              pageIndicator(pages.length),
              const Spacer(),
              RawMaterialButton(
                elevation: 2.0,
                onPressed: () async {
                  if (voiceFile != null) {
                    Voice voice = Voice(
                        text: text2Say,
                        userId: widget.userId,
                        state: VoiceState.values.elementAt(_selectedPageIndex));
                    await FirebaseApi.addVoice(voiceFile!, voice);
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
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        margin:
                            EdgeInsets.only(bottom: 20, left: 30, right: 30),
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        content: Container(
                          height: 40,
                          child: Center(
                            child: Text(
                              "Tu dois enregistrer un vocal pour passer au suivant !!",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        duration: Duration(milliseconds: 1300),
                      ),
                    );
                  }

                  // pageController.jumpToPage(
                  //   _selectedPageIndex >= pages.length ? 0 : _selectedPageIndex + 1,
                  // );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                fillColor: Colors.deepPurple[300]!,
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
                      ? Colors.deepPurple[300]!
                      : Colors.deepPurple[200]!,
                  borderRadius: BorderRadius.circular(30),
                ),
              )
            : const SizedBox(width: 7),
      ),
    );
  }
}

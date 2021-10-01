import 'package:fetch_voice_data/choice.dart';
import 'package:fetch_voice_data/record/record_home.dart';
import 'package:flutter/material.dart';

class ExplicationPage extends StatefulWidget {
  final String userId;
  final double height;
  final double width;
  const ExplicationPage(
      {Key? key,
      required this.userId,
      required this.height,
      required this.width})
      : super(key: key);

  @override
  _ExplicationPageState createState() => _ExplicationPageState();
}

class _ExplicationPageState extends State<ExplicationPage> {
  String text1 =
      "Nous sommes Samuel Lerman et Tanel Petelot, étudiants de CentraleSupélec et travaillons sur un projet reliant la voix et les émotions.";
  String text2 =
      "Nous avons besoin de toi pour entraîner des réseaux de neurones profonds, dont l’objectif";
  String text3 =
      "est de détecter les émotions directement avec la prosodie (le ton, le timbre, les fréquences) de la voix.";
  String text4 =
      "Pour ce faire, on te propose des textes associés à 8 émotions différentes. A toi de t’enregistrer en essayant de reproduire fidèlement l’émotion.";
  String text5 =
      "Sinon, tu peux aussi t'enregistrer pendant un temps très bref en jouant une émotion que tu renseignes en cliquant sur l'icône associée.";
  String text6 =
      "Rassure toi, tes enregistrements vocaux ne seront jamais publiés ou diffusés sur un site ou une application mobile, ni utilisés à des fins commerciales.";
  String text7 =
      "En participant à la constitution de cette base de données anonyme, tu acceptes qu'on utilise ces enregistrements à des activités de recherches et de production d'algorithmes.";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.pink[400]!.withOpacity(0.800),
            Colors.blue[300]!.withOpacity(0.800),
          ],
        )),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: widget.height * 0.12,
                      width: widget.height * 0.12,
                      child: Image(
                        image: AssetImage("assets/images/logo_femi_good.png"),
                      ),
                    ),
                    SizedBox(width: widget.width * 0.05),
                    SizedBox(
                      height: widget.height * 0.12,
                      width: widget.height * 0.12,
                      child: Image(
                        image: AssetImage("assets/images/neuralnetwork.png"),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        text1,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        text2,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        text3,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        text4,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        text5,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        text6,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        text7,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Align(
                  alignment: Alignment.center,
                  child: RawMaterialButton(
                    elevation: 2.0,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChoicePage(
                                    userId: widget.userId,
                                    width: widget.width,
                                    height: widget.height,
                                  )));
                      // MaterialPageRoute(
                      //     builder: (context) => RecordHome(
                      //           userId: widget.userId,
                      //           width: widget.width,
                      //           height: widget.height,
                      //         )));
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    fillColor: Colors.white,
                    child: const SizedBox(
                      width: 150,
                      child: Center(
                        child: Text(
                          "Je suis d'accord",
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            // fontFamily: "MuseoSans700"),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:fetch_voice_data/firebase/model.dart';
import 'package:fetch_voice_data/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:scidart/numdart.dart';

// List<Widget> computeCircles(List<double> radii) {

// }

class NodeDisposition {
  static List<Map<String, double>> defineCoordsRecordPage(
    int count,
    double height,
    double width,
    double dmax,
    double currentRadius,
  ) {
    List<Map<String, double>> coords = [];
    if (count > 1 && count <= 4) {
      List<double> thetas = findThetas(count, 0, 2 * pi);
      coords
          .addAll(coordsFromTheta(thetas, currentRadius, width, height, dmax));
    }
    return coords;
  }

  static List<Map<String, double>> defineCoordsRecordPage2(
    int count,
    double dmax,
    double currentRadius,
  ) {
    List<Map<String, double>> coords = [];
    if (count > 1 && count <= 4) {
      List<double> thetas = findThetas(count, 0, 2 * pi);
      coords.addAll(coordsFromTheta2(thetas, currentRadius, dmax));
    }
    return coords;
  }

  static Widget circleWidget(int count, double size, double dmax,
      double currentRadius, List<String> imagesUrls) {
    double height = size;
    double width = size;
    List<Map<String, double>> coords =
        defineCoordsRecordPage(count, height, width, dmax, currentRadius);

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

    List<Widget> widgets = coords
        .asMap()
        .map((index, coord) {
          return MapEntry(
            index,
            Positioned(
              bottom: coord["y"]! - (coord["size"]! ~/ 2),
              left: coord["x"]! - (coord["size"]! ~/ 2),
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
          );
        })
        .values
        .toList();
    List<Widget> allWidgets = [circle] + widgets;
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(border: Border.all(color: Colors.white)),
      child: Stack(
        children: allWidgets,
      ),
    );
  }

  static List<Map<String, double>> defineCoords(
      int count, double height, double width, double dmax, double padding) {
    List<Map<String, double>> coords = [
      {"x": width * 0.5, "y": (height * 0.5), "size": dmax}
    ];
    if (count > 1 && count <= 4) {
      double currentRadius = dmax + padding;
      List<double> thetas = findThetas(count - 1, 0, 2 * pi);
      coords
          .addAll(coordsFromTheta(thetas, currentRadius, width, height, dmax));
    } else if (count >= 5) {
      // Fill the first circle with five cards
      double currentRadius = dmax + padding;
      List<double> thetas = findThetas(3, 0, 2 * pi);
      coords
          .addAll(coordsFromTheta(thetas, currentRadius, width, height, dmax));

      // Then fill the second circle evenly on top and bottom
      // make sure that the widgets don't go off screen (use arcsin and arccos)
      currentRadius = 2 * dmax + padding;
      double thetaSpan = asin(width / (2 * (currentRadius + dmax)));
      double thetaBegin = acos(width / (2 * (currentRadius + dmax)));
      int rest = count - 4; // The widgets that are left to add

      if (rest == 1) {
        thetas = findThetas(rest, thetaBegin, thetaBegin + 2 * thetaSpan);
        coords.addAll(
            coordsFromTheta(thetas, currentRadius, width, height, dmax));
      } else {
        // Fill the top with half of the rest
        thetas =
            findThetas((rest ~/ 2), thetaBegin, thetaBegin + 2 * thetaSpan);
        coords.addAll(
            coordsFromTheta(thetas, currentRadius, width, height, dmax));

        // Fill the bottom with the rest
        thetas = findThetas(rest % 2 == 0 ? rest ~/ 2 : (rest ~/ 2) + 1,
            -(thetaBegin + 2 * thetaSpan), -thetaBegin);
        coords.addAll(
            coordsFromTheta(thetas, currentRadius, width, height, dmax));
      }
    }

    return coords;
  }

  static List<Map<String, double>> coordsFromTheta2(
      List<double> angles, double currentRadius, double dmax) {
    return angles.map((theta) {
      double x = currentRadius * cos(theta);
      double y = currentRadius * sin(theta);
      double size = Utils.rand(0.7 * dmax, dmax);
      return {"x": x, "y": y, "size": size};
    }).toList();
  }

  static List<Map<String, double>> coordsFromTheta(List<double> angles,
      double currentRadius, double width, double height, double dmax) {
    return angles.map((theta) {
      double x = (width / 2) + currentRadius * cos(theta);
      double y = (height / 2) + currentRadius * sin(theta);
      double size = Utils.rand(0.8 * dmax, dmax);
      return {"x": x, "y": y, "size": size};
    }).toList();
  }

  static List<double> findThetas(int count, double begin, double end) {
    List<double> thetas = end == 2 * pi
        ? linspace(begin, end, num: count + 1).sublist(0, count)
        : linspace(begin, end, num: count);
    List<double> randomThetas = thetas;
    if (count == 1) {
      randomThetas = [Utils.rand(begin, end)];
    } else {
      randomThetas =
          thetas.map((theta) => theta + Utils.rand(-0.08, 0.08)).toList();
    }
    return randomThetas;
  }
}

class RecordUI {
  static Color voiceStateToColor(VoiceState state) {
    List<Color> colors = const [
      Color(0xffeb4d4b), // red
      Color(0xffffbe76), // light orange
      Color(0xff686de0), // cold puprle blue
    ];
    return colors[state.index];
  }
}

class BackAndForthTween extends Tween<double> {
  final double delay;
  BackAndForthTween({double? begin, double? end, required this.delay})
      : super(begin: begin, end: end);
  @override
  double lerp(double t) {
    return super.lerp((sin(2 * pi * (t - delay)) + 1) / 2);
  }
}

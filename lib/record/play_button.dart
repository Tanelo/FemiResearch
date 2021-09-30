import 'dart:math' show pi;

import 'package:flutter/material.dart';

import 'blob.dart';

class PlayButton extends StatefulWidget {
  final ValueNotifier<bool> initialIsPlaying;
  final Icon playIcon;
  final Icon pauseIcon;
  final Gradient gradient;
  final VoidCallback onPressed;

  const PlayButton({
    Key? key,
    required this.initialIsPlaying,
    this.playIcon = const Icon(
      Icons.play_arrow,
    ),
    this.pauseIcon = const Icon(
      Icons.pause,
    ),
    required this.gradient,
    required this.onPressed,
  }) : super(key: key);
  @override
  _PlayButtonState createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> with TickerProviderStateMixin {
  static const _kToggleDuration = Duration(milliseconds: 300);
  static const _kRotationDuration = Duration(seconds: 5);

  // rotation and scale animations (2 controllers)
  late AnimationController _rotationController;
  late AnimationController _scaleController;

  late bool isPlaying;
  bool play = false;
  bool isFirst = true;
  double _rotation = 0;
  double _scale = 1;

  bool get _showWaves => !_scaleController.isDismissed;

  //façon rapide d'écrire des changements d'états
  void _updateRotation() => _rotation = _rotationController.value * 2 * pi;
  void _updateScale() => _scale = (_scaleController.value * 0.25) + 0.85;

  @override
  //on initie les controllers
  void initState() {
    isPlaying = widget.initialIsPlaying.value;
    //print(isPlaying);

    _rotationController =
        AnimationController(vsync: this, duration: _kRotationDuration)
          ..addListener(() => setState(_updateRotation))
          ..repeat();

    //listener pour le faire reconstruire (update rotation)
    _scaleController =
        AnimationController(vsync: this, duration: _kToggleDuration)
          ..addListener(() => setState(_updateScale));
    //listener pour le faire reconstruire (update rotation)

    if (isPlaying) {
      _onToggle();
    }
    super.initState();
  }

  void _onToggle() {
    setState(() {
      isPlaying = !isPlaying;
    });
    if (_scaleController.isCompleted) {
      _scaleController.reverse();
    } else {
      _scaleController.forward();
      //on continue la rotation (permet de gérer la rotation après
      //appui du boutton (onPressed))
    }
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    // play = widget.initialIsPlaying;
    // if (isFirst) {
    //   isFirst = false;
    //   if (play) {
    //     _onToggle();
    //   }
    //}

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 48, minHeight: 48),
      child: ValueListenableBuilder<bool>(
          valueListenable: widget.initialIsPlaying,
          builder: (context, value, child) {
            isPlaying = value;

            WidgetsBinding.instance!.addPostFrameCallback((_) {
              if (mounted) {
                if (!_scaleController.isAnimating) {
                  if (!isPlaying) {
                    _scaleController.reverse();
                  }
                }
                if (isFirst) {
                  if (isPlaying) {
                    _onToggle();
                    isFirst = false;
                  }
                }
              }
            });
            //print(isPlaying);
            return Stack(
              alignment: Alignment.center,
              children: [
                if (_showWaves) ...[
                  Blob(
                      color: Color(0xff0092ff),
                      scale: _scale,
                      rotation: _rotation),
                  Blob(
                      color: Color(0xff4ac7b7),
                      scale: _scale,
                      rotation: _rotation * 2 - 30),
                  Blob(
                      color: Color(0xffa4a6f6),
                      scale: _scale,
                      rotation: _rotation * 3 - 45),
                  Blob(
                      color: Colors.pink,
                      scale: _scale,
                      rotation: _rotation * 3 - 50),
                ],
                Container(
                  constraints: BoxConstraints.expand(),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: widget.gradient,
                    // gradient: Palette.backgroundGradient,
                  ),
                  child: AnimatedSwitcher(
                    child: SizedBox.expand(
                      key: ValueKey<bool>(isPlaying),
                      child: IconButton(
                        icon: isPlaying ? widget.pauseIcon : widget.playIcon,
                        onPressed: _onToggle,
                      ),
                    ),
                    duration: _kToggleDuration,
                  ),
                ),
              ],
            );
          }),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }
}

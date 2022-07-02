import 'dart:math';
import 'package:flutter/material.dart';

class ClipperCustom extends StatelessWidget {
  final BuildContext context;
  final String nameUI;
  final Color color1;
  final Color color2;
  const ClipperCustom({
    Key? key,
    required this.context,
    required this.nameUI,
    required this.color1,
    required this.color2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (nameUI == "Menu" || nameUI == "List") {
      return Positioned(
        child: Transform.rotate(
          angle: nameUI == "List" ? -pi / 2.9 : -pi / 3.5,
          child: ClipPath(
            clipper: ClipOne(),
            child: Container(
              height: size.height * .5,
              width: size.width,
              decoration: BoxDecoration(color: color1),
            ),
          ),
        ),
        top: nameUI == "List" ? -size.height * .32 : -size.height * .26,
        right: nameUI == "List" ? -size.width * .42 : -size.width * .4,
      );
    } else if (nameUI == "Forms") {
      return Stack(
        children: <Widget>[
          Positioned(
            child: ClipPath(
              clipper: OuterClippedPart(),
              child: Container(
                  color: color1, height: size.height, width: size.width),
            ),
            top: 0,
            right: 0,
          ),
          Positioned(
            child: ClipPath(
              clipper: InnerClippedPart(),
              child: Container(
                  color: color2, height: size.height, width: size.width),
            ),
            top: 0,
            right: 0,
          ),
        ],
      );
    } else {
      return Stack(
        children: <Widget>[
          Positioned(
            child: ClipPath(
              clipper: OuterClippedPart(),
              child: Container(
                  color: color1, height: size.height, width: size.width),
            ),
            top: 0,
            right: 0,
          ),
          Positioned(
            child: ClipPath(
              clipper: InnerClippedPart(),
              child: Container(
                  color: color2, height: size.height, width: size.width),
            ),
            top: 0,
            right: 0,
          ),
          Positioned(
            child: RotationTransition(
              turns: const AlwaysStoppedAnimation(45 / -90),
              child: ClipPath(
                clipper: OuterClippedPart(),
                child: Container(
                    color: color1, height: size.height, width: size.width),
              ),
            ),
            top: 0,
            right: 0,
          ),
          Positioned(
            child: RotationTransition(
              turns: const AlwaysStoppedAnimation(45 / -90),
              child: ClipPath(
                clipper: InnerClippedPart(),
                child: Container(
                    color: color2, height: size.height, width: size.width),
              ),
            ),
            top: 0,
            right: 0,
          ),
        ],
      );
    }
  }
}

class ClipOne extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var height = size.height;
    var width = size.width;
    var path = Path();

    path.lineTo(0, size.height);
    path.lineTo(size.width, height);
    path.lineTo(size.width, 0);

    /// [Top Left corner]
    var secondControlPoint = const Offset(0, 0);
    var secondEndPoint = Offset(width * .2, height * .3);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    /// [Left Middle]
    var fifthControlPoint = Offset(width * .3, height * .5);
    var fiftEndPoint = Offset(width * .23, height * .6);
    path.quadraticBezierTo(fifthControlPoint.dx, fifthControlPoint.dy,
        fiftEndPoint.dx, fiftEndPoint.dy);

    /// [Bottom Left corner]
    var thirdControlPoint = Offset(0, height);
    var thirdEndPoint = Offset(width, height);
    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy,
        thirdEndPoint.dx, thirdEndPoint.dy);

    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class OuterClippedPart extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    //
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height / 4);
    //
    path.cubicTo(size.width * 0.55, size.height * 0.16, size.width * 0.85,
        size.height * 0.05, size.width / 2, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class InnerClippedPart extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    //
    path.moveTo(size.width * 0.7, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.1);
    //
    path.quadraticBezierTo(
        size.width * 0.8, size.height * 0.11, size.width * 0.7, 0);

    //
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

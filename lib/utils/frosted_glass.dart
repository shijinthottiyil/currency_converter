import 'package:flutter/material.dart';
import 'dart:ui';

class FrostedGlassBox extends StatelessWidget {
  const FrostedGlassBox({
    super.key,
    required this.theWidth,
    required this.theHeight,
    required this.theChild,
  });
  final theWidth;
  final theHeight;
  final theChild;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: theWidth,
        height: theHeight,
        color: Colors.transparent,
        child: Stack(
          children: [
            //3 layers of stack to achieve the blur effect
            //blur Effect = bottom layer
            BackdropFilter(
              filter: ImageFilter.blur(
                //sigmaX => Horizontal blur
                //sigmaY => Vertical Blur
                sigmaX: 4.0,
                sigmaY: 4.0,
              ),
              child: Container(),
            ),

            //gradient effect = middle layer
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.13)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
              ),
            ),
            //child=top layer
          ],
        ),
      ),
    );
  }
}

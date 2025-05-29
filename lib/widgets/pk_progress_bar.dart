// lib/widgets/pk_progress_bar.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

class PKProgressBar extends StatelessWidget {
  final double maxWidth;
  final ValueNotifier<double> progressBarWidthFactor;

  static const Color leftBarColor = Color(0xFFFFBA3A);
  static const Color rightBarColor = Color(0xFFE0E0E0);

  const PKProgressBar({
    Key? key,
    required this.maxWidth,
    required this.progressBarWidthFactor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(// Listen to changes in the progressBarWidthFactor
      valueListenable: progressBarWidthFactor,
      builder: (context, currentFactor, child) {
        final double progressBarContainerWidth = maxWidth * 0.8;

        final double progressBarHeight = 28.0; 
        final double fistBackgroundSize = progressBarHeight * 2.2; 
        final double fistIconSize = progressBarHeight * 1.4;      

        return TweenAnimationBuilder<double>(
          tween: Tween<double>(
            begin: 0,
            end: currentFactor.isNaN ? 0 : currentFactor.clamp(0.0, 1.0),
          ),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          builder: (context, animatedFactor, child) {
            final double fistCenterX = progressBarContainerWidth * animatedFactor;

            return SizedBox( 
              width: progressBarContainerWidth,
              height: fistBackgroundSize,
              child: Stack(
                alignment: Alignment.center, 
                clipBehavior: Clip.none, 
                children: [
                  // Progress bar visual
                  Container(
                    width: progressBarContainerWidth,
                    height: progressBarHeight,
                    decoration: BoxDecoration(
                      color: rightBarColor,
                      borderRadius: BorderRadius.circular(progressBarHeight / 2),
                    ),
                    clipBehavior: Clip.antiAlias, 
                    child: FractionallySizedBox( //  orange part
                      alignment: Alignment.centerLeft,
                      widthFactor: animatedFactor,
                      child: Container(
                        decoration: BoxDecoration(
                          color: leftBarColor,
                          borderRadius: BorderRadius.circular(progressBarHeight / 2),
                        ),
                      ),
                    ),
                  ),

                  // Fist and its background
                  Positioned(
                    left: fistCenterX - (fistBackgroundSize / 2),
                    
                    child: SizedBox(
                      width: fistBackgroundSize,
                      height: fistBackgroundSize,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/images/fist-background.png',
                            width: fistBackgroundSize,
                            height: fistBackgroundSize,
                            fit: BoxFit.contain,
                          ),
                          Transform.rotate(
                            angle: math.pi / 2, // 90 degrees clockwise
                            child: Image.asset(
                              'assets/images/fist.png',
                              width: fistIconSize,
                              height: fistIconSize,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
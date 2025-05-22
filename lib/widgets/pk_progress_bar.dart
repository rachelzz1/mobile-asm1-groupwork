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
    return ValueListenableBuilder<double>(
      valueListenable: progressBarWidthFactor,
      builder: (context, currentFactor, child) {
        final double progressBarContainerWidth = maxWidth * 0.8;
        // Let's try increasing height first, as it might be necessary anyway for the rotated fist
        final double progressBarHeight = 28.0; // Increased height
        final double fistBackgroundSize = progressBarHeight * 2.2; // Adjusted multiplier
        final double fistIconSize = progressBarHeight * 1.4;      // Adjusted multiplier

        return TweenAnimationBuilder<double>(
          tween: Tween<double>(
            begin: 0,
            end: currentFactor.isNaN ? 0 : currentFactor.clamp(0.0, 1.0),
          ),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          builder: (context, animatedFactor, child) {
            final double fistCenterX = progressBarContainerWidth * animatedFactor;

            return SizedBox( // Use SizedBox to define the area for hit testing and layout
              width: progressBarContainerWidth,
              height: fistBackgroundSize, // Make the layout area tall enough for the overflowing fist background
              child: Stack(
                alignment: Alignment.center, // Center the progress bar within this taller SizedBox
                clipBehavior: Clip.none, // Allow children (fist) to overflow
                children: [
                  // Progress bar visual
                  Container(
                    width: progressBarContainerWidth,
                    height: progressBarHeight, // Actual visual height of the bar
                    decoration: BoxDecoration(
                      color: rightBarColor,
                      borderRadius: BorderRadius.circular(progressBarHeight / 2),
                    ),
                    clipBehavior: Clip.antiAlias, // Clip the colored parts of the bar
                    child: FractionallySizedBox( // This is the orange part
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
                    // top will be 0 because the Stack is centered and fistBackgroundSize is its height
                    // Or, more explicitly if Stack alignment wasn't .center:
                    // top: (fistBackgroundSize - fistBackgroundSize) / 2, which is 0
                    // The fist and its background will be centered within the fistBackgroundSize height
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
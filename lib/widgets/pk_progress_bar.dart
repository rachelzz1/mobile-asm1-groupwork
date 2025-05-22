// lib/widgets/pk_progress_bar.dart
import 'package:flutter/material.dart';

class PKProgressBar extends StatelessWidget {
  final double maxWidth;
  final ValueNotifier<double>
  progressBarWidthFactor; // Changed to ValueNotifier to match usage

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
        final double progressBarWidth = maxWidth * 0.8;
        final double progressBarHeight = 16;

        return TweenAnimationBuilder<double>(
          tween: Tween<double>(
            begin: 0, // Always animate from 0 if that's the desired effect
            end: currentFactor.isNaN ? 0 : currentFactor.clamp(0.0, 1.0),
          ),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          builder: (context, animatedFactor, child) {
            return Container(
              width: progressBarWidth,
              height: progressBarHeight,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: animatedFactor,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(12),
                        ),
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

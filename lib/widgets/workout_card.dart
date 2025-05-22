// widgets/workout_card.dart
import 'package:flutter/material.dart';
import 'package:video/exercise_video.dart';

class WorkoutCard extends StatelessWidget {
  final String title;
  final int duration;
  final String calories;
  final String characterImagePath;
  final String? backgroundImagePath;
  final Color backgroundColor;
  final double characterImageHeight;
  final String workoutIdentifier; // Used ONLY for the switch statement logic

  const WorkoutCard({
    super.key,
    required this.title,
    required this.duration,
    required this.calories,
    required this.characterImagePath,
    this.backgroundImagePath,
    required this.backgroundColor,
    this.characterImageHeight = 80,
    required this.workoutIdentifier,
  });

  Widget _buildKcalIcon() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Text(
        'kcal',
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        String cleanTitle = title.replaceAll("\n", " ");
        print(
          'WorkoutCard tapped: $cleanTitle (ID for routing: $workoutIdentifier)',
        );

        Widget? targetPage;

        // Navigate to different, parameter-less pages based on workoutIdentifier
        switch (workoutIdentifier) {
          case "slim_belly_yoga": // ID for "Sour and Refreshing Slim Belly"
            targetPage = const ExerciseVideo();
            break;
          case "boom_burpee_burn":
            //targetPage = const BurpeeDetailPage();
            break;
          case "groovy_dance_fit":
          //targetPage = const DanceFitDetailPage();
          case "plank_challenge":
            //targetPage = const PlankWorkoutDetailPage();
            break;
          default:
            print(
              "Warning: No specific page defined for workout ID '$workoutIdentifier'.",
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('No page available for "$cleanTitle" yet.'),
                duration: const Duration(seconds: 2),
              ),
            );
            return; // Exit if no target page is set
        }

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetPage!),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            if (backgroundImagePath != null)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Opacity(
                    opacity: 0.3,
                    child: Image.asset(
                      backgroundImagePath!,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    iconWidget: Icon(
                      Icons.access_time_rounded,
                      color: Colors.black.withOpacity(0.7),
                      size: 20,
                    ),
                    text: '$duration min',
                  ),
                  const SizedBox(height: 5),
                  _InfoRow(iconWidget: _buildKcalIcon(), text: calories),
                ],
              ),
            ),
            Positioned(
              bottom: 5,
              right: 5,
              child: Image.asset(
                characterImagePath,
                height: characterImageHeight,
                errorBuilder: (context, error, stackTrace) {
                  return SizedBox(
                    height: characterImageHeight,
                    width: characterImageHeight * 0.7,
                    child: const Icon(
                      Icons.sentiment_dissatisfied_outlined,
                      color: Colors.white54,
                      size: 40,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final Widget iconWidget;
  final String text;

  const _InfoRow({required this.iconWidget, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        iconWidget,
        const SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black.withOpacity(0.75),
          ),
        ),
      ],
    );
  }
}

// lib/widgets/pk_result_panel.dart
import 'package:flutter/material.dart';

class PKResultPanel extends StatelessWidget {
  final String winnerText;
  final String winnerAvatarPath;
  final double maxWidth; // Use this for responsive sizing within the panel
  final VoidCallback onClose;
  final VoidCallback onRematch;
  final VoidCallback onViewStats;

  const PKResultPanel({
    Key? key,
    required this.winnerText,
    required this.winnerAvatarPath,
    required this.maxWidth,
    required this.onClose,
    required this.onRematch,
    required this.onViewStats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final panelWidth = maxWidth * 0.85;
    final panelAvatarSize = panelWidth * 0.4;
    final buttonFontSize = panelWidth * 0.05;
    final titleFontSize = panelWidth * 0.09;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: panelWidth,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ), // Changed close icon color to black
                  onPressed: onClose,
                ),
              ),
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  if (winnerAvatarPath.isNotEmpty)
                    CircleAvatar(
                      radius: panelAvatarSize / 2,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: AssetImage(winnerAvatarPath),
                    ),
                  if (winnerAvatarPath.isEmpty && winnerText == "It's a Tie!")
                    Icon(
                      Icons.sentiment_neutral,
                      size: panelAvatarSize,
                      color: Colors.grey,
                    ),
                  Positioned(
                    top:
                        -panelAvatarSize *
                        0.2, // Corrected typo: changed panelAvatarAvatarSize to panelAvatarSize
                    child: Image.asset(
                      'assets/images/crown.png', // Ensure this is your crown PNG image's correct path
                      width: panelAvatarSize * 0.5, // Crown size
                      height: panelAvatarSize * 0.5, // Crown size
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                winnerText,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Flexible(
                    child: ElevatedButton.icon(
                      onPressed: onRematch,
                      icon: const Icon(Icons.whatshot, color: Colors.white),
                      label: Text(
                        "Rematch",
                        style: TextStyle(
                          fontSize: buttonFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFFEB7402,
                        ), // Changed Rematch button color
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: panelWidth * 0.05,
                          vertical: panelWidth * 0.035,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: ElevatedButton.icon(
                      onPressed: onViewStats,
                      icon: const Icon(
                        Icons.bar_chart,
                        color: Color(0xFF000000),
                      ), // Changed View Stats icon color
                      label: Text(
                        "View Stats",
                        style: TextStyle(
                          fontSize: buttonFontSize,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF000000),
                        ), // Changed View Stats text color
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFFD7E3FE,
                        ), // Changed View Stats button color
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(
                          horizontal: panelWidth * 0.05,
                          vertical: panelWidth * 0.035,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side:
                              BorderSide
                                  .none, // Removed outline from View Stats button
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

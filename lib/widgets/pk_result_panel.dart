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
    final panelAvatarSize = panelWidth * 0.4; // 这是直径
    final buttonFontSize = panelWidth * 0.05;
    final titleFontSize = panelWidth * 0.09;

    final baseCrownDimension = panelAvatarSize * 0.5;
    final crownWidth = baseCrownDimension * 1.4;
    final crownHeight = baseCrownDimension * 0.8;

    bool isTie = winnerText == "It's a Tie!";
    bool showAvatarAndCrown = winnerAvatarPath.isNotEmpty && !isTie;

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
                  ),
                  onPressed: onClose,
                ),
              ),
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  if (showAvatarAndCrown)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/crown.png',
                          width: crownWidth,
                          height: crownHeight,
                          fit: BoxFit.fill,
                        ),
                        CircleAvatar(
                          radius: panelAvatarSize / 2,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: AssetImage(winnerAvatarPath),
                        ),
                      ],
                    ),
                  if (isTie)
                    Padding(
                      padding: EdgeInsets.only(top: crownHeight + 0.0),
                      child: Icon(
                        Icons.sentiment_neutral,
                        size: panelAvatarSize,
                        color: Colors.grey,
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
                      label: Text( // "Rematch" 通常较短，可能不需要 FittedBox
                        "Rematch",
                        style: TextStyle(
                          fontSize: buttonFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEB7402),
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
                      ),
                      // 使用 FittedBox 包裹 "View Stats" 的 Text Widget
                      label: FittedBox(
                        fit: BoxFit.scaleDown, // 如果文本太长，则缩小文本以适应单行
                        child: Text(
                          "View Stats",
                          style: TextStyle(
                            fontSize: buttonFontSize, // 这是期望的字体大小
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF000000),
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD7E3FE),
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(
                          horizontal: panelWidth * 0.05,
                          vertical: panelWidth * 0.035,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide.none,
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
// lib/widgets/pk_result_panel.dart
import 'package:flutter/material.dart';

class PKResultPanel extends StatelessWidget {
  final String winnerText;         // 胜负文字
  final String winnerAvatarPath;   // 胜者头像图片路径
  final double maxWidth;           // 用于自适应布局的最大宽度
  final VoidCallback onClose;      // 关闭弹窗回调
  final VoidCallback onRematch;    // 再来一局回调
  final VoidCallback onViewStats;  // 查看数据回调

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
    final panelWidth = maxWidth * 0.85; // 弹窗宽度
    final panelAvatarSize = panelWidth * 0.4; // 头像尺寸
    final buttonFontSize = panelWidth * 0.05;
    final titleFontSize = panelWidth * 0.09;

    final baseCrownDimension = panelAvatarSize * 0.5;
    final crownWidth = baseCrownDimension * 1.4;
    final crownHeight = baseCrownDimension * 0.8;

    bool isTie = winnerText == "It's a Tie!"; // 是否平局
    bool showAvatarAndCrown = winnerAvatarPath.isNotEmpty && !isTie; // 是否显示头像和皇冠

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
              // 右上角关闭按钮
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
              // 头像、皇冠或平局表情
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  if (showAvatarAndCrown)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 皇冠图片
                        Image.asset(
                          'assets/images/crown.png',
                          width: crownWidth,
                          height: crownHeight,
                          fit: BoxFit.fill,
                        ),
                        // 胜者头像
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
              // 胜负文字
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
              // 操作按钮区
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // 再来一局按钮
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
                  // 查看数据按钮
                  Flexible(
                    child: ElevatedButton.icon(
                      onPressed: onViewStats,
                      icon: const Icon(
                        Icons.bar_chart,
                        color: Color(0xFF000000),
                      ),
                      label: FittedBox(
                        fit: BoxFit.scaleDown, 
                        child: Text(
                          "View Stats",
                          style: TextStyle(
                            fontSize: buttonFontSize, 
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
// PKAttributeComparisonContainer：PK属性对比动画组件，负责依次播放属性动画、更新进度条、播放音效，并在全部完成后回调

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:audioplayers/audioplayers.dart';
import '../config/pk_attribute_data.dart'; // 导入属性数据结构

class PKAttributeComparisonContainer extends StatefulWidget {
  final double parentWidth; // 父容器宽度，用于自适应布局
  final ValueNotifier<bool> onAllAnimationsComplete; // 动画完成回调
  final ValueNotifier<double> progressBarWidthFactor; // 进度条宽度（胜率）
  final Map<String, int> leftAttributes; // 当前用户的属性数据

  const PKAttributeComparisonContainer({
    Key? key,
    required this.parentWidth,
    required this.onAllAnimationsComplete,
    required this.progressBarWidthFactor,
    required this.leftAttributes,
  }) : super(key: key);

  @override
  State<PKAttributeComparisonContainer> createState() =>
      _PKAttributeComparisonContainerState();
}

class _PKAttributeComparisonContainerState
    extends State<PKAttributeComparisonContainer>
    with TickerProviderStateMixin {
  late final List<AttributeData> _attributes; // 属性数据列表

  int _currentAttributeIndex = 0; // 当前正在播放动画的属性索引

  List<AnimationController> _controllers = []; // 动画控制器列表
  List<Animation<int>> _leftValueAnimations = []; // 左侧属性动画
  List<Animation<int>> _rightValueAnimations = []; // 右侧属性动画
  List<bool> _animationCompleted = []; // 每个属性动画是否完成

  int _totalLeftValue = 0; // 左侧总分
  int _totalRightValue = 0; // 右侧总分

  final AudioPlayer _audioPlayer = AudioPlayer(); // 属性对比音效播放器

  @override
  void initState() {
    super.initState();
    widget.onAllAnimationsComplete.value = false;

    // 用传入的 leftAttributes 构造属性数据
    _attributes = [
      AttributeData(
        iconPath: 'assets/icons/Endurance.svg',
        name: "Endurance",
        leftValue: widget.leftAttributes['endurance'] ?? 0,
        rightValue: 20,
      ),
      AttributeData(
        iconPath: 'assets/icons/Explosiveness.svg',
        name: "Burst",
        leftValue: widget.leftAttributes['burst'] ?? 0,
        rightValue: 23,
      ),
      AttributeData(
        iconPath: 'assets/icons/Strength.svg',
        name: "Strength",
        leftValue: widget.leftAttributes['strength'] ?? 0,
        rightValue: 35,
      ),
      AttributeData(
        iconPath: 'assets/icons/Flexibility.svg',
        name: "Flexibility",
        leftValue: widget.leftAttributes['flexibility'] ?? 0,
        rightValue: 45,
      ),
      // 总分项
      AttributeData(
        iconPath: '',
        name: "Total",
        leftValue: (widget.leftAttributes['endurance'] ?? 0) +
            (widget.leftAttributes['burst'] ?? 0) +
            (widget.leftAttributes['strength'] ?? 0) +
            (widget.leftAttributes['flexibility'] ?? 0),
        rightValue: 20 + 23 + 35 + 45,
      ),
    ];

    // 初始化动画控制器和动画
    _controllers.forEach((controller) => controller.dispose());
    _controllers = [];
    _leftValueAnimations = [];
    _rightValueAnimations = [];
    _animationCompleted = [];
    _currentAttributeIndex = 0;

    for (var attribute in _attributes) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 800),
        vsync: this,
      );
      _controllers.add(controller);

      // 左右属性值动画
      _leftValueAnimations.add(
        IntTween(begin: 0, end: attribute.leftValue).animate(controller),
      );
      _rightValueAnimations.add(
        IntTween(begin: 0, end: attribute.rightValue).animate(controller),
      );
      _animationCompleted.add(false);
    }
    _startNextAnimation(); // 开始第一个属性动画
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _audioPlayer.dispose();
    super.dispose();
  }

  // 依次播放每个属性动画，动画完成后更新进度条和播放音效，全部完成后回调
  void _startNextAnimation() async {
    if (_currentAttributeIndex < _attributes.length) {
      _controllers[_currentAttributeIndex].forward().then((_) async {
        if (mounted) {
          setState(() {
            _animationCompleted[_currentAttributeIndex] = true;
            _totalLeftValue += _attributes[_currentAttributeIndex].leftValue;
            _totalRightValue += _attributes[_currentAttributeIndex].rightValue;

            // 动态更新进度条宽度（胜率）
            if (_totalLeftValue + _totalRightValue > 0) {
              widget.progressBarWidthFactor.value =
                  _totalLeftValue / (_totalLeftValue + _totalRightValue);
            } else {
              widget.progressBarWidthFactor.value = 0.0;
            }
          });

          // 播放音效（只对前4项属性，最后一项Total不播放）
          if (_currentAttributeIndex < 4) {
            final left = _attributes[_currentAttributeIndex].leftValue;
            final right = _attributes[_currentAttributeIndex].rightValue;
            if (left > right) {
              await _audioPlayer.play(AssetSource('audios/win.wav'));
            } else if (left < right) {
              await _audioPlayer.play(AssetSource('audios/lose.wav'));
            }
          }

          // 全部属性动画完成，触发回调
          if (_currentAttributeIndex == _attributes.length - 1) {
            widget.onAllAnimationsComplete.value = true;
          } else {
            // 延迟后播放下一个属性动画
            Future.delayed(const Duration(milliseconds: 400), () {
              if (mounted) {
                setState(() {
                  _currentAttributeIndex++;
                  _startNextAnimation();
                });
              }
            });
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double rowHeight = widget.parentWidth * 0.18;
    final double fontSize = widget.parentWidth * 0.05;
    final double spacing = rowHeight * 0.15;

    return Column(
      children: [
        // 依次渲染已播放动画的属性行
        for (
          int i = 0;
          i <= _currentAttributeIndex && i < _attributes.length;
          i++
        )
          Padding(
            padding: EdgeInsets.only(
              bottom: i < _currentAttributeIndex ? spacing : 0,
            ),
            child: AnimatedBuilder(
              animation: _controllers[i],
              builder: (context, child) {
                final attribute = _attributes[i];
                final leftAnimatedValue = _leftValueAnimations[i].value;
                final rightAnimatedValue = _rightValueAnimations[i].value;
                final showValues = _controllers[i].value > 0;
                bool currentUserWinsAttribute = false;
                if (_animationCompleted[i]) {
                  currentUserWinsAttribute =
                      attribute.leftValue > attribute.rightValue;
                }

                return FadeTransition(
                  opacity: _controllers[i].drive(
                    CurveTween(curve: Curves.easeInOutCubic),
                  ),
                  child: SizedBox(
                    width: widget.parentWidth * 0.8,
                    child: Container(
                      height: rowHeight,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: currentUserWinsAttribute
                            ? Border.all(color: Colors.orange, width: 3) // 胜出属性高亮橙色边框
                            : null,
                        boxShadow: currentUserWinsAttribute
                            ? [
                                BoxShadow(
                                  color: Colors.orange.withOpacity(0.2), // 胜出属性橙色阴影
                                  offset: const Offset(2, 2),
                                  blurRadius: 8,
                                ),
                              ]
                            : [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08), // 失败属性灰色阴影
                                  offset: const Offset(2, 2),
                                  blurRadius: 8,
                                ),
                              ],
                      ),
                      child: Row(
                        children: [
                          // 左侧分数
                          Expanded(
                            flex: 1,
                            child: Text(
                              showValues ? "$leftAnimatedValue" : "",
                              style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          // 属性名和图标
                          Expanded(
                            flex: 3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (attribute.iconPath.isNotEmpty)
                                  SvgPicture.asset(
                                    attribute.iconPath,
                                    width: fontSize * 1.3,
                                    height: fontSize * 1.3,
                                    colorFilter: const ColorFilter.mode(
                                      Colors.black,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                if (attribute.iconPath.isNotEmpty)
                                  const SizedBox(width: 8.0),
                                Text(
                                  attribute.name,
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // 右侧分数
                          Expanded(
                            flex: 1,
                            child: Text(
                              showValues ? "$rightAnimatedValue" : "",
                              style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

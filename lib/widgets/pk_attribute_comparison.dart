// lib/widgets/pk_attribute_comparison.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../config/pk_attribute_data.dart'; // Import AttributeData

class PKAttributeComparisonContainer extends StatefulWidget {
  final double parentWidth;
  final ValueNotifier<bool> onAllAnimationsComplete;
  final ValueNotifier<double> progressBarWidthFactor; // To update the progress

  const PKAttributeComparisonContainer({
    Key? key,
    required this.parentWidth,
    required this.onAllAnimationsComplete,
    required this.progressBarWidthFactor,
  }) : super(key: key);

  @override
  State<PKAttributeComparisonContainer> createState() =>
      _PKAttributeComparisonContainerState();
}

class _PKAttributeComparisonContainerState
    extends State<PKAttributeComparisonContainer>
    with TickerProviderStateMixin {
  final List<AttributeData> _attributes = [
    AttributeData(
      iconPath: 'assets/icons/Endurance.svg',
      name: "Endurance",
      leftValue: 25,
      rightValue: 20,
    ),
    AttributeData(
      iconPath: 'assets/icons/Explosiveness.svg',
      name: "Explosiveness",
      leftValue: 22,
      rightValue: 23,
    ),
    AttributeData(
      iconPath: 'assets/icons/Strength.svg',
      name: "Strength",
      leftValue: 40,
      rightValue: 35,
    ),
    AttributeData(
      iconPath: 'assets/icons/Flexibility.svg',
      name: "Flexibility",
      leftValue: 2,
      rightValue: 45,
    ),
    AttributeData(
      iconPath: '',
      name: "Total",
      leftValue: 25 + 22 + 40 + 2,
      rightValue: 20 + 23 + 35 + 45,
    ),
  ];

  int _currentAttributeIndex = 0;
  List<AnimationController> _controllers = [];
  List<Animation<int>> _leftValueAnimations = [];
  List<Animation<int>> _rightValueAnimations = [];
  List<bool> _animationCompleted = [];

  int _totalLeftValue = 0;
  int _totalRightValue = 0;

  @override
  void initState() {
    super.initState();
    widget.onAllAnimationsComplete.value = false;

    _totalLeftValue = 0;
    _totalRightValue = 0;
    // Do not reset progressBarWidthFactor here, parent (PKBattleScreen) manages its initial value.

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
      _leftValueAnimations.add(
        IntTween(begin: 0, end: attribute.leftValue).animate(controller),
      );
      _rightValueAnimations.add(
        IntTween(begin: 0, end: attribute.rightValue).animate(controller),
      );
      _animationCompleted.add(false);
    }
    _startNextAnimation();
  }

  void _startNextAnimation() {
    if (_currentAttributeIndex < _attributes.length) {
      _controllers[_currentAttributeIndex].forward().then((_) {
        if (mounted) {
          setState(() {
            _animationCompleted[_currentAttributeIndex] = true;
            _totalLeftValue += _attributes[_currentAttributeIndex].leftValue;
            _totalRightValue += _attributes[_currentAttributeIndex].rightValue;

            if (_totalLeftValue + _totalRightValue > 0) {
              widget.progressBarWidthFactor.value =
                  _totalLeftValue / (_totalLeftValue + _totalRightValue);
            } else {
              widget.progressBarWidthFactor.value = 0.0;
            }
          });

          if (_currentAttributeIndex == _attributes.length - 1) {
            widget.onAllAnimationsComplete.value = true;
          } else {
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
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double rowHeight = widget.parentWidth * 0.18;
    final double fontSize = widget.parentWidth * 0.05;
    final double spacing = rowHeight * 0.15;

    return Column(
      children: [
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
                        border:
                            currentUserWinsAttribute
                                ? Border.all(color: Colors.orange, width: 3)
                                : null,
                        boxShadow:
                            currentUserWinsAttribute
                                ? [
                                  BoxShadow(
                                    color: Colors.orange.withOpacity(0.2),
                                    offset: const Offset(2, 2),
                                    blurRadius: 8,
                                  ),
                                ]
                                : [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    offset: const Offset(2, 2),
                                    blurRadius: 8,
                                  ),
                                ],
                      ),
                      child: Row(
                        children: [
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

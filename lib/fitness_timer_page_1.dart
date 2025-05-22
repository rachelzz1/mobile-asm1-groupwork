// fitness_timer_page_1.dart

import 'package:flutter/material.dart';
import 'dart:async';
import 'progress_painter.dart';

import 'package:video/videoplayerwidget.dart';
import 'fitness_timer_page_2.dart';

//test-yyf
class FitnessTimerPage1 extends StatefulWidget {
  @override
  _FitnessTimerPage1State createState() => _FitnessTimerPage1State();
}

class _FitnessTimerPage1State extends State<FitnessTimerPage1> {
  final String _exerciseName = 'Breathing Core';
  final String _imagePath = 'assets/images/exercise1.png';
  static const double _totalDuration = 3.0;

  double _elapsedTime = 0.0;
  Timer? _timer;
  bool _isRunning = false;
  DateTime? _startTime;

  void _startOrPauseTimer() {
    if (_isRunning) {
      _timer?.cancel();
    } else {
      if (_elapsedTime >= _totalDuration) {
        return;
      }
      _startTime = DateTime.now().subtract(
        Duration(milliseconds: (_elapsedTime * 1000).round()),
      );
      _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
        setState(() {
          _elapsedTime =
              DateTime.now().difference(_startTime!).inMilliseconds / 1000.0;

          if (_elapsedTime >= _totalDuration) {
            _elapsedTime = _totalDuration;
            _timer?.cancel();
            _isRunning = false;
          }
        });
      });
    }
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = _elapsedTime / _totalDuration;
    if (progress > 1.0) progress = 1.0;

    int remainingSeconds = (_totalDuration - _elapsedTime).ceil();
    if (remainingSeconds < 0) remainingSeconds = 0;

    const double fontSizeLarge = 24.0;
    const double fontSizeMedium = 18.0;
    const double iconSize = 48.0;
    const double navIconSize = 40.0;
    const double infoIconSize = 20.0;
    const double customPaintSize = 200.0;
    const double imageSize = 160.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Fitness Timer 1/2",
          style: TextStyle(fontSize: fontSizeMedium),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20.0),
          onPressed: () {
            _stopTimer();
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 28.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _exerciseName,
                    style: const TextStyle(
                      fontSize: fontSizeLarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.info_outline,
                      size: infoIconSize,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      _stopTimer();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const VideoPlayerPage(
                                videoUrl: 'assets/videos/ex1.mp4',
                              ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            Text(
              '$remainingSeconds seconds left',
              style: const TextStyle(
                fontSize: fontSizeMedium,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 70),

            Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(customPaintSize, customPaintSize),
                  painter: ProgressPainter(progress, _imagePath),
                ),
                ClipOval(
                  child: Image.asset(
                    _imagePath,
                    width: imageSize,
                    height: imageSize,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),

            Text(
              'Elapsed time: ${_elapsedTime.toStringAsFixed(1)} s',
              style: const TextStyle(
                fontSize: fontSizeMedium,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    shape: const CircleBorder(),
                  ),
                  child: Icon(Icons.skip_previous, size: navIconSize),
                ),
                const SizedBox(width: 30),

                ElevatedButton(
                  onPressed: _startOrPauseTimer,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    shape: const CircleBorder(),
                  ),
                  child: Icon(
                    _isRunning ? Icons.pause : Icons.play_arrow,
                    size: iconSize,
                  ),
                ),
                const SizedBox(width: 30),

                ElevatedButton(
                  onPressed: () {
                    _stopTimer();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FitnessTimerPage2(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    shape: const CircleBorder(),
                  ),
                  child: Icon(Icons.skip_next, size: navIconSize),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

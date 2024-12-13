import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:async';

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  String _elapsedTime = "00:00:00";

  void _startStopwatch() {
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
      _timer = Timer.periodic(const Duration(milliseconds: 100), _updateTime);
    }
  }

  void _stopStopwatch() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _timer?.cancel();
    }
  }

  void _resetStopwatch() {
    _stopwatch.reset();
    _updateTime(null);
  }

  void _updateTime(Timer? timer) {
    final int milliseconds = _stopwatch.elapsedMilliseconds;
    final int hundreds = (milliseconds / 10).truncate();
    final int seconds = (hundreds / 100).truncate();
    final int minutes = (seconds / 60).truncate();

    setState(() {
      _elapsedTime =
          "${minutes.toString().padLeft(2, '0')} : ${(seconds % 60).toString().padLeft(2, '0')} : ${(hundreds % 100).toString().padLeft(2, '0')}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Enhanced Stopwatch",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularPercentIndicator(
              radius: 120.0,
              lineWidth: 13.0,
              percent:
                  (_stopwatch.elapsedMilliseconds % 60000 / 60000).toDouble(),
              center: Text(
                _elapsedTime,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              progressColor: Colors.blue,
              backgroundColor: Colors.grey.shade300,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  heroTag: 'startButton',
                  onPressed: _startStopwatch,
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.play_arrow),
                ),
                FloatingActionButton(
                  heroTag: 'stopButton',
                  onPressed: _stopStopwatch,
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.stop),
                ),
                FloatingActionButton(
                  heroTag: 'resetButton',
                  onPressed: _resetStopwatch,
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.refresh),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

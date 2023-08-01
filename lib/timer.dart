import 'package:flutter/material.dart';
import 'dart:async';

class TimerWidget extends StatefulWidget {
  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}
class _TimerWidgetState extends State<TimerWidget> {
  // Timer duration (in seconds)
  int _timerDuration = 5000; // Example: 60 seconds

  // Variable to hold the current time remaining
  int _currentTime = 0;

  // Timer object
  Timer? _timer;

  // Function to be executed when the timer expires
  void _onTimerComplete() {
    // Implement actions to perform when the timer expires
    print("Timer complete!");
  }

  // Function to start the timer
  void _startTimer() {
    // Initialize the timer with the specified duration
    _timer = Timer.periodic(Duration(milliseconds: 100), (Timer timer) {
      // Update the time remaining
      print("Hello");
      setState(() {
        _currentTime = _timerDuration - timer.tick;
      });

      // Check if the timer has completed
      if (timer.tick >= _timerDuration) {
        timer.cancel(); // Cancel the timer
        _onTimerComplete(); // Execute the timer completion function
      }
    });
  }

  // Function to stop the timer
  void _stopTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
      setState(() {
        _currentTime = 0;
      });
    }
  }

  @override
  void dispose() {
    // Dispose the timer when the widget is removed from the widget tree
    _timer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timer Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Time Remaining: $_currentTime seconds',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startTimer,
              child: Text('Start Timer'),
            ),
            ElevatedButton(
              onPressed: _stopTimer,
              child: Text('Stop Timer'),
            ),
          ],
        ),
      ),
    );
  }
}
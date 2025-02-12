import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HeartbeatApp(),
  ));
}

class HeartbeatApp extends StatefulWidget {
  @override
  _HeartbeatAppState createState() => _HeartbeatAppState();
}

class _HeartbeatAppState extends State<HeartbeatApp>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();

    // Heartbeat animation
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Confetti falling from top
    _confettiController = ConfettiController(duration: Duration(seconds: 10));
    _confettiController.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: Stack(
        children: [
          // Confetti falling from the top of the screen
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2, // Downward direction
              maxBlastForce: 10, // Adjust speed
              minBlastForce: 5,
              emissionFrequency: 0.05, // Controls density of confetti
              numberOfParticles: 10,
              gravity: 0.3,
              shouldLoop: true,
              colors: [Colors.red, Colors.pink, Colors.purple],
            ),
          ),

          // Pulsating heart at the center
          Center(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _animation.value,
                  child: Icon(
                    Icons.favorite, // Proper heart shape
                    color: Colors.red,
                    size: 150,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
//Bhavya Sri Sai-002893685
//Madhuri Tumula-002892521

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
  TextEditingController _textController = TextEditingController();
  String displayedMessage = "";

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

    // Confetti falling from the top
    _confettiController = ConfettiController(duration: Duration(seconds: 10));
    _confettiController.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _updateMessage() {
    setState(() {
      displayedMessage = _textController.text;
    });
  }

  void _resetMessage() {
    setState(() {
      displayedMessage = "";  // Clears the message
      _textController.clear();  // Clears the text input
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Confetti falling from the top
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2, // Confetti falls downward
              maxBlastForce: 10, // Adjust speed
              minBlastForce: 5,
              emissionFrequency: 0.05, // Controls density
              numberOfParticles: 10,
              gravity: 0.3,
              shouldLoop: true,
              colors: [Colors.red, Colors.pink, Colors.purple],
            ),
          ),

          SizedBox(height: 100), // Space before heart

          // Pulsating heart at the center
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.scale(
                scale: _animation.value,
                child: Icon(
                  Icons.favorite, // Red heart
                  color: Colors.red,
                  size: 150,
                ),
              );
            },
          ),

          SizedBox(height: 20),

          // Display the entered message
          if (displayedMessage.isNotEmpty)
            Text(
              displayedMessage,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.redAccent),
              textAlign: TextAlign.center,
            ),

          SizedBox(height: 30),

          // Message Input Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: "Enter your message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: 15),

          // Button to update the message
          ElevatedButton(
            onPressed: _updateMessage,
            child: Text("Display Message"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          SizedBox(height: 10),

          // Reset Button
          ElevatedButton(
            onPressed: _resetMessage,
            child: Text("Reset"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
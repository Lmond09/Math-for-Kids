import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

class CompareNumbersPage extends StatefulWidget {
  const CompareNumbersPage({super.key});

  @override
  _CompareNumbersPageState createState() => _CompareNumbersPageState();
}

class _CompareNumbersPageState extends State<CompareNumbersPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int number1 = 0;
  int number2 = 0;
  int attemptsLeft = 3;
  String message = "";
  Color color1 = Colors.blue;
  Color color2 = Colors.blue;
  double scale1 = 1.0;
  double scale2 = 1.0;
  bool isAnswerSelected = false;
  bool isChoosingBigger = true; // Determines if user must pick the bigger or smaller number

  @override
  void initState() {
    super.initState();
    _generateNumbers();
  }

  void _playSound(String sound) async {
    await _audioPlayer.stop();
    String assetPath = "audio/$sound.mp3"; // Ensure path matches your assets
    try {
      await _audioPlayer.play(AssetSource(assetPath));
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  void _generateNumbers() {
    final random = Random();
    number1 = random.nextInt(999) + 1;
    number2 = random.nextInt(999) + 1;
    while (number1 == number2) {
      number2 = random.nextInt(999) + 1;
    }

    // Randomly decide if the user should pick the bigger or smaller number
    isChoosingBigger = random.nextBool();

    setState(() {
      message = isChoosingBigger ? "🔼 Pick the Bigger Number!" : "🔽 Pick the Smaller Number!";
      color1 = Colors.blue;
      color2 = Colors.blue;
      scale1 = 1.0;
      scale2 = 1.0;
      isAnswerSelected = false;
    });
  }

  void _checkAnswer(int chosenNumber) {
    if (isAnswerSelected) return;

    setState(() {
      isAnswerSelected = true;
    });

    int correctAnswer = isChoosingBigger ? max(number1, number2) : min(number1, number2);

    if (chosenNumber == correctAnswer) {
      _playSound("correct");
      setState(() {
        message = "🎉 Correct! Next Round...";
        if (chosenNumber == number1) {
          scale1 = 1.3;
          color1 = Colors.green;
        } else {
          scale2 = 1.3;
          color2 = Colors.green;
        }
      });

      Future.delayed(const Duration(seconds: 1), _generateNumbers);
    } else {
      _playSound("wrong");
      setState(() {
        attemptsLeft--;
        if (chosenNumber == number1) {
          color1 = Colors.red;
        } else {
          color2 = Colors.red;
        }

        if (attemptsLeft == 0) {
          _showGameOverDialog();
        } else {
          message = "❌ Wrong! Attempts left: $attemptsLeft. Try again!";
          Future.delayed(const Duration(seconds: 1), _generateNumbers);
        }
      });
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("❌Game Over"),
          content: const Text("You used all your chances! What would you like to do?"),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  attemptsLeft = 3;
                  _generateNumbers();
                });
                Navigator.of(context).pop();
              },
              child: const Text("Try Again"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Return to Homepage
              },
              child: const Text("Return Home"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNumberBlock(int number, Color color, double scale) {
    return GestureDetector(
      onTap: () => _checkAnswer(number),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 140,
        height: 140,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6, spreadRadius: 2)],
        ),
        child: Transform.scale(
          scale: scale,
          child: Text(
            "$number",
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compare Numbers')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNumberBlock(number1, color1, scale1),
                _buildNumberBlock(number2, color2, scale2),
              ],
            ),
            const SizedBox(height: 30),
            Text("Chances Left: $attemptsLeft", style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}

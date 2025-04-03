import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

class MathComposerGame extends StatefulWidget {
  const MathComposerGame({super.key});

  @override
  State<MathComposerGame> createState() => _MathComposerGameState();
}

class _MathComposerGameState extends State<MathComposerGame> {
  late int targetNumber;
  List<int> numbers = [];
  List<int> selectedNumbers = [];
  int score = 0;
  int attemptsLeft = 3;
  String message = "Combine two numbers to make";
  bool isCelebrating = false;
  final AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _generateNewPuzzle();
  }

  void _generateNewPuzzle() {
    final random = Random();
    targetNumber = random.nextInt(16) + 5; // Generates targets between 5-12
    numbers = _generateValidNumbers(targetNumber);
    
    setState(() {
      selectedNumbers.clear();
      isCelebrating = false;
      message = "Combine two numbers to make $targetNumber";
    });
  }

  List<int> _generateValidNumbers(int target) {
  final random = Random();
  final numbers = <int>{};

  while (numbers.length < 3) {
    int num = random.nextInt(target - 1) + 1;
    numbers.add(num);
    numbers.add(target - num);
  }

  while (numbers.length < 6) {
    numbers.add(random.nextInt(20) + 1);
  }

  return numbers.toList()..shuffle();
}


  void _handleNumberSelect(int number) {
    if (selectedNumbers.length == 2 || attemptsLeft <= 0) return;

    setState(() {
      selectedNumbers.add(number);
    });

    if (selectedNumbers.length == 2) {
      _checkAnswer();
    }
  }

  void _checkAnswer() {
    final sum = selectedNumbers.reduce((a, b) => a + b);
    
    if (sum == targetNumber) {
      player.play(AssetSource('audio/correct.mp3'));
      setState(() {
        score += 10;
        isCelebrating = true;
        message = "🌟 Great job! ${selectedNumbers[0]} + ${selectedNumbers[1]} = $targetNumber";
      });
      
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          message = "Combine two numbers to make $targetNumber";
          _generateNewPuzzle();
        });
      });
    } else {
      player.play(AssetSource('audio/wrong.mp3'));
      setState(() {
        attemptsLeft--;
        message = "❌ Try again! ${selectedNumbers[0]} + ${selectedNumbers[1]} = $sum";
      });
      
      Future.delayed(const Duration(seconds: 1), () {
        setState(() => selectedNumbers.clear());
      });
      
      if (attemptsLeft == 0) {
        _showGameOver();
      }
    }
  }

  void _showGameOver() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("❌Game Over!"),
        content: Text("Your score: $score"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                score = 0;
                attemptsLeft = 3;
                _generateNewPuzzle();
              });
            },
            child: const Text("Play Again"),
          ),
           // Go back to Home Page
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text("Go Home"),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberBox(int number) {
    final isSelected = selectedNumbers.contains(number);
    
    return GestureDetector(
      onTap: () => _handleNumberSelect(number),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.blue,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            if (isCelebrating)
              const BoxShadow(
                color: Colors.yellow,
                blurRadius: 20,
                spreadRadius: 2,
              ),
          ],
        ),
        margin: const EdgeInsets.all(8),
        child: Center(
          child: Text(
            '$number',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Composer'),
        actions: [Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text("Score: $score")),
        )],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              message,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('$targetNumber',
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
            ),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.2,
              ),
              itemCount: numbers.length,
              itemBuilder: (context, index) => _buildNumberBox(numbers[index]),
            ),
            Text("Chances left: $attemptsLeft",
              style: TextStyle(
                fontSize: 18,
                color: attemptsLeft == 1 ? Colors.red : Colors.black)),
          ],
        ),
      ),
    );
  }
}
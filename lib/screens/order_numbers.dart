import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart'; // For listEquals
import 'package:flutter/gestures.dart'; // For DragStartBehavior


class OrderNumbersPage extends StatefulWidget {
  const OrderNumbersPage({super.key});

  @override
  _OrderNumbersPageState createState() => _OrderNumbersPageState();
}

class _OrderNumbersPageState extends State<OrderNumbersPage> {
  List<int> numbers = [];
  bool isAscending = true;
  int maxNumber = 999; // 3-digit limit
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _generateNumbers();
  }

  void _generateNumbers() {
    Random random = Random();
    numbers = List.generate(4, (_) => random.nextInt(maxNumber));
    isAscending = random.nextBool(); // Randomly choose ascending or descending order
    setState(() {});
  }

  void _playSound(String type) async {
    String path = type == "correct" ? "assets/correct.mp3" : "assets/wrong.mp3";
    try {
      await player.play(AssetSource(path));
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  void _checkOrder() {
    List<int> correctOrder = List.from(numbers)..sort();
    if (!isAscending) {
      correctOrder = correctOrder.reversed.toList();
    }

    bool isCorrect = listEquals(numbers, correctOrder);
    _playSound(isCorrect ? "correct" : "wrong");
    _showResultDialog(isCorrect ? "🎉 Congratulations! You got it right!" : "❌ Oops! Try again.", isCorrect);
  }

  void _showResultDialog(String message, bool isCorrect) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(message, textAlign: TextAlign.center),
        actions: [
          if (!isCorrect) // Show "Retry" only when the answer is wrong
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Retry"),
            ),

          // Generate new numbers (New Game)
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _generateNumbers();
            },
            child: Text("New Game"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order Numbers')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Tutorial Section
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text(
                  "📖 How to Play?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Drag the numbers into the correct order and press Submit.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Divider(thickness: 2),

          // Order Instruction
          Text(
            "Arrange in ${isAscending ? "Ascending" : "Descending"} Order",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isAscending ? Colors.green : Colors.red,
            ),
          ),
          Text(
            isAscending ? "⬆️ Smallest to Largest" : "⬇️ Largest to Smallest",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20),

          // Draggable List
          Expanded(
            child: ReorderableListView(
              padding: EdgeInsets.symmetric(horizontal: 30),
              dragStartBehavior: DragStartBehavior.down, // Starts immediately on tap
              children: numbers.map((num) {
                return ListTile(
                  key: ValueKey(num),
                  title: Container(
                    alignment: Alignment.center,
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "$num",
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                );
              }).toList(),
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex--; // Fix index shift issue
                  final movedNumber = numbers.removeAt(oldIndex);
                  numbers.insert(newIndex, movedNumber);
                });
              },
            ),
          ),

          SizedBox(height: 20),

          // Submit Button
          ElevatedButton(
            onPressed: _checkOrder,
            child: Text("Submit✅"),
          ),

          SizedBox(height: 20),

          // Refresh Button
          ElevatedButton(
            onPressed: _generateNumbers,
            child: Text("New Numbers🔀"),
          ),
        ],
      ),
    );
  }
}

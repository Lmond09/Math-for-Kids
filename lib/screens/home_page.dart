import 'package:flutter/material.dart';
import 'compare_numbers.dart';
import 'order_numbers.dart';
import 'compose_numbers.dart';

class HomePage extends StatelessWidget {
  final PageController _pageController = PageController(viewportFraction: 0.85);

  HomePage({super.key}); // Allows slight visibility of the next card

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Math for Kids',
          style: TextStyle(
            fontFamily: 'Comic Sans MS',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),

           // Welcome Message
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              """🎉 Welcome! 🎉
Let's Learn Math in a Fun Way! """,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          
          SizedBox(height: 10),

          Expanded(
            child: SizedBox(
              height: 600, // Adjust based on your UI needs
              child: PageView.builder(
                controller: _pageController,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return _buildGameCard(
                    context,
                    [
                      {'title': 'Compare Numbers', 'image': 'assets/images/compare.png', 'page': CompareNumbersPage()},
                      {'title': 'Order Numbers', 'image': 'assets/images/order.png', 'page': OrderNumbersPage()},
                      {'title': 'Compose Numbers', 'image': 'assets/images/compose.png', 'page': MathComposerGame()},
                    ][index],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, Map<String, dynamic> data) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => data['page']),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 50, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(data['image'], height: 300), 
            SizedBox(height: 10),
            Text(
              data['title'],
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

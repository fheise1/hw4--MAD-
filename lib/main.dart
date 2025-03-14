import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HW 4',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Cards'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> images = [
    'A', 'A', 'B', 'B', 'C', 'C', 'D', 'D',
    'E', 'E', 'F', 'F', 'G', 'G', 'H', 'H'
  ];
  List<bool> flipped = List.filled(16, false);
  List<int> selectedIndexes = [];

  @override
  void initState() {
    super.initState();
    images.shuffle(Random());
  }

  void flipCard(int index) {
    if (selectedIndexes.length < 2 && !flipped[index]) {
      setState(() {
        flipped[index] = true;
        selectedIndexes.add(index);
      });

      if (selectedIndexes.length == 2) {
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            if (images[selectedIndexes[0]] != images[selectedIndexes[1]]) {
              flipped[selectedIndexes[0]] = false;
              flipped[selectedIndexes[1]] = false;
            }
            selectedIndexes.clear();
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.deepPurple,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => flipCard(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                borderRadius: BorderRadius.circular(8.0),
              ),
              alignment: Alignment.center,
              child: flipped[index]
                  ? Text(images[index], style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold))
                  : const Text('?', style: TextStyle(fontSize: 32, color: Colors.white)),
            ),
          );
        },
      ),
    );
  }
}
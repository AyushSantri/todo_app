import 'package:flutter/material.dart';

class Description extends StatelessWidget {
  const Description({Key? key, required this.title, required this.description})
      : super(key: key);
  final String title, description;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Description'),
      ),
      body: Column(
        children: [
          Text(title),
          Text(description),
        ],
      ),
    );
    ;
  }
}

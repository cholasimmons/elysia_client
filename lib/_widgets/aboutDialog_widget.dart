import 'package:flutter/material.dart';

Widget aboutApp() {
  return const Material(
    child: Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('About', style: TextStyle(fontSize: 24)),
        SizedBox(height: 16.0),
        Text('Elysia Tester v1.0'),
        Text(
          'Simmons Studio',
          style: TextStyle(color: Colors.amber),
        ),
      ],
    )),
  );
}

import 'package:flutter/material.dart';

class AllVideosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todos os Vídeos'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Aqui serão listados todos os vídeos futuramente.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

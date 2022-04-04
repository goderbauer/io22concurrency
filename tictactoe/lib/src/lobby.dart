import 'package:flutter/material.dart';

import 'concurrent_game_engine.dart';
import 'game_engine.dart';

typedef StartGameCallback = void Function(GameEngine engine);

class Lobby extends StatelessWidget {
  const Lobby({Key? key, required this.onStartGame}) : super(key: key);

  final StartGameCallback onStartGame;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          child: const Text('Sync Engine'),
          onPressed: () {
            onStartGame(GameEngine());
          },
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          child: const Text('Isolate Engine'),
          onPressed: () {
            onStartGame(ConcurrentGameEngine());
          },
        ),
      ],
    );
  }
}

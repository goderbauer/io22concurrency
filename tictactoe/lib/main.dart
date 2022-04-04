import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import 'src/dash.dart';
import 'src/game_engine.dart';
import 'src/game_board.dart';
import 'src/lobby.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dish Dash Doe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TicTacToe(),
    );
  }
}

class TicTacToe extends StatefulWidget {
  const TicTacToe({Key? key}) : super(key: key);

  @override
  State<TicTacToe> createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  GameEngine? _engine;
  UiState? _uiState;

  final ConfettiController _controller = ConfettiController(
    duration: const Duration(seconds: 10),
  );

  Future<void> _startGame(GameEngine engine) async {
    setState(() {
      _engine = engine;
    });
    final UiState state = await _engine!.start();
    setState(() {
      _uiState = state;
    });
  }

  Future<void> _reportMove(int row, int col) async {
    UiState state = await _engine!.reportMove(row, col);
    setState(() {
      _uiState = state;
    });
    if (!state.gameOver) {
      // Ask Dash to make the next move.
      state = await _engine!.makeMove();
      setState(() {
        _uiState = state;
      });
    } else if (state.winner == Player.human) {
      _controller.play();
    }
  }

  void _reset() {
    setState(() {
      _engine?.dispose();
      _engine = null;
      _uiState = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConfettiWidget(
      confettiController: _controller,
      blastDirectionality: BlastDirectionality.explosive,
      maxBlastForce: 100,
      emissionFrequency: 0.05,
      numberOfParticles: 50,
      gravity: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dish Dash Doe'),
          actions: [
            IconButton(
              onPressed: _reset,
              icon: const Icon(Icons.restart_alt),
            ),
          ],
        ),
        body: Row(
          children: [
            SizedBox(
              width: 340,
              child: Center(
                child: _engine == null
                    ? Lobby(onStartGame: _startGame)
                    : _uiState != null
                        ? GameBoard(uiState: _uiState!, onMove: _reportMove)
                        : const Text('Loading...'),
              ),
            ),
            Expanded(
              child: Dash(
                dancing: _engine != null && _uiState?.gameOver != true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

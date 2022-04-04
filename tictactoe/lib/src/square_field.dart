import 'package:flutter/material.dart';

import 'game_engine.dart';

typedef MoveCallback = Future<void> Function(int row, int col);

class SquareField extends StatelessWidget {
  const SquareField({
    Key? key,
    required this.uiState,
    required this.onMove,
  }) : super(key: key);

  final UiState uiState;
  final MoveCallback onMove;

  Widget? _markAtSquare(int col, int row) {
    switch (uiState.markAtSquare(col, row)) {
      case Player.dash:
        return const Icon(Icons.flutter_dash, size: 50);
      case Player.human:
        return const Icon(Icons.person, size: 50);
      case null:
        return null;
    }
  }

  VoidCallback? _tapHandler(int col, int row) {
    if (uiState.currentTurn == Player.human &&
        uiState.markAtSquare(col, row) == null) {
      return () => onMove(col, row);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int row = 0; row < 3; row++)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int col = 0; col < 3; col++)
                  InkWell(
                    onTap: _tapHandler(row, col),
                    child: Container(
                      height: 80,
                      width: 80,
                      color: Colors.grey[300],
                      margin: EdgeInsets.only(
                        top: row == 0 ? 0 : 5,
                        left: col == 0 ? 0 : 5,
                      ),
                      child: Center(
                        child: _markAtSquare(row, col),
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

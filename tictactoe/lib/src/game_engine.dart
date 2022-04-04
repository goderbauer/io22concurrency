import 'dart:io';
import 'dart:math';

// Interface

abstract class GameEngine {
  factory GameEngine() = _GameEngine;

  Future<UiState> start();
  Future<UiState> reportMove(int row, int col);
  Future<UiState> makeMove();
  void dispose();
}

abstract class UiState {
  bool get gameOver;
  Player? get winner;
  Player? get currentTurn;
  Player? markAtSquare(int row, int col);
}

enum Player {
  dash,
  human,
}

// Implementation

class _GameEngine implements GameEngine {
  _UiState _uiState = _UiState.start();

  @override
  Future<UiState> start() async {
    _uiState = _UiState.start();
    return _uiState;
  }

  @override
  Future<UiState> reportMove(int row, int col) async {
    _uiState = _computeNewState(_UiState.toSquareIndex(row, col), Player.human);
    return _uiState;
  }

  @override
  Future<UiState> makeMove() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _uiState = _computeDashMove();
    return _uiState;
  }

  @override
  void dispose() {
    // nothing to do.
  }

  _UiState _computeNewState(int squareIndex, Player player) {
    assert(_uiState.currentTurn == player);
    assert(!_uiState.gameOver);
    assert(_uiState._squares[squareIndex] == null);

    final List<Player?> squares = [..._uiState._squares]..[squareIndex] =
        player;
    final bool didWin = _didWin(player, squares);
    final bool gameOver =
        didWin || squares.every((Player? player) => player != null);

    return _UiState(
      squares: squares,
      winner: didWin ? player : null,
      gameOver: gameOver,
      currentTurn: gameOver
          ? null
          : (player == Player.dash ? Player.human : Player.dash),
    );
  }

  final Random _random = Random();

  _UiState _computeDashMove() {
    assert(!_uiState.gameOver);
    int nextMove;
    do {
      nextMove = _random.nextInt(9);
      // Dash is a slow thinker and hogs the CPU while thinking.
      sleep(const Duration(seconds: 2));
    } while (_uiState._squares[nextMove] != null);
    return _computeNewState(nextMove, Player.dash);
  }

  bool _didWin(Player player, List<Player?> squares) {
    return (squares[0] == player &&
            squares[1] == player &&
            squares[2] == player) ||
        (squares[3] == player &&
            squares[4] == player &&
            squares[5] == player) ||
        (squares[6] == player &&
            squares[7] == player &&
            squares[8] == player) ||
        (squares[0] == player &&
            squares[4] == player &&
            squares[8] == player) ||
        (squares[2] == player &&
            squares[4] == player &&
            squares[6] == player) ||
        (squares[0] == player &&
            squares[3] == player &&
            squares[6] == player) ||
        (squares[1] == player &&
            squares[4] == player &&
            squares[7] == player) ||
        (squares[2] == player && squares[5] == player && squares[8] == player);
  }
}

class _UiState implements UiState {
  _UiState({
    required List<Player?> squares,
    required this.winner,
    required this.gameOver,
    required this.currentTurn,
  }) : _squares = squares;

  factory _UiState.start() {
    return _UiState(
      squares: List.filled(9, null),
      winner: null,
      gameOver: false,
      currentTurn: Player.human,
    );
  }

  final List<Player?> _squares;

  @override
  final Player? winner;
  @override
  final bool gameOver;
  @override
  final Player? currentTurn;

  @override
  Player? markAtSquare(int row, int col) {
    return _squares[toSquareIndex(row, col)];
  }

  static int toSquareIndex(int row, int col) {
    return col + row * 3;
  }
}

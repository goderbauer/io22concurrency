import 'dart:async';
import 'dart:isolate';

import 'package:async/async.dart';

import 'game_engine.dart';

class ConcurrentGameEngine implements GameEngine {
  Isolate? _isolate;
  SendPort? _sendPort;

  final ReceivePort _receivePort = ReceivePort();
  late final StreamQueue _receiveQueue = StreamQueue(_receivePort);

  @override
  Future<UiState> start() async {
    if (_isolate == null) {
      _isolate = await Isolate.spawn(_isolateEntryPoint, _receivePort.sendPort);
      _sendPort = await _receiveQueue.next;
    }
    _sendPort!.send('start');
    return await _receiveQueue.next;
  }

  @override
  Future<UiState> reportMove(int row, int col) async {
    _sendPort!.send([row, col]);
    return await _receiveQueue.next;
  }

  @override
  Future<UiState> makeMove() async {
    _sendPort!.send('makeMove');
    return await _receiveQueue.next;
  }

  @override
  void dispose() {
    _receiveQueue.cancel();
    _receivePort.close();
    _isolate?.kill();
    _isolate = null;
  }
}

void _isolateEntryPoint(SendPort sendPort) {
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);

  final  engine = GameEngine();

  receivePort.listen((Object? message) async {
    if (message == 'start') {
      sendPort.send(await engine.start());
    } else if (message == 'makeMove') {
      sendPort.send(await engine.makeMove());
    } else if (message is List<int> && message.length == 2) {
      sendPort.send(await engine.reportMove(message.first, message.last));
    }
  });
}

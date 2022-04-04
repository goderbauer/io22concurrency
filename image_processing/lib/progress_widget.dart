import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class ProgressWidget extends StatelessWidget {
  const ProgressWidget({
    Key? key,
    required bool show,
  })  : _show = show,
        super(key: key);

  final bool _show;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: _show ? 1.0 : 0.0,
        child: Container(
          color: Colors.white.withOpacity(.8),
          child: const Center(
            child: LoadingIndicator(
              indicatorType: Indicator.ballGridPulse,
              colors: [
                Colors.red,
                Colors.orange,
                Colors.yellow,
                Colors.green,
                Colors.blue,
                Colors.indigo,
                Colors.purple,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

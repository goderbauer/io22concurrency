import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rive/rive.dart';

class Dash extends StatefulWidget {
  const Dash({Key? key, required this.dancing}) : super(key: key);

  final bool dancing;

  @override
  State<Dash> createState() => _DashState();
}

class _DashState extends State<Dash> {
  final SimpleAnimation _idle = SimpleAnimation('idle');
  late final SimpleAnimation _dance = SimpleAnimation(
    'slowDance',
    autoplay: widget.dancing,
  );

  @override
  void didUpdateWidget(covariant Dash oldWidget) {
    super.didUpdateWidget(oldWidget);
    _dance.isActive = widget.dancing;
  }

  @override
  void dispose() {
    _idle.dispose();
    _dance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RiveAnimation.asset(
      'assets/dash.riv',
      controllers: [
        _idle,
        _dance,
      ], // idle, lookUp, slowDance
    );
  }
}

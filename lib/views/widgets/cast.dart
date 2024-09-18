import 'package:flutter/material.dart';
import 'package:looneytube/application/cast_controller.dart';
import 'package:looneytube/views/widgets/cast_button.dart';

class Cast extends StatefulWidget {
  const Cast({
    Key? key,
    required this.hiddenButton,
    required this.onSessionStarted,
    required this.onSessionEnded
  }) : super(key: key);

  final VoidCallback onSessionStarted;
  final VoidCallback onSessionEnded;
  final bool hiddenButton;

  @override
  _CastState createState() => _CastState();
}

class _CastState extends State<Cast> {
  late CastController _controller;

  @override
  void initState() {
    setState(() {
      _controller = CastController(
          sessionStartedListener: widget.onSessionStarted,
          sessionEndedListener: widget.onSessionEnded
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CastButton(
      controller: _controller,
      hidden: widget.hiddenButton,
    );
  }
}

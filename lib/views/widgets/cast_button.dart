import 'package:cast/cast.dart';
import 'package:flutter/material.dart';
import 'package:looneytube/application/cast_controller.dart';
import 'package:looneytube/views/widgets/cast_device_selector.dart';

class CastButton extends StatefulWidget {
  const CastButton({
    Key? key,
    required this.controller,
    required this.hidden,
  }) : super(key: key);

  final CastController controller;

  final bool hidden;

  @override
  _CastButtonState createState() => _CastButtonState();
}

class _CastButtonState extends State<CastButton> {
  @override
  Widget build(BuildContext context) {
    return !widget.hidden ? IconButton(
        onPressed: () => {
          if (!widget.controller.isSessionConnected()) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(child: CastDeviceSelector(
                    onDeviceSelected: (CastDevice device) {
                      widget.controller.startSession(device).then((v) => {
                        Navigator.pop(context)
                      });
                    },
                  ));
                }
            )
          } else {
            widget.controller.endSession()
          }
        },
        icon: Icon(
          widget.controller.isSessionConnected() ? Icons.cast_connected : Icons.cast,
          color: const Color.fromARGB(255, 220, 145, 140),
          size: 24.0,
          semanticLabel: 'Cast',
        )
    ) : const SizedBox.shrink();
  }
}

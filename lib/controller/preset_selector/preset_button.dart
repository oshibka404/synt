import 'package:flutter/material.dart';

/// Button switching keyboard presets.
/// Can handle [onTap], [onTapDown], [onTapUp]. Can be [active]
class PresetButton extends StatefulWidget {
  PresetButton({
    this.onTapDown,
    this.onTapUp,
    this.onTap,
    this.active = false,
    this.size = const Size.square(100),
    this.color = Colors.orange,
  });

  final Function onTapDown;
  final Function onTapUp;
  final Function onTap;
  final bool active;
  final Size size;
  final ColorSwatch color;

  @override
  State<StatefulWidget> createState() => _PresetButtonState();
}

class _PresetButtonState extends State<PresetButton> {
  bool isPressed = false;

  void unpress() {
    setState(() {
      isPressed = false;
    });
    if (widget.onTapUp != null) {
      widget.onTapUp();
    }
  }

  void press() {
    setState(() {
      isPressed = true;
    });
    if (widget.onTapDown != null) {
      widget.onTapDown();
    }
  }

  getColor() {
    if (isPressed) {
      return widget.color[700];
    } else {
      return widget.active ? widget.color[500] : widget.color[200];
    }
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        press();
      },
      onTapUp: (details) {
        unpress();
      },
      onTap: widget.onTap,
      onTapCancel: unpress,
      child: ConstrainedBox(
          constraints: BoxConstraints.tight(widget.size),
          child: DecoratedBox(
              decoration: new BoxDecoration(
            color: getColor(),
          ))),
    );
  }
}

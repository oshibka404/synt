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
    this.activeColor = Colors.amber,
  });

  final Function onTapDown;
  final Function onTapUp;
  final Function onTap;
  final bool active;
  final Size size;
  final MaterialColor color;
  final MaterialColor activeColor;

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
            color: isPressed ? widget.activeColor : widget.color,
            border: widget.active ? Border.all(
              color: widget.activeColor,
              width: 8
            ) : null,
          )
        )
      ),
    );
  }
}

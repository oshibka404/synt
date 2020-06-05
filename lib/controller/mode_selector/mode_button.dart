import 'package:flutter/material.dart';

/// Button switching keyboard modes.
/// Can handle [onTap], [onTapDown], [onTapUp]. Can be [active]
class ModeButton extends StatefulWidget {
  ModeButton({
    this.onTapDown,
    this.onTapUp,
    this.onTap,
    this.active = false,
    this.size = const Size.square(100),
    this.color = Colors.amber,
    this.activeColor = Colors.amberAccent,
  });

  final Function onTapDown;
  final Function onTapUp;
  final Function onTap;
  final bool active;
  final Size size;
  final Color color;
  final Color activeColor;

  @override
  State<StatefulWidget> createState() => _ModeButtonState();
}

class _ModeButtonState extends State<ModeButton> {
  bool isPressed = false;
  
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        setState(() {
          isPressed = true;
        });
        if (widget.onTapDown != null) {
          widget.onTapDown();
        }
      },
      onTapUp: (TapUpDetails details) {
        setState(() {
          isPressed = false;
        });
        if (widget.onTapUp != null) {
          widget.onTapUp();
        }
      },
      onTap: widget.onTap,
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

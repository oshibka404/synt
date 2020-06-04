import 'package:flutter/material.dart';

/// Button triggering actions [onTap], [onTapDown], [onTapUp].
/// Can potentially have [active] state
class Trigger extends StatefulWidget {
  Trigger({
    this.onTapDown,
    this.onTapUp,
    this.onTap,
    this.active,
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
  State<StatefulWidget> createState() => _TriggerState();
}

class _TriggerState extends State<Trigger> {
  bool isTapped = false;
  
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        setState(() {
          isTapped = true;
        });
        if (widget.onTapDown != null) {
          widget.onTapDown();
        }
      },
      onTapUp: (TapUpDetails details) {
        setState(() {
          isTapped = false;
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
            color: isTapped ? widget.activeColor : widget.color,
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

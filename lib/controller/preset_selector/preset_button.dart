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

  LinearGradient getGradient() {
    if (isPressed) {
      return LinearGradient(colors: [
        widget.color[200].withOpacity(.8),
        widget.color[900].withOpacity(.8)
      ]);
    } else {
      return LinearGradient(colors: [widget.color[200], widget.color[900]]);
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
                  border: widget.active
                      ? Border(
                          top: BorderSide(
                              width: 4,
                              color: Theme.of(context).backgroundColor),
                          left: BorderSide(
                              width: 4,
                              color: Theme.of(context).backgroundColor),
                          bottom: BorderSide(
                              width: 4,
                              color: Theme.of(context).backgroundColor),
                        )
                      : null,
                  gradient: getGradient()))),
    );
  }
}

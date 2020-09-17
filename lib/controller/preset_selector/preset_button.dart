import 'package:flutter/material.dart';

/// Button switching keyboard presets.
/// Can handle [onTap], [onTapDown], [onTapUp]. Can be [active]
class PresetButton extends StatefulWidget {
  final Function onTapDown;

  final Function onTapUp;
  final Function onTap;
  final bool active;
  final Size size;
  final ColorSwatch color;
  PresetButton({
    this.onTapDown,
    this.onTapUp,
    this.onTap,
    this.active = false,
    this.size = const Size.square(100),
    this.color = Colors.orange,
  });

  @override
  State<StatefulWidget> createState() => _PresetButtonState();
}

class _PresetButtonState extends State<PresetButton> {
  bool isPressed = false;

  Widget build(BuildContext context) {
    var borderWidth = 3.0;
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
                              width: borderWidth,
                              color: Theme.of(context).backgroundColor),
                          left: BorderSide(
                              width: borderWidth,
                              color: Theme.of(context).backgroundColor),
                          bottom: BorderSide(
                              width: borderWidth,
                              color: Theme.of(context).backgroundColor),
                        )
                      : null,
                  gradient: getGradient()))),
    );
  }

  LinearGradient getGradient() {
    if (isPressed) {
      return LinearGradient(colors: [
        widget.color['light'].withOpacity(.8),
        widget.color['main'].withOpacity(.8)
      ]);
    } else {
      return LinearGradient(
          colors: [widget.color['light'], widget.color['main']]);
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

  void unpress() {
    setState(() {
      isPressed = false;
    });
    if (widget.onTapUp != null) {
      widget.onTapUp();
    }
  }
}

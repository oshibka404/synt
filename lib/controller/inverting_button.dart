import 'package:flutter/material.dart';

class InvertingButton extends StatefulWidget {
  final Color color;
  final Function onTap;
  final Function onLongPress;
  final IconData iconData;
  final Size size;
  InvertingButton({
    this.color,
    this.onTap,
    this.onLongPress,
    this.iconData,
    this.size,
  });

  @override
  State<StatefulWidget> createState() => InvertingButtonState();
}

class InvertingButtonState extends State<InvertingButton> {
  bool _pressed = false;
  Widget build(BuildContext context) {
    var pressedDecoration = BoxDecoration(
      color: Theme.of(context).backgroundColor,
    );
    var decoration = BoxDecoration(
      gradient: widget.color is ColorSwatch<int>
          ? LinearGradient(colors: [
              (widget.color as ColorSwatch)[200],
              (widget.color as ColorSwatch)[900],
            ])
          : null,
      color: widget.color,
    );

    return GestureDetector(
      child: Container(
        constraints: BoxConstraints.tight(Size.square(widget.size.width)),
        decoration: _pressed ? pressedDecoration : decoration,
        child: Icon(
          widget.iconData,
          color: _pressed ? widget.color : Theme.of(context).backgroundColor,
        ),
      ),
      onTap: widget.onTap,
      onTapDown: (_) {
        setState(() {
          _pressed = true;
        });
      },
      onTapCancel: () {
        setState(() {
          _pressed = false;
        });
      },
      onTapUp: (_) {
        setState(() {
          _pressed = false;
        });
      },
      onLongPress: widget.onLongPress,
    );
  }
}

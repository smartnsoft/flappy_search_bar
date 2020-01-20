import 'package:flutter/material.dart';

class CancelButtonStyle {
  final Color backgroundColor;
  final EdgeInsetsGeometry margin;
  final BorderRadius borderRadius;
  final Widget content;

  const CancelButtonStyle(
      {this.backgroundColor = const Color.fromRGBO(142, 142, 147, .15),
      this.margin = const EdgeInsets.all(5.0),
      this.borderRadius: const BorderRadius.all(Radius.circular(5.0)),
      this.content = const Text('Cancel')});
}

import 'package:flutter/material.dart';

class NoAnimationRoute<T> extends MaterialPageRoute<T> {
  NoAnimationRoute({required super.builder});

  @override
  Duration get transitionDuration => Duration.zero;

  @override
  Duration get reverseTransitionDuration => Duration.zero;
}

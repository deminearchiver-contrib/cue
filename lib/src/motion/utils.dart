import 'package:flutter/material.dart';

/// A factory function that creates [Tween<T>] instances.
///
/// Used to defer tween creation with custom implementations for specific types.
/// Example: `ColorTween.new` for color tweens, or `Tween<T>.new` as default.
typedef TweenBuilder<T> = Tween<T> Function({T? begin, T? end});

part of 'base/act.dart';

/// Animates widget padding.
///
/// Smoothly transitions padding from one [EdgeInsets] value to another.
/// Useful for creating spacing animations or opening/closing panels.
class PaddingAct extends TweenAct<EdgeInsetsGeometry> {
  @override
  final ActKey key = const ActKey('Padding');

  /// {@template act.padding}
  /// Animates padding values.
  ///
  /// [from] defaults to `EdgeInsets.zero` (no padding). [to] also defaults to zero.
  /// Padding values are clamped between zero and infinity during animation.
  ///
  /// ## Basic padding animation
  ///
  /// ```dart
  /// Actor(
  ///   acts: [
  ///     .padding(to: EdgeInsets.all(16)), // from defaults to EdgeInsets.zero
  ///   ],
  ///   child: MyWidget(),
  /// )
  /// ```
  ///
  /// ## Directional padding animation
  ///
  /// ```dart
  /// .padding(
  ///   from: .symmetric(horizontal: 8),
  ///   to: .symmetric(horizontal: 24, vertical: 12),
  /// )
  /// ```
  ///
  /// ## Reverse example
  ///
  /// ```dart
  /// actor.onToggle(
  ///   toggled: isExpanded,
  ///   child: Actor(
  ///     acts: [
  ///       .padding(to: .all(16), reverse: ReverseBehavior.mirror()),
  ///     ],
  ///     child: MyContent(),
  ///   ),
  /// )
  /// // When toggled, padding expands/collapses with symmetric motion
  /// ```
  /// {@endtemplate}
  const PaddingAct({
    super.from = EdgeInsets.zero,
    super.to = EdgeInsets.zero,
    super.motion,
    super.reverse,
    super.delay,
  }) : super.tween();

  /// {@template act.padding.keyframed}
  /// Animates padding through multiple keyframe states.
  ///
  /// [frames] defines the animation keyframes (type `Keyframes<EdgeInsetsGeometry>`).
  ///
  /// ## Fractional keyframes (0.0 to 1.0 progress)
  ///
  /// ```dart
  /// PaddingAct.keyframed(
  ///   frames: Keyframes.fractional([
  ///     .key(EdgeInsets.all(8), at: 0.5),
  ///     .key(EdgeInsets.all(16), at: 1.0),
  ///   ], duration: 500.ms, curve: Curves.easeInOut),
  /// )
  /// ```
  ///
  /// ## Motion per keyframe
  ///
  /// ```dart
  /// PaddingAct.keyframed(
  ///   frames: Keyframes([
  ///     .key(EdgeInsets.all(12)),
  ///     .key(EdgeInsets.all(24), motion: .easinInOut(200.ms)),
  ///   ], motion: .smooth()),
  /// )
  /// ```
  /// {@endtemplate}
  const PaddingAct.keyframed({
    required super.frames,
    super.delay,
    super.reverse,
  }) : super.keyframed(from: EdgeInsets.zero);

  @override
  Animatable<EdgeInsetsGeometry> createSingleTween(
    EdgeInsetsGeometry from,
    EdgeInsetsGeometry to,
  ) {
    return EdgeInsetsGeometryTween(begin: from, end: to);
  }

  @override
  Widget apply(
    BuildContext context,
    CueAnimation<EdgeInsetsGeometry> animation,
    Widget child,
  ) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Padding(
          padding: animation.value.clamp(
            EdgeInsets.zero,
            EdgeInsetsGeometry.infinity,
          ),
          child: child,
        );
      },
      child: child,
    );
  }
}

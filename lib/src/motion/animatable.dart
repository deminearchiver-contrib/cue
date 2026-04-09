import 'package:cue/src/timeline/track/track.dart';
import 'package:flutter/widgets.dart';

/// Similar to Flutter's [Animatable<T>], but evaluates via a driver ([CueTrack]).
///
/// Uses a driver pattern because some animations need extra context beyond raw
/// progress to interpolate correctly (e.g., phase for keyframes, direction for
/// asymmetric motion).
///
/// Implementations enable different evaluation strategies:
/// - [TweenAnimatable]: Standard progress-based interpolation
/// - [DualAnimatable]: Different evaluators for forward vs. reverse
/// - [ConstantAnimatable]: Constant value regardless of state
/// - [SegmentedAnimatable]: Phase-based evaluator selection for keyframes
abstract class CueAnimatable<T extends Object?> {
  /// Creates an animatable driver.
  const CueAnimatable();

  /// Evaluates the animated value given the animation track state.
  T evaluate(CueTrack track);
}

/// An [CueAnimatable] that wraps a standard Flutter [Animatable].
///
/// Transforms the animation progress ([CueTrack.value]) through the tween,
/// ignoring Cue-specific state (phase, direction). Suitable for simple,
/// progress-only animations.
///
/// Typically used for single-phase motions that don't need asymmetric
/// forward/reverse behavior or multi-stage keyframes.
class TweenAnimatable<T extends Object?> extends CueAnimatable<T> {
  /// The underlying Flutter tween to transform progress values.
  final Animatable<T> tween;

  /// Creates a tween-based animatable driver.
  const TweenAnimatable(this.tween);

  @override
  T evaluate(CueTrack track) {
    return tween.transform(track.value);
  }
}

/// An [CueAnimatable] that selects between forward and reverse animatables.
///
/// Enables asymmetric animations where the forward (opening/activating) motion
/// differs from the reverse (closing/deactivating) motion. Selection is based on
/// [CueTrack.isReverseOrDismissed].
///
/// **Use case**: Toggle animations where opening animates differently than closing,
/// e.g., a button expands smoothly when toggled on but snaps back when toggled off.
class DualAnimatable<T extends Object?> extends CueAnimatable<T> {
  /// The animatable to evaluate when moving forward.
  final CueAnimatable<T> forward;

  /// The animatable to evaluate when moving in reverse.
  final CueAnimatable<T> reverse;

  /// Creates a dual-direction animatable.
  ///
  /// - [forward]: Evaluates when [CueTrack.isReverseOrDismissed] is `false`.
  /// - [reverse]: Evaluates when [CueTrack.isReverseOrDismissed] is `true`.
  DualAnimatable({required this.forward, required this.reverse});

  @override
  T evaluate(CueTrack track) {
    final isReversing = track.isReverseOrDismissed;
    return isReversing ? reverse.evaluate(track) : forward.evaluate(track);
  }
}

/// An [CueAnimatable] that always returns a fixed value.
///
/// Ignores all animation state ([CueTrack] parameters). Useful for acts that
/// should not animate but need to participate in the animation framework
/// (e.g., a static color or opacity).
class ConstantAnimatable<T extends Object?> extends CueAnimatable<T> {
  /// The constant value to always return.
  final T value;

  /// Creates a fixed-value animatable.
  const ConstantAnimatable(this.value);

  @override
  T evaluate(CueTrack track) => value;
}

/// An [CueAnimatable] that selects and evaluates an evaluator based on phase.
///
/// Maintains a list of evaluators—one per phase. Selects the active evaluator
/// using the driver's phase, then evaluates through that evaluator.
///
/// **Common use case**: Keyframe animations, where different motions are needed.
class SegmentedAnimatable<T extends Object?> extends CueAnimatable<T> {
  /// List of evaluators, indexed by phase.
  ///
  /// Each element corresponds to one phase. The index must match the
  /// phase reported by the driver to ensure correct evaluator selection.
  final List<Animatable<T>> segments;

  /// Creates a phase-based evaluator selector.
  SegmentedAnimatable(this.segments);

  @override
  T evaluate(CueTrack track) {
    return segments[track.phase].transform(track.value);
  }
}

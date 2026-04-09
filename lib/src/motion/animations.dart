import 'package:cue/cue.dart';
import 'package:cue/src/timeline/track/track.dart';
import 'package:flutter/widgets.dart';

/// A Flutter [Animation<T>] that drives values via a [CueAnimatable] evaluated
/// against the Cue timeline track.
///
/// Each [CueAnimation] holds a [ReleaseToken] for track reference counting:
/// when all clients release their tokens, the track is removed from the timeline.
///
/// Implementations:
/// - [CueAnimationImpl]: Standard animation with fixed [CueAnimatable].
/// - [DeferredCueAnimation]: Deferred animatable setup, used when values need
///   normalization before tween building (e.g., animating to `infinity` requires
///   normalizing to actual constraints).
abstract class CueAnimation<T extends Object?> extends Animation<T>
    with AnimationWithParentMixin<double> {
  /// The animation track from the Cue timeline.
  @override
  final CueTrack parent;

  /// Reference token for track lifecycle management.
  ///
  /// Call [release] when this animation no longer needs the track. When all
  /// clients release their tokens, the track is removed from the timeline.
  ReleaseToken get token;

  /// Creates a CueAnimation with the given [parent] track.
  CueAnimation({required this.parent});

  /// Maps this animation's value via a selector function.
  ///
  /// Returns a new [CueAnimationImpl] with a transformed animatable.
  CueAnimationImpl<S> map<S>(S Function(T value) selector) {
    return CueAnimationImpl<S>(
      parent: parent,
      token: token,
      animatable: _MappedCueAnimatable<T, S>(animatable, selector),
    );
  }

  /// Whether the animation is in reverse or dismissed state.
  bool get isReverseOrDismissed =>
      parent.status == AnimationStatus.reverse ||
      parent.status == AnimationStatus.dismissed;

  /// The animatable driver that interpolates values.
  CueAnimatable<T> get animatable;

  /// The current animation value.
  ///
  /// Computed by evaluating the animatable with the track state.
  @override
  T get value => animatable.evaluate(parent);

  /// Releases this animation's reference to the track.
  ///
  /// When all clients release, the track is removed from the timeline.
  void release() => token.release();
}

/// A [CueAnimation] with a fixed, pre-built [CueAnimatable].
class CueAnimationImpl<T extends Object?> extends CueAnimation<T> {
  /// The animatable driver.
  @override
  final CueAnimatable<T> animatable;

  /// The track reference token.
  @override
  final ReleaseToken token;

  /// Creates a standard animation.
  CueAnimationImpl({
    required super.parent,
    required this.token,
    required this.animatable,
  });
}

/// Maps a [CueAnimatable] by transforming its evaluated values.
///
/// Used internally by [CueAnimation.map] to chain value transformations.
class _MappedCueAnimatable<T extends Object?, S extends Object?>
    extends CueAnimatable<S> {
  /// The source animatable.
  final CueAnimatable<T> parent;

  /// Transformation function applied to each evaluated value.
  final S Function(T value) selector;

  _MappedCueAnimatable(this.parent, this.selector);

  @override
  S evaluate(CueTrack track) {
    return selector(parent.evaluate(track));
  }
}

/// A [CueAnimation] with deferred animatable setup.
///
/// Used when the animatable cannot be built immediately because values need
/// normalization first. Example: animating a size to `infinity` requires
/// normalizing to the actual maxConstraints before the tween is built.
///
/// Call [setAnimatable] once values are normalized and the animatable is ready.
class DeferredCueAnimation<T extends Object?> extends CueAnimation<T> {
  /// Context used for building tweens.
  ActContext context;

  /// The track reference token.
  @override
  final ReleaseToken token;

  /// Creates a deferred animation.
  ///
  /// - [context]: Act context for tween building.
  /// - [token]: Track reference for lifecycle management.
  DeferredCueAnimation({
    required super.parent,
    required this.context,
    required this.token,
  });

  CueAnimatable<T>? _animatable;

  /// The animatable driver.
  ///
  /// Throws [StateError] if not yet set via [setAnimatable].
  @override
  CueAnimatable<T> get animatable {
    if (_animatable == null) {
      throw StateError('Animatable is not set yet');
    }
    return _animatable!;
  }

  /// Whether the animatable has been set.
  bool get hasAnimatable => _animatable != null;

  /// Sets the normalized animatable.
  ///
  /// Called once value normalization is complete and the tween is ready.
  void setAnimatable(CueAnimatable<T>? animatable) {
    _animatable = animatable;
  }
}

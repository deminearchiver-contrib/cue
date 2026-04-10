import 'dart:math' as math;

import 'package:example/examples/horizinally_expanding_cards.dart';
import 'package:example/flutter.dart';

void main() {
  runApp(const CueApp());
}

class CueApp extends StatefulWidget {
  const CueApp({super.key});

  @override
  State<CueApp> createState() => _CueAppState();
}

class _CueAppState extends State<CueApp> {
  Widget _buildTypefaceTheme(BuildContext context, Widget child) =>
      TypefaceTheme.merge(data: const .from(), child: child);

  Widget _buildReferenceThemes(BuildContext context, Widget child) =>
      CombiningBuilder(
        useOuterContext: true,
        builders: [_buildTypefaceTheme],
        child: child,
      );

  Widget _buildColorThemes(BuildContext context, Widget child) {
    final Brightness brightness = MediaQuery.platformBrightnessOf(context);

    final highContrast = MediaQuery.highContrastOf(context);

    final contrastLevel = highContrast ? 1.0 : 0.0;

    final colorTheme = ColorThemeData.fromSeed(
      sourceColor: .fromArgb(0xFF6C63FF),
      brightness: brightness,
      contrastLevel: contrastLevel,
      variant: .tonalSpot,
      platform: .phone,
      specVersion: .spec2026,
    );

    return ColorTheme(data: colorTheme, child: child);
  }

  Widget _buildSpringTheme(BuildContext context, Widget child) =>
      SpringTheme(data: const .expressive(), child: child);

  Widget _buildTypescaleTheme(BuildContext context, Widget child) =>
      TypescaleTheme.merge(data: const .from(), child: child);

  Widget _buildSystemThemes(BuildContext context, Widget child) =>
      CombiningBuilder(
        useOuterContext: true,
        builders: [_buildColorThemes, _buildSpringTheme, _buildTypescaleTheme],
        child: child,
      );

  Widget _buildComponentThemes(BuildContext context, Widget child) {
    return child;
  }

  Widget _buildLegacyThemes(BuildContext context, Widget child) {
    final colorTheme = ColorTheme.of(context);
    final elevationTheme = ElevationTheme.of(context);
    final shapeTheme = ShapeTheme.of(context);
    final stateTheme = StateTheme.of(context);
    final typescaleTheme = TypescaleTheme.of(context);

    final legacyTheme = LegacyThemeFactory.createTheme(
      colorTheme: colorTheme,
      elevationTheme: elevationTheme,
      shapeTheme: shapeTheme,
      stateTheme: stateTheme,
      typescaleTheme: typescaleTheme,
      scaffoldBackgroundColor: colorTheme.surfaceContainer,
    );

    return Theme(data: legacyTheme, child: child);
  }

  Widget _buildThemes(BuildContext context, Widget child) => CombiningBuilder(
    builders: [
      _buildReferenceThemes,
      _buildSystemThemes,
      _buildComponentThemes,
      _buildLegacyThemes,
    ],
    child: child,
  );

  Widget _buildNavigatorWrapper(BuildContext context, Widget? child) {
    if (child == null) return const SizedBox.shrink();

    if (kDebugMode) {
      child = CueDebugTools(child: child);
    }

    final materialLocalization = Localizations.of<MaterialLocalizations>(
      context,
      MaterialLocalizations,
    );
    final colorTheme = ColorTheme.of(context);
    final typescaleTheme = TypescaleTheme.of(context);

    final category = materialLocalization?.scriptCategory ?? .englishLike;
    final localizedTextStyle = DefaultTextStyles.geometryStyleFor(category);
    final defaultTextStyle = typescaleTheme.bodyLarge
        .toTextStyle(color: colorTheme.onSurface)
        .merge(localizedTextStyle);
    return DefaultTextStyle.merge(style: defaultTextStyle, child: child);
  }

  Widget _buildApp(BuildContext context) {
    return RawMaterialApp(
      debugShowCheckedModeBanner: false,

      // Localization
      title: "Cue",

      // Navigation
      builder: _buildNavigatorWrapper,
      home: const Demo1View(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBuilder = Builder(builder: _buildApp);
    return _buildThemes(context, appBuilder);
  }
}

class Demo1View extends StatefulWidget {
  const Demo1View({super.key});

  @override
  State<Demo1View> createState() => _Demo1ViewState();
}

class _Demo1ViewState extends State<Demo1View> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HorizontallyExpandingCards(),
      // floatingActionButton: ThreeDotsAction(),
      // floatingActionButton: SlackStyleFab(),
      floatingActionButton: FloatingActionButtonMenu(
        menuItems: const [
          .new(
            onTap: null,
            icon: Icon(Symbols.mic_rounded, fill: 1.0),
            label: Text("Audio"),
          ),
          .new(
            onTap: null,
            icon: Icon(Symbols.image_rounded, fill: 1.0),
            label: Text("Image"),
          ),
          .new(
            onTap: null,
            icon: Icon(Symbols.brush_rounded, fill: 1.0),
            label: Text("Drawing"),
          ),
          .new(
            onTap: null,
            icon: Icon(Symbols.check_box_rounded, fill: 1.0),
            label: Text("List"),
          ),
          .new(
            onTap: null,
            icon: Icon(Symbols.format_size_rounded),
            label: Text("Text"),
          ),
        ],
      ),
    );
  }
}

class FloatingActionButtonMenu extends StatefulWidget {
  const FloatingActionButtonMenu({super.key, required this.menuItems})
    : assert(menuItems.length > 0);

  final List<FloatingActionButtonMenuItem> menuItems;

  @override
  State<FloatingActionButtonMenu> createState() =>
      _FloatingActionButtonMenuState();
}

class _FloatingActionButtonMenuState extends State<FloatingActionButtonMenu> {
  @override
  Widget build(BuildContext context) {
    final colorTheme = ColorTheme.of(context);
    final elevationTheme = ElevationTheme.of(context);
    final shapeTheme = ShapeTheme.of(context);
    final springTheme = SpringTheme.of(context);
    final stateTheme = StateTheme.of(context);
    final typescaleTheme = TypescaleTheme.of(context);

    final openButtonContainerShape = CornersBorder.rounded(
      corners: .all(shapeTheme.corner.large),
    );
    final closeButtonContainerShape = CornersBorder.rounded(
      corners: .all(shapeTheme.corner.full),
    );
    final buttonContainerColor = colorTheme.primaryContainer;
    final iconTheme = IconThemeDataPartial.from(
      opticalSize: 24.0,
      size: 28.0,
      color: colorTheme.onPrimaryContainer,
    );

    return CueModalTransition(
      barrierDismissible: true,
      alignment: .bottomEnd,
      hideTriggerOnTransition: true,
      motion: SpringMotion.custom(
        desc: springTheme.fastSpatial.toSpringDescription(),
      ),
      triggerBuilder: (context, showDialog) => SizedBox.square(
        dimension: 80.0,
        child: Material(
          clipBehavior: .antiAlias,
          shape: openButtonContainerShape,
          color: buttonContainerColor,
          child: InkWell(
            overlayColor: WidgetStateLayerColor(
              color: .all(colorTheme.onPrimaryContainer),
              opacity: stateTheme.asWidgetStateLayerOpacity,
            ),
            onTap: showDialog,
            child: IconTheme.merge(
              data: iconTheme,
              child: const Icon(Symbols.add_rounded),
            ),
          ),
        ),
      ),
      builder: (context, triggerRect) => _FloatingActionButtonMenuModal(
        triggerRect: triggerRect,
        menuItems: widget.menuItems,
      ),
    );
  }
}

class FloatingActionButtonMenuItem {
  const FloatingActionButtonMenuItem({
    required this.onTap,
    required this.icon,
    required this.label,
  });

  final GestureTapCallback? onTap;
  final Widget icon;
  final Widget label;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      runtimeType == other.runtimeType &&
          other is FloatingActionButtonMenuItem &&
          onTap == other.onTap &&
          icon == other.icon &&
          label == other.label;

  @override
  int get hashCode => Object.hash(runtimeType, onTap, icon, label);
}

class _FloatingActionButtonMenuModal extends StatelessWidget {
  const _FloatingActionButtonMenuModal({
    super.key,
    required this.triggerRect,
    required this.menuItems,
  });

  final Rect triggerRect;

  final List<FloatingActionButtonMenuItem> menuItems;

  @override
  Widget build(BuildContext context) {
    final colorTheme = ColorTheme.of(context);
    final elevationTheme = ElevationTheme.of(context);
    final shapeTheme = ShapeTheme.of(context);
    final springTheme = SpringTheme.of(context);
    final stateTheme = StateTheme.of(context);
    final typescaleTheme = TypescaleTheme.of(context);

    final openButtonContainerShape = CornersBorder.rounded(
      corners: .all(shapeTheme.corner.large),
    );
    final closeButtonContainerShape = CornersBorder.rounded(
      corners: .all(shapeTheme.corner.full),
    );
    final buttonContainerColor = colorTheme.primaryContainer;
    final iconTheme = IconThemeDataPartial.from(
      opticalSize: 24.0,
      size: 28.0,
      color: colorTheme.onPrimaryContainer,
    );
    final menuIconTheme = IconThemeDataPartial.from(
      opticalSize: 24.0,
      size: 24.0,
      color: colorTheme.onPrimary,
    );

    final Widget closeButton = SizedBox.fromSize(
      size: triggerRect.size,
      child: Align.topEnd(
        child: TweenActor<double>(
          from: 0.0,
          to: 1.0,
          builder: (context, animation) => AnimatedBuilder(
            animation: animation,
            builder: (context, child) => SizedBox.fromSize(
              size: Size.lerp(
                triggerRect.size,
                const Size.square(56.0),
                animation.value,
              ),
              child: Material(
                clipBehavior: .antiAlias,
                shape: ShapeBorder.lerp(
                  openButtonContainerShape,
                  closeButtonContainerShape,
                  animation.value,
                ),
                color: Color.lerp(
                  buttonContainerColor,
                  colorTheme.primary,
                  animation.value,
                ),
                child: InkWell(
                  overlayColor: WidgetStateLayerColor(
                    color: .all(
                      Color.lerp(
                        colorTheme.onPrimaryContainer,
                        colorTheme.onPrimary,
                        animation.value,
                      ),
                    ),
                    opacity: stateTheme.asWidgetStateLayerOpacity,
                  ),
                  onTap: () => Navigator.pop(context),
                  child: IconTheme.merge(
                    data: IconThemeDataPartial.lerp(
                      iconTheme,
                      menuIconTheme,
                      animation.value,
                    )!,
                    child: child!,
                  ),
                ),
              ),
            ),
            child: const Stack(
              fit: .passthrough,
              children: [
                Actor(
                  acts: [.fadeOut(), .rotate(to: 45.0)],
                  child: Icon(Symbols.add_rounded),
                ),
                Actor(
                  acts: [.fadeIn(), .rotate(from: -45.0)],
                  child: Icon(Symbols.close_rounded),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    final delayMicroseconds =
        (springTheme.slowEffects.toSpringDescription().duration.inMicroseconds /
                (menuItems.length + 2))
            .round();

    final Widget items = Flex.vertical(
      mainAxisSize: .min,
      mainAxisAlignment: .center,
      crossAxisAlignment: .end,
      spacing: 4.0,
      children: [
        for (final (index, item) in menuItems.indexed)
          Actor(
            motion: SpringMotion.custom(
              desc: springTheme.fastEffects.toSpringDescription(),
            ),
            acts: const [.fadeIn()],
            delay: .new(
              microseconds: delayMicroseconds * (menuItems.length - 1 - index),
            ),
            reverseDelay: .new(microseconds: delayMicroseconds * index),
            child: SizedBox(
              height: 56.0,
              child: Material(
                clipBehavior: .antiAlias,
                shape: CornersBorder.rounded(
                  corners: .all(shapeTheme.corner.full),
                ),
                color: colorTheme.primaryContainer,
                child: InkWell(
                  overlayColor: WidgetStateLayerColor(
                    color: .all(colorTheme.onPrimaryContainer),
                    opacity: stateTheme.asWidgetStateLayerOpacity,
                  ),
                  onTap: () => Navigator.pop(context),
                  child: TweenActor<double>(
                    from: 0.0,
                    to: 1.0,
                    motion: SpringMotion.custom(
                      desc: springTheme.fastSpatial.toSpringDescription(),
                    ),
                    delay: .new(
                      microseconds:
                          delayMicroseconds * (menuItems.length - 1 - index),
                    ),
                    reverse: .mirror(
                      delay: .new(microseconds: delayMicroseconds * index),
                    ),
                    builder: (context, animation) => AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) => Align.centerEnd(
                        widthFactor: math.max(0.0, animation.value),
                        child: child,
                      ),
                      child: Padding(
                        padding: .symmetric(horizontal: 24.0, vertical: 16.0),
                        child: DefaultTextStyle.merge(
                          style: typescaleTheme.titleMedium.toTextStyle(
                            color: colorTheme.onPrimaryContainer,
                          ),
                          child: IconTheme.merge(
                            data: .from(
                              opticalSize: 24.0,
                              size: 24.0,
                              color: colorTheme.onPrimaryContainer,
                            ),
                            child: Flex.horizontal(
                              mainAxisSize: .min,
                              spacing: 8.0,
                              children: [item.icon, item.label],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );

    return Flex.vertical(
      mainAxisSize: .min,
      mainAxisAlignment: .end,
      crossAxisAlignment: .end,
      spacing: 8.0,
      children: [items, closeButton],
    );
  }
}

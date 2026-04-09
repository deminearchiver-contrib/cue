import 'package:flutter/material.dart';
import 'package:cue/cue.dart';

class ThreeDotsAction extends StatelessWidget {
  const ThreeDotsAction({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return CueModalTransition(
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.122),
      motion: Spring.custom(
        desc: .withDampingRatio(mass: 1.0, stiffness: 800.0, ratio: 0.6),
      ),
      alignment: Alignment.bottomCenter,
      triggerBuilder: (context, showModal) => FloatingActionButton(
        shape: const CircleBorder(),
        heroTag: null,
        elevation: 1,
        onPressed: showModal,
        child: Column(
          spacing: 2,
          mainAxisSize: MainAxisSize.min,
          children: [
            // we use specific sized dots for easier transition
            for (var i = 0; i < 3; i++)
              CircleAvatar(radius: 2.5, backgroundColor: colors.onSurface),
          ],
        ),
      ),
      builder: (context, rect) {
        return SizedBox(
          width: rect.width,
          child: Stack(
            alignment: .bottomCenter,
            fit: StackFit.loose,
            children: [
              FloatingActionButton(
                elevation: 0,
                shape: const CircleBorder(),
                onPressed: () => Navigator.of(context).pop(),
                child: const Actor(
                  acts: [.fadeIn(from: 0), .focus(from: 8), .slideY(from: 1)],
                  child: Icon(Icons.keyboard_arrow_down),
                ),
              ),
              Actor(
                acts: [
                  .translateY(
                    from: -rect.height / 3,
                    to: -rect.height - 4, // 4 is little extra padding
                  ),
                ],
                child: Column(
                  mainAxisSize: .min,
                  children: [
                    for (final icon in [
                      Icons.near_me_outlined,
                      Icons.draw_outlined,
                      Icons.translate,
                    ])
                      Actor(
                        acts: const [
                          .padding(from: .all(1), to: .only(bottom: 10.0)),
                          .sizedBox(
                            width: .tween(5, 44),
                            height: .tween(5, 44),
                          ),
                        ],
                        child: FloatingActionButton(
                          mini: true,
                          backgroundColor: colors.onSurface,
                          elevation: 1,
                          shape: const CircleBorder(),
                          heroTag: null,
                          onPressed: () {},
                          child: Actor(
                            acts: const [.focus(from: 8), .zoomIn(), .fadeIn()],
                            child: Icon(
                              icon,
                              color: colors.onPrimary,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

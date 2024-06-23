import 'package:flutter/material.dart';
import 'package:mml_admin/gen/assets.gen.dart';
import 'package:rive/rive.dart';

/// Animation for the file uploading.
class UploadAnimation extends StatelessWidget {
  /// Initializes the animation.
  const UploadAnimation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RiveAnimation.asset(
      Assets.animations.mml,
      onInit: (Artboard artboard) {
        artboard.forEachComponent(
          (child) {
            if (child.name == 'server') {
              Shape shield = child as Shape;
              for (var element in shield.strokes) {
                element.paint.color = Theme.of(context).colorScheme.primary;
              }
            }

            if (child.name == 'loading') {
              Shape shield = child as Shape;
              for (var element in shield.fills) {
                element.paint.colorFilter = ColorFilter.mode(
                  Theme.of(context).colorScheme.secondary,
                  BlendMode.srcIn,
                );
              }
            }
          },
        );
      },
      artboard: 'Uploading',
      animations: const ['animation_uploading'],
    );
  }
}

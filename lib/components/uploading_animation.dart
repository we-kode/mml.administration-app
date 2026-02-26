import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mml_admin/gen/assets.gen.dart';

/// Animation for the file uploading.
class UploadAnimation extends StatelessWidget {
  /// Initializes the animation.
  const UploadAnimation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      Assets.animations.loading,
      repeat: true,
      animate: true,
      fit: BoxFit.contain,
    );
  }
}

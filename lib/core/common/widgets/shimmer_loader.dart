import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/theme.dart';

class ShimmerLoader extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  const ShimmerLoader({super.key, this.width, this.height, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
        gradient: AppTheme.shimmerGradient(context),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius,
        ),
    ),

    );
  }
}

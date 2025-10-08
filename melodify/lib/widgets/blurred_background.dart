import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BlurredBackground extends StatelessWidget {
  final String? imageUrl;
  final Widget child;
  final double blurStrength;
  final Color? fallbackColor;

  const BlurredBackground({
    super.key,
    this.imageUrl,
    required this.child,
    this.blurStrength = 20.0,
    this.fallbackColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: fallbackColor != null
            ? LinearGradient(
                colors: [fallbackColor!, fallbackColor!.withValues(alpha: 0.8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            : null,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (imageUrl != null)
            CachedNetworkImage(
              imageUrl: imageUrl!,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: fallbackColor ?? Colors.grey[900],
              ),
              errorWidget: (context, url, error) => Container(
                color: fallbackColor ?? Colors.grey[900],
              ),
            ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurStrength, sigmaY: blurStrength),
            child: Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
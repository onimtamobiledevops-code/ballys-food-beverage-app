import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

/// Animated brand header for the login screen.
///
/// - "F & B EXPRESS" renders in a bold, modern display font (Outfit),
///   filled with a gold gradient and a slow metallic shimmer sweep
///   that echoes the brushed-gold finish of the app logo.
/// - The slogan renders underneath in a lighter, modern sans (Poppins).
/// - Both fade + slide into place on first build, staggered slightly
///   so the title settles first and the slogan follows.
class AnimatedBrandHeader extends StatefulWidget {
  const AnimatedBrandHeader({
    super.key,
    this.title = 'ServeDish',
    this.slogan = 'Serve Smart. Serve Fast.',
  });

  final String title;
  final String slogan;

  @override
  State<AnimatedBrandHeader> createState() => _AnimatedBrandHeaderState();
}

class _AnimatedBrandHeaderState extends State<AnimatedBrandHeader>
    with TickerProviderStateMixin {
  late final AnimationController _entrance;
  late final AnimationController _shimmer;

  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _sloganFade;
  late final Animation<Offset> _sloganSlide;

  @override
  void initState() {
    super.initState();

    // One-shot entrance: title settles first, slogan follows.
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _titleFade = CurvedAnimation(
      parent: _entrance,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entrance,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
    ));

    _sloganFade = CurvedAnimation(
      parent: _entrance,
      curve: const Interval(0.35, 1.0, curve: Curves.easeOut),
    );
    _sloganSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entrance,
      curve: const Interval(0.35, 1.0, curve: Curves.easeOutCubic),
    ));

    // Continuous, slow shine sweeping across the gold title text.
    _shimmer = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat();
  }

  @override
  void dispose() {
    _entrance.dispose();
    _shimmer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FadeTransition(
          opacity: _titleFade,
          child: SlideTransition(
            position: _titleSlide,
            child: _ShimmerGoldText(text: widget.title, shimmer: _shimmer),
          ),
        ),
        const SizedBox(height: 8),
        FadeTransition(
          opacity: _sloganFade,
          child: SlideTransition(
            position: _sloganSlide,
            child: Text(
              widget.slogan,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w300,
                fontSize: 14,
                letterSpacing: 1.4,
                color: AppColors.greyText,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ShimmerGoldText extends StatelessWidget {
  const _ShimmerGoldText({required this.text, required this.shimmer});

  final String text;
  final Animation<double> shimmer;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: shimmer,
      builder: (context, _) {
        // shimmer.value loops 0 -> 1. Map it to a sweep that passes
        // fully across the text, pausing briefly off-screen between
        // loops so the shine doesn't feel mechanical.
        final slide = shimmer.value * 4 - 2; // -2 -> 2
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-1.0 + slide, 0),
              end: Alignment(1.0 + slide, 0),
              colors: const [
                Color(0xFFB8860B), // deep gold base
                Color(0xFFFFE9A8), // bright shine
                Color(0xFFB8860B), // deep gold base
              ],
              stops: const [0.35, 0.5, 0.65],
            ).createShader(bounds);
          },
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w800,
              fontSize: 28,
              letterSpacing: 2.4,
              color: Colors.white, // overwritten by the ShaderMask
            ),
          ),
        );
      },
    );
  }
}
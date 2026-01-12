import 'package:flutter/material.dart';

/// Widget réutilisable pour afficher le logo de l'application
class AppLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final double? size;
  final bool showText;
  final String? text;
  final TextStyle? textStyle;
  final MainAxisAlignment alignment;
  final bool isClickable;
  final VoidCallback? onTap;

  const AppLogo({
    super.key,
    this.width,
    this.height,
    this.size,
    this.showText = false,
    this.text,
    this.textStyle,
    this.alignment = MainAxisAlignment.center,
    this.isClickable = false,
    this.onTap,
  });

  /// Logo petit pour les AppBars
  const AppLogo.small({
    super.key,
    this.showText = false,
    this.text,
    this.textStyle,
    this.alignment = MainAxisAlignment.center,
    this.isClickable = false,
    this.onTap,
  }) : width = 32, height = 32, size = 32;

  /// Logo moyen pour les headers
  const AppLogo.medium({
    super.key,
    this.showText = true,
    this.text,
    this.textStyle,
    this.alignment = MainAxisAlignment.center,
    this.isClickable = false,
    this.onTap,
  }) : width = 64, height = 64, size = 64;

  /// Logo large pour les écrans de connexion/splash
  const AppLogo.large({
    super.key,
    this.showText = true,
    this.text,
    this.textStyle,
    this.alignment = MainAxisAlignment.center,
    this.isClickable = false,
    this.onTap,
  }) : width = 120, height = 120, size = 120;

  /// Logo extra large pour les écrans d'accueil
  const AppLogo.extraLarge({
    super.key,
    this.showText = true,
    this.text,
    this.textStyle,
    this.alignment = MainAxisAlignment.center,
    this.isClickable = false,
    this.onTap,
  }) : width = 200, height = 200, size = 200;

  @override
  Widget build(BuildContext context) {
    final effectiveWidth = size ?? width ?? 64;
    final effectiveHeight = size ?? height ?? 64;
    final effectiveText = text ?? 'CampusWork';

    Widget logoWidget = Container(
      width: effectiveWidth,
      height: effectiveHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          'assets/image/logo_campuswork.jpg',
          width: effectiveWidth,
          height: effectiveHeight,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback si l'image n'est pas trouvée
            return Container(
              width: effectiveWidth,
              height: effectiveHeight,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.school,
                color: Colors.white,
                size: 32,
              ),
            );
          },
        ),
      ),
    );

    Widget content;
    if (showText) {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: alignment,
        children: [
          logoWidget,
          const SizedBox(height: 12),
          Text(
            effectiveText,
            style: textStyle ?? Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else {
      content = logoWidget;
    }

    if (isClickable && onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: content,
      );
    }

    return content;
  }
}

/// Widget pour afficher le logo avec animation
class AnimatedAppLogo extends StatefulWidget {
  final double? width;
  final double? height;
  final double? size;
  final bool showText;
  final String? text;
  final TextStyle? textStyle;
  final Duration animationDuration;
  final bool autoStart;

  const AnimatedAppLogo({
    super.key,
    this.width,
    this.height,
    this.size,
    this.showText = true,
    this.text,
    this.textStyle,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.autoStart = true,
  });

  @override
  State<AnimatedAppLogo> createState() => _AnimatedAppLogoState();
}

class _AnimatedAppLogoState extends State<AnimatedAppLogo>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    if (widget.autoStart) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void startAnimation() {
    _controller.forward();
  }

  void resetAnimation() {
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: AppLogo(
              width: widget.width,
              height: widget.height,
              size: widget.size,
              showText: widget.showText,
              text: widget.text,
              textStyle: widget.textStyle,
            ),
          ),
        );
      },
    );
  }
}

/// Widget pour le logo en mode héro (pour les transitions)
class HeroAppLogo extends StatelessWidget {
  final String heroTag;
  final double? width;
  final double? height;
  final double? size;
  final bool showText;
  final String? text;
  final TextStyle? textStyle;
  final VoidCallback? onTap;

  const HeroAppLogo({
    super.key,
    required this.heroTag,
    this.width,
    this.height,
    this.size,
    this.showText = false,
    this.text,
    this.textStyle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: AppLogo(
        width: width,
        height: height,
        size: size,
        showText: showText,
        text: text,
        textStyle: textStyle,
        isClickable: onTap != null,
        onTap: onTap,
      ),
    );
  }
}
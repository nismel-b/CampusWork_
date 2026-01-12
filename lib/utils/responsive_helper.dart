import 'package:flutter/material.dart';

/// Helper class pour gérer la responsivité de l'application
class ResponsiveHelper {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  /// Détermine si l'écran est mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  /// Détermine si l'écran est tablette
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < desktopBreakpoint;
  }

  /// Détermine si l'écran est desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }

  /// Retourne le nombre de colonnes pour une grille responsive
  static int getGridColumns(BuildContext context, {int mobile = 2, int tablet = 3, int desktop = 4}) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  /// Retourne le ratio d'aspect pour une grille responsive
  static double getGridAspectRatio(BuildContext context, {double mobile = 1.2, double tablet = 1.3, double desktop = 1.4}) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  /// Retourne le padding horizontal responsive
  static double getHorizontalPadding(BuildContext context) {
    if (isMobile(context)) return 16.0;
    if (isTablet(context)) return 24.0;
    return 32.0;
  }

  /// Retourne la taille de police responsive
  static double getResponsiveFontSize(BuildContext context, double baseFontSize) {
    if (isMobile(context)) return baseFontSize;
    if (isTablet(context)) return baseFontSize * 1.1;
    return baseFontSize * 1.2;
  }
}

/// Widget wrapper pour rendre le contenu responsive
class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final bool enableScrolling;

  const ResponsiveWrapper({
    super.key,
    required this.child,
    this.padding,
    this.enableScrolling = true,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = ResponsiveHelper.getHorizontalPadding(context);
    final effectivePadding = padding ?? EdgeInsets.symmetric(horizontal: horizontalPadding);

    if (enableScrolling) {
      return SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: effectivePadding,
                    child: child,
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    return SafeArea(
      child: Padding(
        padding: effectivePadding,
        child: child,
      ),
    );
  }
}

/// Widget pour créer des grilles responsives
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int? mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;
  final double? mobileAspectRatio;
  final double? tabletAspectRatio;
  final double? desktopAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final EdgeInsets? padding;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobileColumns,
    this.tabletColumns,
    this.desktopColumns,
    this.mobileAspectRatio,
    this.tabletAspectRatio,
    this.desktopAspectRatio,
    this.crossAxisSpacing = 12,
    this.mainAxisSpacing = 12,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final columns = ResponsiveHelper.getGridColumns(
      context,
      mobile: mobileColumns ?? 2,
      tablet: tabletColumns ?? 3,
      desktop: desktopColumns ?? 4,
    );

    final aspectRatio = ResponsiveHelper.getGridAspectRatio(
      context,
      mobile: mobileAspectRatio ?? 1.2,
      tablet: tabletAspectRatio ?? 1.3,
      desktop: desktopAspectRatio ?? 1.4,
    );

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: columns,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: aspectRatio,
        children: children,
      ),
    );
  }
}

/// Widget pour créer des layouts adaptatifs
class AdaptiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const AdaptiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveHelper.isDesktop(context) && desktop != null) {
      return desktop!;
    }
    if (ResponsiveHelper.isTablet(context) && tablet != null) {
      return tablet!;
    }
    return mobile;
  }
}

/// Extension pour ajouter des méthodes responsive aux BuildContext
extension ResponsiveContext on BuildContext {
  bool get isMobile => ResponsiveHelper.isMobile(this);
  bool get isTablet => ResponsiveHelper.isTablet(this);
  bool get isDesktop => ResponsiveHelper.isDesktop(this);
  
  double get responsiveHorizontalPadding => ResponsiveHelper.getHorizontalPadding(this);
  
  int gridColumns({int mobile = 2, int tablet = 3, int desktop = 4}) {
    return ResponsiveHelper.getGridColumns(this, mobile: mobile, tablet: tablet, desktop: desktop);
  }
  
  double gridAspectRatio({double mobile = 1.2, double tablet = 1.3, double desktop = 1.4}) {
    return ResponsiveHelper.getGridAspectRatio(this, mobile: mobile, tablet: tablet, desktop: desktop);
  }
  
  double responsiveFontSize(double baseFontSize) {
    return ResponsiveHelper.getResponsiveFontSize(this, baseFontSize);
  }
}
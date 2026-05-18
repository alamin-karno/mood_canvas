/// Named spacing constants aligned with an 8-pt grid.
///
/// Usage:
/// ```dart
/// SizedBox(height: AppSpacing.md)
/// Padding(padding: EdgeInsets.all(AppSpacing.lg))
/// ```
abstract final class AppSpacing {
  AppSpacing._();

  /// 2 pt — hairline gap, icon-to-label spacing.
  static const double xxs = 2;

  /// 4 pt — tightest spacing, between tightly coupled elements.
  static const double xs = 4;

  /// 8 pt — small spacing, inside compact components.
  static const double sm = 8;

  /// 12 pt — medium-small, inner card padding on dense layouts.
  static const double ms = 12;

  /// 16 pt — base unit, standard component padding and list item gaps.
  static const double md = 16;

  /// 20 pt — medium-large, comfortable section spacing.
  static const double ml = 20;

  /// 24 pt — large, between content sections on a page.
  static const double lg = 24;

  /// 32 pt — extra large, major section breaks or hero padding.
  static const double xl = 32;

  /// 48 pt — 2× large, top-of-page safe area offsets.
  static const double xxl = 48;

  /// 64 pt — maximum, full-bleed header heights.
  static const double xxxl = 64;

  /// Standard horizontal page margin.
  static const double pagePadding = md;

  /// Gap between list/grid items.
  static const double itemGap = sm;

  /// Inner padding for cards.
  static const double cardPadding = md;

  /// Vertical gap between form fields.
  static const double formFieldGap = ms;
}

/// Bundled **Satoshi** (see `pubspec.yaml` → `fonts` → `assets/fonts/`).
///
/// `family` must match the `family:` entry in `pubspec.yaml`. Fallbacks are
/// only used if a glyph is missing from the bundled font.
class AppFonts {
  AppFonts._();

  static const String family = 'Satoshi';

  static const List<String> fallback = <String>['Roboto', 'sans-serif'];
}

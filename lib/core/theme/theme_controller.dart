import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

/// Holds theme mode + accent colour. Persists to SharedPreferences and
/// notifies listeners so the whole app rebuilds immediately.
class ThemeController extends ChangeNotifier {
  ThemeController(this._prefs) {
    final modeIndex = _prefs.getInt(_kMode);
    _mode = (modeIndex != null && modeIndex >= 0 && modeIndex < ThemeMode.values.length)
        ? ThemeMode.values[modeIndex]
        : ThemeMode.system;
    final accentValue = _prefs.getInt(_kAccent);
    _accent = accentValue != null ? Color(accentValue) : AppColors.primary;
    _presetId = _prefs.getString(_kPreset) ?? 'violet';
  }

  static const _kMode = 'theme_mode';
  static const _kAccent = 'theme_accent';
  static const _kPreset = 'theme_preset';

  final SharedPreferences _prefs;
  late ThemeMode _mode;
  late Color _accent;
  late String _presetId;

  ThemeMode get mode => _mode;
  Color get accent => _accent;
  String get presetId => _presetId;

  Future<void> setMode(ThemeMode mode) async {
    _mode = mode;
    notifyListeners();
    await _prefs.setInt(_kMode, mode.index);
  }

  Future<void> setPreset(ThemePreset preset) async {
    _accent = preset.color;
    _presetId = preset.id;
    notifyListeners();
    await _prefs.setInt(_kAccent, preset.color.toARGB32());
    await _prefs.setString(_kPreset, preset.id);
  }

  Future<void> setCustomAccent(Color color) async {
    _accent = color;
    _presetId = 'custom';
    notifyListeners();
    await _prefs.setInt(_kAccent, color.toARGB32());
    await _prefs.setString(_kPreset, 'custom');
  }
}

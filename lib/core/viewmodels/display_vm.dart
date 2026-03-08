// lib/core/viewmodels/display_vm.dart

import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/services/analytics_service.dart';
import 'package:iron_split/core/services/logger_service.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisplayViewModel extends ChangeNotifier {
  static const String _key = 'display_mode';
  final AnalyticsService _analyticsService;
  final LoggerService _loggerService;

  // 預設跟隨系統
  DisplayMode _displayMode = DisplayMode.system;

  DisplayMode get displayMode => _displayMode;

  DisplayViewModel(
      {AnalyticsService? analyticsService, LoggerService? loggerService})
      : _analyticsService = analyticsService ?? AnalyticsService.instance,
        _loggerService = loggerService ?? LoggerService.instance {
    _loadFromPrefs();
  }

  // S70 頁面會呼叫這個方法
  Future<void> setDisplayMode(DisplayMode mode) async {
    if (_displayMode == mode) return;
    _displayMode = mode;
    notifyListeners(); // 這會通知 main.dart 重畫

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, mode.toString());
      // 更新 User Properties
      await _analyticsService.syncUserProperties().catchError((_) {});
    } catch (e, stackTrace) {
      _loggerService.recordError(
        e,
        stackTrace,
        reason:
            'DisplayViewModel - setDisplayMode: Failed to get display mode form shared preferences',
      );
      throw ErrorMapper.parseErrorCode(e);
    }
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedString = prefs.getString(_key);

    if (savedString != null) {
      _displayMode = DisplayConstants.stringConvertToDisplayMode(savedString);
      notifyListeners();
    }
  }
}

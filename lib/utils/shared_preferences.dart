import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

/// 用来做shared_preferences的存储,数据存储是异步的,读取是同步的
class SpUtil {
  static late SpUtil _instance;

  static Future<SpUtil> get instance async {
    return await getInstance();
  }

  static late SharedPreferences _spf;

  SpUtil._();

  Future _init() async {
    _spf = await SharedPreferences.getInstance();
  }

  static Future<SpUtil> getInstance() async {
    if (_instance == null) {
      _instance = new SpUtil._();
      await _instance._init();
    }
    return _instance;
  }

  static bool _beforCheck() {
    if (_spf == null) {
      return true;
    }
    return false;
  }

  // 判断是否存在数据
  bool? hasKey(String key) {
    Set<dynamic>? keys = getKeys()?.cast();
    return keys?.contains(key);
  }

  Set<String>? getKeys() {
    if (_beforCheck()) return null;
    return _spf.getKeys();
  }

  get(String key) {
    if (_beforCheck()) return null;
    return _spf.get(key);
  }

  /// 如果你直接调用getString，主线程会等待加载sp的线程加载完毕
  getString(String key) {
    if (_beforCheck()) return null;
    return _spf.getString(key);
  }

  Future<bool>? putString(String key, String value) {
    if (_beforCheck()) return null;
    return _spf.setString(key, value);
  }

  bool? getBool(String key) {
    if (_beforCheck()) return null;
    return _spf.getBool(key);
  }

  Future<bool>? putBool(String key, bool value) {
    if (_beforCheck()) return null;
    return _spf.setBool(key, value);
  }

  int? getInt(String key) {
    if (_beforCheck()) return null;
    return _spf.getInt(key);
  }

  Future<bool>? putInt(String key, int value) {
    if (_beforCheck()) return null;
    return _spf.setInt(key, value);
  }

  double? getDouble(String key) {
    if (_beforCheck()) return null;
    return _spf.getDouble(key);
  }

  Future<bool>? putDouble(String key, double value) {
    if (_beforCheck()) return null;
    return _spf.setDouble(key, value);
  }

  List<String>? getStringList(String key) {
    return _spf.getStringList(key);
  }

  Future<bool>? putStringList(String key, List<String> value) {
    if (_beforCheck()) return null;
    return _spf.setStringList(key, value);
  }

  dynamic getDynamic(String key) {
    if (_beforCheck()) return null;
    return _spf.get(key);
  }

  Future<bool>? remove(String key) {
    if (_beforCheck()) return null;
    return _spf.remove(key);
  }

  Future<bool>? clear() {
    if (_beforCheck()) return null;
    return _spf.clear();
  }
}

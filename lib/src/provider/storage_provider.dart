import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kiscon_crawler_client/models/storage_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageProvider extends ChangeNotifier {
  /*------------ KEYS ------------*/
  static const String KEY = 'KEY_';
  static const String KEY_MENU_CATEGORY = KEY + 'MENU_CATEGORY';

  Map<String, dynamic> _datas = {};

  /*------------ STATUS ------------*/

  /// load preference status
  bool _isLoadedIns = false;

  /// load local path Status
  bool _isLoadedPath = false;

  /// load categorys
  bool _isLoadedCategory = false;

  /*------------ VARIABLE ------------*/

  /// sharedPreference instance
  SharedPreferences? _shared;

  /// Local Path
  static String _localPath = '';

  StorageProvider() {
    SharedPreferences.getInstance().then((instance) {
      _shared = instance;
      _isLoadedIns = true;
      notifyListeners();
    });

    getApplicationDocumentsDirectory().then((value) {
      _localPath = value.path;
      _isLoadedPath = _localPath.isNotEmpty;
      notifyListeners();
    });
  }

  SharedPreferences get getShared => this._shared!;

  bool get isInit => this._isLoadedIns && this._isLoadedPath;
  bool get isHasCategory => this._isLoadedCategory;

  void init() {
    if (isInit) {
      [
        KEY_MENU_CATEGORY,
      ].forEach((key) {
        getData(key);
        _chkData(key);
      });
    }
  }

  void _chkData(String key) {
    switch (key) {
      case KEY_MENU_CATEGORY:
        print("Set $key Status");
        this._isLoadedCategory = this._datas[key] != null;
        break;
      default:
        print("Please add $key Status");
        break;
    }
  }

  dynamic getData(String key) {
    String data = getShared.getString(KEY_MENU_CATEGORY) ?? '';
    var decoded = jsonDecode(data);
    if (decoded is List) {
      this._datas.update(
            KEY_MENU_CATEGORY,
            (value) => decoded.map((e) => StorageModel.fromJson(e)).toList(),
            ifAbsent: () => decoded.map((e) => StorageModel.fromJson(e)).toList(),
          );
    } else {
      this._datas.update(
            KEY_MENU_CATEGORY,
            (value) => StorageModel.fromJson(decoded),
            ifAbsent: () => StorageModel.fromJson(decoded),
          );
    }
    return decoded;
  }

  void setData(String key, dynamic data) {
    if (data is List) {
      this._shared!.setStringList(key, data.map((e) => e.toString()).toList());
    } else {
      this._shared!.setString(key, data.toString());
    }
  }
}

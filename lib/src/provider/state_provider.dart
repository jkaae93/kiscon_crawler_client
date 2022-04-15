import 'package:flutter/material.dart';
import 'package:kiscon_crawler_client/src/provider/storage_provider.dart';
import 'package:path_provider/path_provider.dart';

enum RunStatus {
  init,
  load,
  complete,
}

class StateProvider extends ChangeNotifier {
  RunStatus _runStatus = RunStatus.init;
  static String directory = "";

  void init() {
    if (directory.isEmpty) {
      _loadPath().then((path) => directory = path);
    }
    notifyListeners();
  }

  Future<String> _loadPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  // Future<void> _getCategory() async {
  //   final path = await _loadPath();
  //   return File()
  // }
}

import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';

class Importer extends ChangeNotifier {
  Map<DateTime, List<String>> _log = {};
  var _shell = Shell();
  late Function _setState;

  Importer(Function update) {
    this._setState = update;
  }

  @override
  void notifyListeners() {
    this._setState();
    super.notifyListeners();
  }

  void init() async {
    await _shell.run('''
      pip3 install virtualenv
      pip3 install -r script/comments/requirements.py
      virtualenv .venv

      pip3 install -r script/tag/requirements.txt
      cp script/tag/inscrawler/secret.py.dist script/tag/inscrawler/secret.py
    ''');
  }

  Future<void> runShell(List<String> categories) async {
    String category = categories.join(',');
    DateTime now = DateTime.now();
    _log.addAll({now: []});
    await _shell.run(
      '''
      python3 script/scrapper.py --args $category
    ''',
      onProcess: (process) {
        process.outLines.asBroadcastStream(
          onListen: (subscription) {
            _log[now]!.add(subscription.toString());
            print("${subscription.toString()}");
            notifyListeners();
          },
          onCancel: (subscription) {
            _log[now]!.add(subscription.toString());
            print("${subscription.toString()}");
            notifyListeners();
          },
        );
      },
    ).then(
      (value) => {},
    );
  }

  void downloadFile() async {
    // final buffer = file.buffer;
    // Directory? dir = await getDownloadsDirectory();
    // File(dir!.path).writeAsBytes(buffer.asUint8List(file.offsetInBytes, file.lengthInBytes));
  }
}

import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';

class Importer {
  var _shell = Shell();

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
    await _shell.run('''
      python3 script/scrapper.py --args $category
    ''', onProcess: (process) {}).then((value) => AlertDialog(content: Text("Finished")));
  }

  void downloadFile() async {
    // final buffer = file.buffer;
    // Directory? dir = await getDownloadsDirectory();
    // File(dir!.path).writeAsBytes(buffer.asUint8List(file.offsetInBytes, file.lengthInBytes));
  }
}

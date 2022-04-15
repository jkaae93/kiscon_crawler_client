import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:process_run/shell.dart';
import 'package:http/http.dart';

class Importer {
  var _shell = Shell();

  Future getData() async {
    var data = await get(Uri.parse('http://127.0.0.1:5000'));
    print(data.body);
  }

  void runShell() async {
    // TODO
    await _shell.run('''
      #Checking python ver
      python3 --version

      #run server
      #python3 script/app.py

      pip3 install virtualenv
      pip3 install -r script/comments/requirements.txt
      virtualenv .venv

      pip3 install -r script/tag/requirements.txt
      cp script/tag/inscrawler/secret.py.dist script/tag/inscrawler/secret.py
    ''');
  }

  void startCommnetCrawler(String url) async {
    await _shell.run('''
      echo "Start commnets crawler"
      source .venv/bin/activate
      python3 script/scraper.py
      #deactivate
    ''');
  }

  void startTagCrawler(String tag) async {
    Directory? dir = await getDownloadsDirectory();
    await _shell.run('''
      python3 script/tag/crawler.py posts_full -u $tag -o ${dir!.path}
    ''');
  }

  void init() {
    runShell();
  }

  void downloadFile() async {
    // ByteData file;
    // final buffer = file.buffer;
    // Directory? dir = await getDownloadsDirectory();
    // File(dir!.path).writeAsBytes(
    //     buffer.asUint8List(file.offsetInBytes, file.lengthInBytes));
  }
}

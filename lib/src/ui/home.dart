import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kiscon_crawler_client/src/provider/storage_provider.dart';
import 'package:kiscon_crawler_client/src/resources/constant.dart';
import 'package:kiscon_crawler_client/src/resources/importer.dart';
import 'package:kiscon_crawler_client/src/ui/inprogress.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final urlController = TextEditingController();
  final tagController = TextEditingController();
  List<String> _selected = [];

  @override
  void dispose() {
    urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: StepProgressIndicator(
              totalSteps: 10,
              currentStep: 1,
              padding: 0,
            ),
          ),
          Row(
            children: [
              TextButton(
                onPressed: () => setState(() {
                  _selected.clear();
                }),
                child: Text("Reset"),
              ),
              TextButton(
                onPressed: () => setState(() {
                  Navigator.push(context, PageRouteBuilder(pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                    return Inprogress(category: _selected);
                  }));
                }),
                child: Text("Run"),
              ),
            ],
          ),
          ChangeNotifierProvider(
            create: (ctx) => StorageProvider(),
            lazy: false,
            builder: (ctx, child) {
              return Container(
                  child: ctx.read<StorageProvider>().isInit
                      ? Column(
                          children: [
                            Text("Please select type"),
                            Container(
                              padding: EdgeInsets.all(20),
                              child: GridView.count(
                                shrinkWrap: true,
                                crossAxisCount: 4,
                                childAspectRatio: 4 / 1,
                                children: Constant.common.keys.map((e) => _selectBtn(e, Constant.common)).toList(),
                              ),
                            ),
                            Text("Please profession type"),
                            Container(
                                padding: EdgeInsets.all(20),
                                child: GridView.count(
                                  shrinkWrap: true,
                                  crossAxisCount: 4,
                                  childAspectRatio: 4 / 1,
                                  children: Constant.profession.keys.map((e) => _selectBtn(e, Constant.profession)).toList(),
                                )),
                          ],
                        )
                      : TextButton(
                          onPressed: () {
                            setState(() {
                              SnackBar(content: Text('Refresh.....'));
                            });
                          },
                          child: Text("Please init datas...")));
            },
          )
        ],
      ),
    );
  }

  Color _isContains(int type, String name) {
    switch (type) {

      /// text color
      case 1:
        return _selected.contains(name) ? Theme.of(context).textSelectionTheme.selectionColor! : Theme.of(context).primaryColor;

      /// background
      case 2:
        return _selected.contains(name) ? Theme.of(context).selectedRowColor : Theme.of(context).cardColor;
      default:
        return _selected.contains(name) ? Theme.of(context).textSelectionTheme.selectionColor! : Theme.of(context).primaryColor;
    }
  }

  Widget _selectBtn(String key, Map data) {
    return InkWell(
      onTap: () {
        setState(() {
          if (_selected.contains(key)) {
            _selected.remove(key);
          } else {
            _selected.add(key);
          }
        });
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _isContains(2, key),
          border: Border.all(color: _isContains(1, key)),
          borderRadius: BorderRadius.circular(6),
        ),
        margin: EdgeInsets.all(5),
        child: Text(
          data[key] ?? '',
          textAlign: TextAlign.center,
          style: TextStyle(color: _isContains(1, key)),
        ),
      ),
    );
  }
}

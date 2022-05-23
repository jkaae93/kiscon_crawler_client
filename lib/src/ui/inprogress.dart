import 'package:flutter/material.dart';
import 'package:kiscon_crawler_client/src/resources/importer.dart';
import 'package:provider/provider.dart';

class Inprogress extends StatefulWidget {
  final List<String> category;
  Inprogress({Key? key, required this.category}) : super(key: key);

  @override
  State<Inprogress> createState() => _InprogressState();
}

class _InprogressState extends State<Inprogress> {
  List<String> _log = [];
  var _provider = context.read<Importer>();

  @override
  void initState() {
    super.initState();
    _provider.runShell(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Log"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ChangeNotifierProvider(
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: _log.length,
                  itemBuilder: ((context, index) => Text(_log[index])),
                );
              },
              create: (BuildContext context) => Importer(() => setState(() => {})),
            ),
          ),
        ],
      ),
    );
  }
}

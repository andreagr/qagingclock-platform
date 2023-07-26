import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class UploadStep extends StatefulWidget {
  UploadStep({super.key, required this.loading});

  final bool loading;

  @override
  State<StatefulWidget> createState() => UploadStepState();
}

class UploadStepState extends State<UploadStep> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          child: widget.loading ? isLoadingWidget() : uploadFinishedWidget()),
    );
  }

  Widget isLoadingWidget() {
    return Column(children: [
      CircularProgressIndicator(color: Theme.of(context).primaryColor),
      Text("Uploading your files, wait a moment..."),
      SizedBox(height: 20),
      Text(
        quotes.elementAt(Random().nextInt(quotes.length)),
        style: TextStyle(fontWeight: FontWeight.bold),
      )
    ]);
  }

  Widget uploadFinishedWidget() {
    return Column(children: [
      Icon(Icons.check, color: Theme.of(context).primaryColor),
      Text("Upload complete, we will be in touch"),
    ]);
  }

  List<String> quotes = [
    '“Ageism is prejudice against our future selves”',
    '“To Me, Old Age is always Thirty Years Older than Me”',
    '“Ageing is a failure of maintenance and repair”',
    '“It’s fascinating to realize that only a quarter how you age is genetically determined”',
    '“For every year we age we only approach death by nine months.”',
    '“We tacked all these extra years on at the end and only old age got longer”'
  ];
}

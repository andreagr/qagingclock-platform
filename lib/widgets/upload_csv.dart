import 'dart:html';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:file_picker/file_picker.dart';

class CsvUploadStep extends StatefulWidget {
  final Function onSave;

  const CsvUploadStep({super.key, required this.onSave});

  @override
  _CsvUploadStepState createState() => _CsvUploadStepState();
}

class _CsvUploadStepState extends State<CsvUploadStep> {
  String? _uploadedFiles;
  FilePickerResult? result;
  bool highlighted1 = false;
  late DropzoneViewController controller1;
  String message1 = 'Drop something here';

  void _handleFileDrop(String fileName, Uint8List bytes) {
    print("Dropped");
    setState(() {
      _uploadedFiles = fileName;
    });
    widget.onSave(1, fileName, bytes);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Container(
        width: 468,
        decoration: BoxDecoration(
          color: theme.colorScheme.inversePrimary,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Upload Methylation Data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 200,
              width: 300,
              padding: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                  color: highlighted1 ? theme.primaryColorLight : Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      child: Stack(
                        children: [
                          DropzoneView(
                            operation: DragOperation.copy,
                            cursor: CursorType.grab,
                            onCreated: (ctrl) => controller1 = ctrl,
                            onLoaded: () => print('Zone 1 loaded'),
                            onError: (ev) => print('Zone 1 error: $ev'),
                            onHover: () {
                              setState(() {
                                highlighted1 = true;
                              });
                              print('Zone 1 hovered');
                            },
                            onLeave: () {
                              setState(() => highlighted1 = false);
                              print('Zone 1 left');
                            },
                            onDrop: (ev) async {
                              print('Zone 1 drop: ${ev.name}');
                              setState(() {
                                message1 = '${ev.name} dropped';
                                highlighted1 = false;
                              });
                              Uint8List? fileBytes =
                                  await controller1.getFileData(ev);
                              _handleFileDrop(ev.name, fileBytes);
                            },
                          ),
                          Center(child: Text("Drop something here")),
                          Padding(
                            padding: EdgeInsets.only(top: 50),
                            child: Center(
                              child: Icon(
                                Icons.cloud_upload,
                                size: 35,
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      result = await FilePicker.platform.pickFiles(
                          type: FileType.custom, allowedExtensions: ['csv']);

                      if (result != null) {
                        Uint8List? fileBytes = result!.files.first.bytes;
                        String fileName = result!.files.first.name;
                        _handleFileDrop(fileName, fileBytes!);
                        // Upload file
                        //await FirebaseStorage.instance.ref('uploads/$fileName').putData(fileBytes);
                      }
                    },
                    child: const Text('or pick file'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Uploaded Files:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(_uploadedFiles.isNull ? "No file" : _uploadedFiles!)
          ],
        ),
      ),
    );
  }
}

class DragDropArea extends StatefulWidget {
  final void Function(List<String> files) onFileDropped;

  DragDropArea({required this.onFileDropped});

  @override
  _DragDropAreaState createState() => _DragDropAreaState();
}

class _DragDropAreaState extends State<DragDropArea> {
  bool _isDragOver = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DragTarget<List<String>>(
      onWillAccept: (data) => true,
      onAccept: (data) {
        setState(() {
          _isDragOver = false;
        });
        widget.onFileDropped(data);
      },
      onLeave: (data) {
        setState(() {
          _isDragOver = false;
        });
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            color: _isDragOver
                ? theme.colorScheme.primaryContainer
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isDragOver ? Icons.file_upload : Icons.cloud_upload,
                  size: 50,
                  color: _isDragOver
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onSurface,
                ),
                SizedBox(height: 10),
                Text(
                  _isDragOver
                      ? 'Drop the CSV file'
                      : 'Drag and drop CSV file here',
                  style: TextStyle(
                    color: _isDragOver
                        ? theme.colorScheme.onPrimaryContainer
                        : theme.colorScheme.onSurface,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

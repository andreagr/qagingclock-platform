import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:qagingclock/widgets/aging_chart_simple.dart';
import 'package:qagingclock/widgets/basic_info_form.dart';
import 'package:qagingclock/widgets/upload_csv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StepperScreen extends StatefulWidget {
  @override
  _StepperScreenState createState() => _StepperScreenState();
}

class _StepperScreenState extends State<StepperScreen> {
  int _currentStep = 0;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool loading = false;

  Map<int, Map<String, dynamic>> formData = {
    0: {},
    1: {},
  };

  void onSaveData(int step, String key, dynamic value) {
    setState(() {
      formData[step]![key] = value;
    });
  }

  bool? submitData(int step) {
    print(step);
    print(_formKey.currentState!.validate());
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Q-AgingClock",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          type: StepperType.horizontal,
          steps: [
            Step(
              title: Text('User information'),
              content: FormStep(
                formData: formData[0]!,
                onSave: onSaveData,
              ),
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
              isActive: _currentStep >= 0,
            ),
            Step(
              title: Text('Methylation data upload'),
              content: CsvUploadStep(
                onSave: onSaveData,
              ),
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
              isActive: _currentStep >= 1,
            ),
            Step(
              title: Text('Upload'),
              content: UploadStep(loading: loading),
              state: _currentStep > 2 ? StepState.complete : StepState.indexed,
              isActive: _currentStep >= 2,
            ),
          ],
          onStepContinue: () {
            if (_currentStep < 3 - 1) {
              //_currentStep++;
              //return;
              if (_formKey.currentState!.validate()) {
                setState(() {
                  _currentStep++;
                });
                if (_currentStep == 2) {
                  uploadAll();
                }
              }
            } else {
              // Handle last step completion
              // e.g., submit the form, process the data, etc.
              print('Stepper completed');
            }
          },
          onStepCancel: () {
            setState(() {
              if (_currentStep > 0 && _currentStep < 2) {
                _currentStep--;
              } else {
                _currentStep = 0;
              }
            });
          },
          controlsBuilder: (context, details) => _currentStep < 2
              ? Row(
                  children: [
                    ElevatedButton(
                      onPressed: details.onStepContinue,
                      child: const Text('Next'),
                    ),
                    TextButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Back'),
                    )
                  ],
                )
              : Container(),
        ),
      ),
    );
  }

  Future<String?> updateFirestore(Map<String, dynamic> formData) async {
    try {
      // Save the form data as a document in Firestore
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('submissions')
          .add(formData);

      print('Form data saved successfully!');
      return docRef.id;
    } catch (e) {
      print('Error saving form data: $e');
      return null;
    }
  }

  Future<void> uploadFirebaseStorage(String fileName, Uint8List bytes) async {
    try {
      final storageRef = FirebaseStorage.instance.ref('uploads/$fileName');
      await storageRef.putData(bytes);
      print('File uploaded to Firebase Storage');
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

  Future<void> uploadAll() async {
    setState(() {
      loading = true;
    });
    String? docId = await updateFirestore(formData[0]!);
    if (docId == null) {
      print('Errore in uploadAll');
      return;
    }

    for (String fileName in formData[1]!.keys) {
      await uploadFirebaseStorage(
          docId + '/' + fileName, formData[1]![fileName]);
    }
    setState(() {
      loading = false;
    });
  }
}

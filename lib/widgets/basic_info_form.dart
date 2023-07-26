import 'dart:js_interop';

import 'package:flutter/material.dart';

class FormStep extends StatefulWidget {
  final Map<String, dynamic> formData;
  final Function onSave;

  const FormStep({
    Key? key,
    required this.formData,
    required this.onSave,
  }) : super(key: key);

  @override
  _FormStepState createState() => _FormStepState();
}

class _FormStepState extends State<FormStep> {
  @override
  void initState() {
    super.initState();
  }

  bool _dataTreatmentPermission = false;

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
            TextFormField(
              decoration: InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
              onChanged: (value) {
                //widget.formData['name'] = value;
                widget.onSave(0, 'name', value);
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Surname'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your surname';
                }
                return null;
              },
              onChanged: (value) {
                //widget.formData['surname'] = value;
                widget.onSave(0, 'surname', value);
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
              onChanged: (value) {
                //widget.formData['email'] = value;
                widget.onSave(0, 'email', value);
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Institution'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your institution';
                }
                return null;
              },
              onChanged: (value) {
                //widget.formData['institution'] = value;
                widget.onSave(0, 'institution', value);
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

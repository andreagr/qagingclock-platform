import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PreviousSubmissionsScreen extends StatefulWidget {
  @override
  _PreviousSubmissionsScreenState createState() =>
      _PreviousSubmissionsScreenState();
}

class _PreviousSubmissionsScreenState extends State<PreviousSubmissionsScreen> {
  List<Map<String, dynamic>> submissionsData = [];

  @override
  void initState() {
    super.initState();
    // Fetch previous submissions data from Firestore when the screen loads
    _fetchPreviousSubmissions();
  }

  Future<void> _fetchPreviousSubmissions() async {
    try {
      // Fetch submissions data from Firestore collection 'submissions'
      final snapshot =
          await FirebaseFirestore.instance.collection('submissions').get();

      // Convert the data into a List of maps
      final data = snapshot.docs
          .map((doc) => {
                'documentId': doc.id,
                'name': doc['name'],
                'surname': doc['surname'],
                'email': doc['email'],
                'institution': doc['institution'],
              })
          .toList();

      setState(() {
        submissionsData = data;
      });
    } catch (e) {
      print('Error fetching submissions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Previous Submissions')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: DataTable(
            columns: [
              DataColumn(label: Text('Document ID')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Surname')),
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('Institution')),
            ],
            rows: submissionsData.map((data) {
              return DataRow(cells: [
                DataCell(Text(data['documentId'])),
                DataCell(Text(data['name'])),
                DataCell(Text(data['surname'])),
                DataCell(Text(data['email'])),
                DataCell(Text(data['institution'])),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }
}

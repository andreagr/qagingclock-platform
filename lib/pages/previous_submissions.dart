import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qagingclock/providers/auth_provider.dart';
import 'package:provider/provider.dart';

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
                'insertionDate': doc['insertionDate'] != null
                    ? DateTime.fromMillisecondsSinceEpoch(doc['insertionDate'])
                        .toUtc()
                        .toString()
                    : 'No Data'
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.home_rounded),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
            );
          },
        ),
        actions: [
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  AuthProvider authProvider =
                      Provider.of<AuthProvider>(context, listen: false);
                  await authProvider.signOut();
                  Navigator.pushReplacementNamed(context, '/login');
                },
              );
            },
          ),
        ],
        title: Text('Previous Submissions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          color: Colors.white,
          child: DataTable(
            columns: [
              DataColumn(label: Text('Document ID')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Surname')),
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('Institution')),
              DataColumn(label: Text('Insertion Date')),
            ],
            rows: submissionsData.map((data) {
              return DataRow(cells: [
                DataCell(Text(data['documentId'])),
                DataCell(Text(data['name'])),
                DataCell(Text(data['surname'])),
                DataCell(Text(data['email'])),
                DataCell(Text(data['institution'])),
                DataCell(Text(data['insertionDate'])),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:qagingclock/widgets/choice_card.dart';

class UserChoiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text('Welcome, User!')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GridView.count(
            crossAxisCount: screenWidth > 600 ? 2 : 1,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            children: [
              ChoiceCard(
                title: 'Check Previous Submissions',
                description:
                    'View your previous submissions and study results.',
                icon: Icons.history,
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/submissions');
                },
              ),
              ChoiceCard(
                title: 'Submit New Study',
                description: 'Submit a new study for analysis.',
                icon: Icons.add_circle,
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/analysis');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

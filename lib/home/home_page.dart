import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/bloc/example/');
              },
              child: const Text('Default example'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/bloc/example/freezed');
              },
              child: const Text('Freezed example'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/contacts/list');
              },
              child: const Text('Contacts list'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/contacts/cubit/list');
              },
              child: const Text('Contacts cubit list'),
            ),
          ],
        ),
      ),
    );
  }
}

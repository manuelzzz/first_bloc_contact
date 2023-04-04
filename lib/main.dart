import 'package:first_bloc_contact/features/examples/bloc_example/bloc/example_bloc.dart';
import 'package:first_bloc_contact/features/examples/bloc_example/bloc_example.dart';
import 'package:first_bloc_contact/features/examples/bloc_example/bloc_freezed/example_freezed_bloc.dart';
import 'package:first_bloc_contact/features/examples/bloc_example/bloc_freezed_example.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (_) => const HomePage(),
        '/bloc/example/': (_) => BlocProvider(
              create: (_) => ExampleBloc()..add(ExampleFindNameEvent()),
              child: BlocExample(),
            ),
        '/bloc/example/freezed': (context) => BlocProvider(
              create: (context) => ExampleFreezedBloc()
                ..add(
                  const ExampleFreezedEvent.findNames(),
                ),
              child: const BlocFreezedExample(),
            ),
      },
    );
  }
}

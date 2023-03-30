import 'package:first_bloc_contact/features/examples/bloc_example/bloc/example_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocExample extends StatelessWidget {
  const BlocExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BlocExample'),
      ),
      body: BlocListener<ExampleBloc, ExampleState>(
        listener: (context, state) {
          if (state is ExampleStateData) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('A quantidade de nomes é: ${state.names.length}'),
              ),
            );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocConsumer<ExampleBloc, ExampleState>(
              builder: (_, state) {
                if (state is ExampleStateData) {
                  return Text('Total de nomes é: ${state.names.length}');
                }
                return const SizedBox.shrink();
              },
              listener: (context, state) {
                if (kDebugMode) {
                  print('Estado alterado. Notificado com bloc consumer');
                }
              },
            ),
            BlocSelector<ExampleBloc, ExampleState, bool>(
              selector: (state) {
                if (state is ExampleStateInitial) {
                  return true;
                }
                return false;
              },
              builder: (context, showLoader) {
                if (showLoader) {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            BlocSelector<ExampleBloc, ExampleState, List<String>>(
              selector: (state) {
                if (state is ExampleStateData) {
                  return state.names;
                }
                return [];
              },
              builder: (context, names) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: names.length,
                  itemBuilder: (context, index) {
                    final name = names[index];

                    return ListTile(
                      title: Text(name),
                    );
                  },
                );
              },
            ),
            /*
            BlocBuilder<ExampleBloc, ExampleState>(
              builder: (context, state) {
                if (state is ExampleStateData) {
                  // have names
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.names.length,
                    itemBuilder: (context, index) {
                      final name = state.names[index];

                      return ListTile(
                        title: Text(name),
                      );
                    },
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            */
          ],
        ),
      ),
    );
  }
}

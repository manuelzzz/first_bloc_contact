import 'package:first_bloc_contact/features/examples/bloc_example/bloc/example_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocExample extends StatelessWidget {
  BlocExample({Key? key}) : super(key: key);

  final nameEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BlocExample'),
      ),
      body: ListView(
        children: [
          BlocListener<ExampleBloc, ExampleState>(
            listenWhen: (previous, current) {
              return current is ExampleStateData;
              /*
                    if (previous is ExampleStateInitial && current is ExampleStateData) {
                      return current.names.length > 4;
                    } 
                    return false;
                    */
            },
            listener: (context, state) {
              if (state is ExampleStateData) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('A quantidade de nomes é: ${state.names.length}'),
                  ),
                );
              }
            },
            child: SizedBox(
              height: 750,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  BlocConsumer<ExampleBloc, ExampleState>(
                    buildWhen: (previous, current) {
                      if (previous is ExampleStateInitial &&
                          current is ExampleStateData) {
                        return current.names.length > 4;
                      }
                      return false;
                    },
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
                  BlocSelector<ExampleBloc, ExampleState, List<String>>(
                    selector: (state) {
                      if (state is ExampleStateData) {
                        return state.names;
                      }
                      return [];
                    },
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Form(
                          child: Column(
                            children: [
                              SizedBox(
                                child: TextFormField(
                                  controller: nameEC,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (nameEC.text != "") {
                                    context.read<ExampleBloc>().add(
                                          ExampleAddNameEvent(name: nameEC.text),
                                        );
                                  }
                                },
                                child: const Text('Adicionar nome'),
                              ),
                            ],
                          ),
                        ),
                      );
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
                            onTap: () {
                              context.read<ExampleBloc>().add(
                                    ExampleRemoveNameEvent(name: name),
                                  );
                            },
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
          ),
        ],
      ),
    );
  }
}

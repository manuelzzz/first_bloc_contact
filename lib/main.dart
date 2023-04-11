import 'package:first_bloc_contact/features/contacts/list/bloc/contact_list_bloc.dart';
import 'package:first_bloc_contact/features/contacts/list/contacts_list_page.dart';
import 'package:first_bloc_contact/features/contacts/register/bloc/contact_register_bloc.dart';
import 'package:first_bloc_contact/features/contacts/register/contacts_register_page.dart';
import 'package:first_bloc_contact/features/contacts/update/bloc/contact_update_bloc.dart';
import 'package:first_bloc_contact/features/contacts/update/contacts_update_page.dart';
import 'package:first_bloc_contact/features/examples/bloc_example/bloc/example_bloc.dart';
import 'package:first_bloc_contact/features/examples/bloc_example/bloc_example.dart';
import 'package:first_bloc_contact/features/examples/bloc_example/bloc_freezed/example_freezed_bloc.dart';
import 'package:first_bloc_contact/features/examples/bloc_example/bloc_freezed_example.dart';
import 'package:first_bloc_contact/models/contact_model.dart';
import 'package:first_bloc_contact/repositories/contacts_repository.dart';
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
    return RepositoryProvider(
      create: (_) => ContactsRepository(),
      child: MaterialApp(
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
          '/bloc/example/freezed': (_) => BlocProvider(
                create: (_) => ExampleFreezedBloc()
                  ..add(
                    const ExampleFreezedEvent.findNames(),
                  ),
                child: const BlocFreezedExample(),
              ),
          '/contacts/list': (context) => BlocProvider(
                create: (context) => ContactListBloc(
                  repository: context.read<ContactsRepository>(),
                )..add(
                    const ContactListEvent.findAll(),
                  ),
                child: const ContactsListPage(),
              ),
          '/contacts/register': (_) => BlocProvider(
                create: (context) => ContactRegisterBloc(
                  contactsRepository: context.read<ContactsRepository>(),
                ),
                child: const ContactsRegisterPage(),
              ),
          '/contacts/update': (context) {
            final model =
                ModalRoute.of(context)!.settings.arguments as ContactModel;

            return BlocProvider(
              create: (context) => ContactUpdateBloc(
                contactsRepository: context.read(),
              ),
              child: ContactsUpdatePage(
                contact: model,
              ),
            );
          }
        },
      ),
    );
  }
}

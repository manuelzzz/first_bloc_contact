import 'package:first_bloc_contact/features/contacts/list/bloc/contact_list_bloc.dart';
import 'package:first_bloc_contact/models/contact_model.dart';
import 'package:first_bloc_contact/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsListPage extends StatelessWidget {
  const ContactsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts List'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/contacts/register');

          if (context.mounted) {
            context
                .read<ContactListBloc>()
                .add(const ContactListEvent.findAll());
          }
        },
        child: const Icon(Icons.add),
      ),
      body: BlocListener<ContactListBloc, ContactListState>(
        listenWhen: (previous, current) {
          return current.maybeWhen(
            error: (error) => true,
            orElse: () => false,
          );
        },
        listener: (context, state) {
          state.whenOrNull(error: (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  error,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red,
              ),
            );
          });
        },
        child: RefreshIndicator(
          onRefresh: () async => context
              .read<ContactListBloc>()
              .add(const ContactListEvent.findAll()),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                child: Column(
                  children: [
                    Loader<ContactListBloc, ContactListState>(
                      selector: (state) {
                        return state.maybeWhen(
                          loading: () => true,
                          orElse: () => false,
                        );
                      },
                    ),
                    BlocSelector<ContactListBloc, ContactListState,
                        List<ContactModel>>(
                      selector: (state) {
                        return state.maybeWhen(
                          data: (contacts) => contacts,
                          orElse: () => <ContactModel>[],
                        );
                      },
                      builder: (_, contacts) {
                        return RefreshIndicator(
                          onRefresh: () async => context
                              .read<ContactListBloc>()
                              .add(const ContactListEvent.findAll()),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: contacts.length,
                            itemBuilder: (context, index) {
                              final contact = contacts[index];
                              return ListTile(
                                title: Text(contact.name),
                                subtitle: Text(contact.email),
                                onTap: () async {
                                  await Navigator.pushNamed(
                                    context,
                                    '/contacts/update',
                                    arguments: contact,
                                  );
                                  if (context.mounted) {
                                    context
                                        .read<ContactListBloc>()
                                        .add(const ContactListEvent.findAll());
                                  }
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

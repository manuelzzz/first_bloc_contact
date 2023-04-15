import 'package:first_bloc_contact/features/contacts_cubit/list/cubit/contact_list_cubit.dart';
import 'package:first_bloc_contact/models/contact_model.dart';
import 'package:first_bloc_contact/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsCubitListPage extends StatelessWidget {
  const ContactsCubitListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List cubit'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed('/contacts/cubit/register');
          if (context.mounted) {
            context.read<ContactListCubit>().findAll();
          }
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<ContactListCubit>().findAll(),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: Column(
                children: [
                  Loader<ContactListCubit, ContactListCubitState>(
                    selector: (state) {
                      return state.maybeWhen(
                        loading: () => true,
                        orElse: () => false,
                      );
                    },
                  ),
                  BlocSelector<ContactListCubit, ContactListCubitState,
                      List<ContactModel>>(
                    selector: (state) {
                      return state.maybeWhen(
                        data: (contacts) => contacts,
                        orElse: () => <ContactModel>[],
                      );
                    },
                    builder: (context, contacts) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: contacts.length,
                        itemBuilder: (_, index) {
                          final contact = contacts[index];
                          return ListTile(
                            onTap: () => context
                                .read<ContactListCubit>()
                                .deleteByModel(contact),
                            onLongPress: () async {
                              await Navigator.pushNamed(
                                context,
                                '/contacts/cubit/update',
                                arguments: contact,
                              );
                              if (context.mounted) {
                                context.read<ContactListCubit>().findAll();
                              }
                            },
                            title: Text(contact.name),
                            subtitle: Text(contact.email),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

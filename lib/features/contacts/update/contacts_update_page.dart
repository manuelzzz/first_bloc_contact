import 'package:first_bloc_contact/features/contacts/update/bloc/contact_update_bloc.dart';
import 'package:first_bloc_contact/models/contact_model.dart';
import 'package:first_bloc_contact/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsUpdatePage extends StatefulWidget {
  final ContactModel contact;

  const ContactsUpdatePage({Key? key, required this.contact}) : super(key: key);

  @override
  State<ContactsUpdatePage> createState() => _ContactsUpdatePageState();
}

class _ContactsUpdatePageState extends State<ContactsUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameEC;
  late final TextEditingController _emailEC;

  @override
  void initState() {
    _nameEC = TextEditingController(text: widget.contact.name);
    _emailEC = TextEditingController(text: widget.contact.email);
    super.initState();
  }

  @override
  void dispose() {
    _nameEC.dispose();
    _emailEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact update'),
      ),
      body: BlocListener<ContactUpdateBloc, ContactUpdateState>(
        listener: (context, state) {
          state.whenOrNull(
            success: () => Navigator.of(context).pop(),
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    message,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameEC,
                  decoration: const InputDecoration(
                    label: Text('Nome'),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Nome é obrigatório';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailEC,
                  decoration: const InputDecoration(
                    label: Text('Email'),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'E-mail é obrigatório';
                    }
                    return null;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        final validate =
                            _formKey.currentState?.validate() ?? false;

                        if (validate) {
                          context.read<ContactUpdateBloc>().add(
                                ContactUpdateEvent.save(
                                  id: widget.contact.id!,
                                  name: _nameEC.text,
                                  email: _emailEC.text,
                                ),
                              );
                        }
                      },
                      icon: Icon(
                        Icons.save,
                        color: Colors.blue.shade600,
                      ),
                      style: ButtonStyle(
                        iconColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: () {
                        final validate =
                            _formKey.currentState?.validate() ?? false;

                        if (validate) {
                          context.read<ContactUpdateBloc>().add(
                                ContactUpdateEvent.delete(
                                  model: ContactModel(
                                    id: widget.contact.id!,
                                    name: _nameEC.text,
                                    email: _emailEC.text,
                                  ),
                                ),
                              );
                        }
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red.shade600,
                      ),
                    ),
                  ],
                ),
                Loader<ContactUpdateBloc, ContactUpdateState>(
                  selector: (state) {
                    return state.maybeWhen(
                      loading: () => true,
                      orElse: () => false,
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

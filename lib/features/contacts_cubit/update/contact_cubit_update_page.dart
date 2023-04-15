import 'package:first_bloc_contact/features/contacts_cubit/update/cubit/cubit/contact_update_cubit.dart';
import 'package:first_bloc_contact/models/contact_model.dart';
import 'package:first_bloc_contact/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactCubitUpdatePage extends StatefulWidget {
  final ContactModel contact;

  const ContactCubitUpdatePage({Key? key, required this.contact})
      : super(key: key);

  @override
  State<ContactCubitUpdatePage> createState() => _ContactCubitUpdatePageState();
}

class _ContactCubitUpdatePageState extends State<ContactCubitUpdatePage> {
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
        title: const Text('Update'),
      ),
      body: BlocListener<ContactUpdateCubit, ContactUpdateState>(
        listener: (context, state) {
          state.whenOrNull(
            success: () => Navigator.of(context).pop(),
            error: (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    error,
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
                      return 'Email é obrigatório';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    final valid = _formKey.currentState?.validate() ?? false;

                    if (valid) {
                      context.read<ContactUpdateCubit>().save(
                            model: ContactModel(
                              id: widget.contact.id,
                              name: _nameEC.text,
                              email: _emailEC.text,
                            ),
                          );
                    }
                  },
                  child: const Icon(Icons.save),
                ),
                Loader<ContactUpdateCubit, ContactUpdateState>(
                  selector: (state) {
                    return state.maybeWhen(
                      loading: () => true,
                      orElse: () => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

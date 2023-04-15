import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:first_bloc_contact/models/contact_model.dart';
import 'package:first_bloc_contact/repositories/contacts_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_register_cubit_state.dart';
part 'contact_register_cubit.freezed.dart';

class ContactRegisterCubit extends Cubit<ContactRegisterCubitState> {
  final ContactsRepository _repository;

  ContactRegisterCubit({required ContactsRepository repository})
      : _repository = repository,
        super(ContactRegisterCubitState.initial());

  Future<void> add(ContactModel model) async {
    try {
      emit(ContactRegisterCubitState.loading());

      await _repository.create(model);

      emit(ContactRegisterCubitState.success());
    } on Exception catch (e, s) {
      log('Erro ao acrescentar o contato', error: e, stackTrace: s);

      emit(
        ContactRegisterCubitState.error(error: 'Erro ao acrescentar o contato'),
      );
    }
  }
}

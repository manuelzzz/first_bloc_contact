import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:first_bloc_contact/models/contact_model.dart';
import 'package:first_bloc_contact/repositories/contacts_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_update_state.dart';
part 'contact_update_cubit.freezed.dart';

class ContactUpdateCubit extends Cubit<ContactUpdateState> {
  final ContactsRepository _repository;

  ContactUpdateCubit({required ContactsRepository repository})
      : _repository = repository,
        super(ContactUpdateState.initial());

  Future<void> save({required ContactModel model}) async {
    try {
      emit(ContactUpdateState.loading());

      await _repository.update(model);

      emit(ContactUpdateState.success());
    } on Exception catch (e, s) {
      log('Não foi possível alterar o contato', error: e, stackTrace: s);
      emit(
        ContactUpdateState.error(error: 'Não foi possível alterar o contato'),
      );
    }
  }
}

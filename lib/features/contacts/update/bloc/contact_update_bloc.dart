import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:first_bloc_contact/models/contact_model.dart';
import 'package:first_bloc_contact/repositories/contacts_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_update_event.dart';
part 'contact_update_state.dart';
part 'contact_update_bloc.freezed.dart';

class ContactUpdateBloc extends Bloc<ContactUpdateEvent, ContactUpdateState> {
  final ContactsRepository _contactsRepository;

  ContactUpdateBloc({required ContactsRepository contactsRepository})
      : _contactsRepository = contactsRepository,
        super(const _Initial()) {
    on<_Save>(_save);
    on<_Delete>(_delete);
  }

  Future<FutureOr<void>> _save(
    _Save event,
    Emitter<ContactUpdateState> emit,
  ) async {
    try {
      emit(const ContactUpdateState.loading());

      final model = ContactModel(
        id: event.id,
        name: event.name,
        email: event.email,
      );

      await _contactsRepository.update(model);

      emit(const ContactUpdateState.success());
    } on Exception catch (e, s) {
      log('Erro ao atualizar o contato', error: e, stackTrace: s);
      emit(const ContactUpdateState.error(
        message: 'Erro ao atualizar o contato',
      ));
    }
  }

  Future<FutureOr<void>> _delete(
    _Delete event,
    Emitter<ContactUpdateState> emit,
  ) async {
    try {
      emit(const ContactUpdateState.loading());

      await _contactsRepository.delete(event.model);

      emit(const ContactUpdateState.success());
    } on Exception catch (e, s) {
      log('Erro ao deletar o contato', error: e, stackTrace: s);
      emit(const ContactUpdateState.error(
        message: 'Erro ao deletar o contato',
      ));
    }
  }
}

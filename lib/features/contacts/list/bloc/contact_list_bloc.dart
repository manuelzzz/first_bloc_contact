import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:first_bloc_contact/repositories/contacts_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:first_bloc_contact/models/contact_model.dart';

part 'contact_list_event.dart';
part 'contact_list_state.dart';
part 'contact_list_bloc.freezed.dart';

class ContactListBloc extends Bloc<ContactListEvent, ContactListState> {
  final ContactsRepository _repository;

  ContactListBloc({required ContactsRepository repository})
      : _repository = repository,
        super(ContactListState.initial()) {
    on<_ContactListEventFindAll>(_findAll);
  }

  FutureOr<void> _findAll(
    _ContactListEventFindAll event,
    Emitter<ContactListState> emit,
  ) async {
    try {
      emit(ContactListState.loading());
      final contacts = await _repository.findAll();

      // Simulating error situation:
      // await Future.delayed(const Duration(seconds: 1));
      // throw Exception();

      emit(ContactListState.data(contacts: contacts));
    } catch (e, s) {
      log('Erro ao buscar contatos', error: e, stackTrace: s);
      emit(ContactListState.error(error: 'Erro ao buscar contatos'));
    }
  }
}

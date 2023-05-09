import 'package:bloc_test/bloc_test.dart';
import 'package:first_bloc_contact/features/contacts/update/bloc/contact_update_bloc.dart';
import 'package:first_bloc_contact/models/contact_model.dart';
import 'package:first_bloc_contact/repositories/contacts_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockContactsRepository extends Mock implements ContactsRepository {}

void main() {
  late ContactsRepository repository;
  late ContactUpdateBloc bloc;
  late ContactModel model;

  setUp(() {
    repository = MockContactsRepository();
    bloc = ContactUpdateBloc(
      contactsRepository: repository,
    );

    model = ContactModel(id: "x", name: 'name', email: 'email');
  });

  blocTest<ContactUpdateBloc, ContactUpdateState>(
    'Update do contato',
    build: () => bloc,
    act: (bloc) => bloc.add(ContactUpdateEvent.save(
      id: model.id!,
      name: model.name,
      email: model.email,
    )),
    setUp: () {
      when(() => repository.update(model)).thenAnswer((_) async => model);
    },
    expect: () => [
      const ContactUpdateState.loading(),
      const ContactUpdateState.success(),
    ],
  );

  blocTest(
    'Update do contato, caso de erro',
    build: () => bloc,
    act: (bloc) => bloc.add(ContactUpdateEvent.save(
      id: model.id!,
      name: model.name,
      email: model.email,
    )),
    expect: () => [
      const ContactUpdateState.loading(),
      const ContactUpdateState.error(message: 'Erro ao atualizar o contato'),
    ],
  );
}

import 'package:bloc_test/bloc_test.dart';
import 'package:first_bloc_contact/features/contacts/list/bloc/contact_list_bloc.dart';
import 'package:first_bloc_contact/models/contact_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:first_bloc_contact/repositories/contacts_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockContactsRepository extends Mock implements ContactsRepository {}

void main() {
  // os testes tem 3 partes:

  // Declaração
  late ContactsRepository repository;
  late ContactListBloc bloc;
  late List<ContactModel> contacts;

  // Preparação
  setUp(() {
    repository = MockContactsRepository();
    bloc = ContactListBloc(
      repository: repository,
    );

    contacts = [
      ContactModel(name: 'Nome teste 1', email: 'email.teste1@gmail.com'),
      ContactModel(name: 'Nome teste 2', email: 'email.teste2@gmail.com'),
    ];
  });

  // Execução
  blocTest<ContactListBloc, ContactListState>(
    'Realiza a busca dos contatos',
    build: () => bloc,
    setUp: () {
      when(() => repository.findAll()).thenAnswer((_) async => contacts);
    },
    act: (bloc) => bloc.add(const ContactListEvent.findAll()),
    expect: () => [
      ContactListState.loading(),
      ContactListState.data(contacts: contacts),
    ],
  );

  blocTest<ContactListBloc, ContactListState>(
    'Deve retornar erro ao buscar os contatos',
    build: () => bloc,
    act: (bloc) => bloc.add(const ContactListEvent.findAll()),
    expect: () => [
      ContactListState.loading(),
      ContactListState.error(error: 'Erro ao buscar contatos'),
    ],
  );
}

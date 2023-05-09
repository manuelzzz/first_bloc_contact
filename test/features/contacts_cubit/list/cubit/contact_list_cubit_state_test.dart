import 'package:bloc_test/bloc_test.dart';
import 'package:first_bloc_contact/features/contacts_cubit/list/cubit/contact_list_cubit.dart';
import 'package:first_bloc_contact/models/contact_model.dart';
import 'package:first_bloc_contact/repositories/contacts_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockContactsRepository extends Mock implements ContactsRepository {}

void main() {
  late ContactsRepository repository;
  late ContactListCubit cubit;
  late List<ContactModel> contacts;

  setUp(() {
    repository = MockContactsRepository();
    cubit = ContactListCubit(
      repository: repository,
    );

    contacts = [
      ContactModel(name: 'Nome teste 1', email: 'email.teste1@gmail.com'),
      ContactModel(name: 'Nome teste 2', email: 'email.teste2@gmail.com'),
    ];
  });

  blocTest<ContactListCubit, ContactListCubitState>(
    'Realiza a busca dos contatos, porém, para o cubit',
    build: () => cubit,
    act: (cubit) => cubit.findAll(),
    setUp: () {
      when(() => repository.findAll()).thenAnswer((_) async => contacts);
    },
    expect: () => [
      ContactListCubitState.loading(),
      ContactListCubitState.data(contacts: contacts),
    ],
  );
}

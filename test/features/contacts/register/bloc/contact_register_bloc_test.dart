import 'package:bloc_test/bloc_test.dart';
import 'package:first_bloc_contact/features/contacts/register/bloc/contact_register_bloc.dart';
import 'package:first_bloc_contact/models/contact_model.dart';
import 'package:first_bloc_contact/repositories/contacts_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockContactsRepository extends Mock implements ContactsRepository {}

void main() {
  late MockContactsRepository repository;
  late ContactRegisterBloc bloc;
  late ContactModel model;

  setUp(() {
    repository = MockContactsRepository();
    bloc = ContactRegisterBloc(
      contactsRepository: repository,
    );

    model = ContactModel(name: 'name', email: 'email.teste@gmail.com');
  });

  blocTest<ContactRegisterBloc, ContactRegisterState>(
    'Registro de um novo contato',
    build: () => bloc,
    setUp: () {
      when(() {
        print(repository.hashCode);

        return repository.create(model);
      }).thenAnswer((_) async => model);
    },
    act: (bloc) => bloc.add(ContactRegisterEvent.save(
      name: model.name,
      emai: model.email,
    )),
    expect: () => [
      const ContactRegisterState.loading(),
      const ContactRegisterState.success(),
    ],
  );

  /*setUp(() {
    repository = MockContactsRepository();
    bloc = ContactRegisterBloc(
      contactsRepository: repository,
    );

    model = ContactModel(name: 'name', email: 'email.teste@gmail.com');
  });*/

  group(
    'description',
    () {
      late ContactRegisterBloc bloc2;
      late MockContactsRepository repository2;

      setUp(() {
        repository2 = MockContactsRepository();
        when(() => repository2.create(model)).thenThrow(Exception(''));

        bloc2 = ContactRegisterBloc(
          contactsRepository: repository2,
        );

        model = ContactModel(name: 'name', email: 'email.teste@gmail.com');
      });
      blocTest<ContactRegisterBloc, ContactRegisterState>(
        'Erro na criacao de um novo contato',
        // setUp: () {
        //   when(() {
        //     print(repository.hashCode);

        //     return repository.create(model);
        //   }).thenThrow(Exception(''));
        // },
        build: () => bloc2,
        act: (bloc2) => bloc2.add(
            ContactRegisterEvent.save(name: model.name, emai: model.email)),
        expect: () => [
          const ContactRegisterState.loading(),
          const ContactRegisterState.error(
            message: 'Erro ao salvar um novo contato',
          )
        ],
      );
    },
  );
}

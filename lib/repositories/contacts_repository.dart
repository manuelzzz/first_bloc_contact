import 'package:dio/dio.dart';
import 'package:first_bloc_contact/models/contact_model.dart';

class ContactsRepository {
  Future<List<ContactModel>> findAll() async {
    final respose = await Dio().get('http://192.168.11.10:3031/contacts');

    return respose.data
        ?.map<ContactModel>((contact) => ContactModel.fromMap(contact))
        .toList();
  }

  Future<void>? create(ContactModel model) =>
      Dio().post('http://192.168.11.10:3031/contacts', data: model.toMap());

  Future<void>? update(ContactModel model) => Dio()
      .put('http://192.168.11.10:3031/contacts/${model.id}', data: model.toMap());

  Future<void>? delete(ContactModel model) =>
      Dio().delete('http://192.168.11.10:3031/contacts/${model.id}');
}

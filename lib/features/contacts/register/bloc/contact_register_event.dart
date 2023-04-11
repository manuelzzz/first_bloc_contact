part of 'contact_register_bloc.dart';

@freezed
abstract class ContactRegisterEvent with _$ContactRegisterEvent {
  const factory ContactRegisterEvent.save({
    required String name,
    required String emai,
  }) = _Save;
}

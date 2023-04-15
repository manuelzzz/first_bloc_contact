part of 'contact_update_cubit.dart';

@freezed
class ContactUpdateState with _$ContactUpdateState {
  factory ContactUpdateState.initial() = _Initial;
  factory ContactUpdateState.success() = _Success;
  factory ContactUpdateState.loading() = _Loading;
  factory ContactUpdateState.error({required String error}) = _Error;
}

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'example_freezed_state.dart';
part 'example_freezed_event.dart';
part 'example_freezed_bloc.freezed.dart';

class ExampleFreezedBloc
    extends Bloc<ExampleFreezedEvent, ExampleFreezedState> {
  ExampleFreezedBloc() : super(ExampleFreezedState.initial()) {
    on<_ExampleFreezedEventFindNames>(_findNames);
    on<_ExampleFreezedEventAddName>(_addName);
    on<_ExampleFreezedEventRemoveName>(_removeName);
  }

  FutureOr<void> _addName(
    _ExampleFreezedEventAddName event,
    Emitter<ExampleFreezedState> emit,
  ) {
    final names = state.maybeWhen(
      data: (names) => names,
      orElse: () => const <String>[],
    );

    emit(
      ExampleFreezedState.showBanner(
        names: names,
        message: 'Nome sendo inserido, aguarde...',
      ),
    );
    Future.delayed(const Duration(seconds: 2));

    final newNames = [...names];
    newNames.add(event.name);

    emit(ExampleFreezedState.data(names: newNames));
  }

  FutureOr<void> _removeName(
    _ExampleFreezedEventRemoveName event,
    Emitter<ExampleFreezedState> emit,
  ) {
    final names = state.maybeWhen(
      data: (names) => names,
      orElse: () => const <String>[],
    );

    final newNames = [...names]..retainWhere((name) => name != event.name);

    emit(ExampleFreezedState.data(names: newNames));
  }
}

FutureOr<void> _findNames(
  _ExampleFreezedEventFindNames event,
  Emitter<ExampleFreezedState> emit,
) async {
  emit(ExampleFreezedState.loading());

  final names = [
    'Manuel',
    'Rodrigo Rahman',
    'Academia do Flutter',
    'Flutter',
    'Flutter Bloc',
  ];

  // simulating a delay in names "request"
  await Future.delayed(const Duration(seconds: 4));

  emit(ExampleFreezedState.data(names: names));
}

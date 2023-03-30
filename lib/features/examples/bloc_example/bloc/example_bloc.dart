import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';

part 'example_event.dart';
part 'example_state.dart';

class ExampleBloc extends Bloc<ExampleEvent, ExampleState> {
  ExampleBloc() : super(ExampleStateInitial()) {
    on<ExampleFindNameEvent>(_findNames);
  }

  FutureOr<void> _findNames(
    ExampleFindNameEvent event,
    Emitter<ExampleState> emit,
  ) async {
    final names = [
      'Manuel',
      'Rodrigo Rahman',
      'Academia do Flutter',
      'Flutter',
      'Flutter Bloc',
    ];

    // simulating a delay in names "request"
    await Future.delayed(const Duration(seconds: 4));

    emit(
      ExampleStateData(names: names),
    );
  }
}

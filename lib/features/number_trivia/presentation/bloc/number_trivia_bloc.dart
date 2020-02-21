import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:exampleone/core/utilities/convert.dart';
import 'package:exampleone/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:exampleone/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:exampleone/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:meta/meta.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final Convert convert;

  NumberTriviaBloc({
    @required this.getConcreteNumberTrivia,
    @required this.getRandomNumberTrivia,
    @required this.convert,
  });
  
  @override
  NumberTriviaState get initialState => Empty();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {

  }
}

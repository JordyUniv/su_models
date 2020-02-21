import 'package:exampleone/core/utilities/convert.dart';
import 'package:exampleone/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:exampleone/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:exampleone/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart';

class MockGetConcreteNumberTrivia extends Mock implements GetConcreteNumberTrivia { }
class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia { }
class MockConvert extends Mock implements Convert { }

void main() {
  MockGetConcreteNumberTrivia concreteNumberTrivia;
  MockGetRandomNumberTrivia randomNumberTrivia;
  MockConvert convert;
  NumberTriviaBloc bloc;

  setUp((){
    concreteNumberTrivia = MockGetConcreteNumberTrivia();
    randomNumberTrivia = MockGetRandomNumberTrivia();
    convert = MockConvert();
    bloc = NumberTriviaBloc(getConcreteNumberTrivia: concreteNumberTrivia, getRandomNumberTrivia: randomNumberTrivia, convert: convert);
  });

  test('state empty', (){
    expect(bloc.initialState, TypeMatcher<Empty>());
  });

}
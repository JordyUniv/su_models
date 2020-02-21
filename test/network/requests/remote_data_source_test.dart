import 'package:dio/dio.dart';
import 'package:exampleone/core/error/exceptions.dart';
import 'package:exampleone/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:exampleone/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart';

class MockDio extends Mock implements Dio {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockDio mockDio;
  setUp((){
    mockDio = MockDio();
    dataSource = NumberTriviaRemoteDataSourceImpl(mockDio);
  });

  group('test API request', (){
    final answer = NumberTriviaModel(number: 10, text: 'test');
    final number = 10;
    test('get trivia by number', () async {
      when(mockDio.get<NumberTriviaModel>(any)).thenAnswer((_) async => Response<NumberTriviaModel>(data: answer, statusCode: 200));
      final result = await dataSource.getConcreteNumberTrivia(number);
      expect(answer, result);
      verify(mockDio.get<NumberTriviaModel>(any));
    });

    test('get trivia by random', () async {
      when(mockDio.get<NumberTriviaModel>(any)).thenAnswer((_) async => Response<NumberTriviaModel>(data: answer, statusCode: 200));
      final result = await dataSource.getRandomNumberTrivia();
      expect(answer, result);
      verify(mockDio.get<NumberTriviaModel>(any));
    });

    test('answer incorrect', () async {
      when(mockDio.get<NumberTriviaModel>(any)).thenAnswer((_) async => Response<NumberTriviaModel>(data: null, statusCode: 404));
      final call = dataSource.getConcreteNumberTrivia;
      expect(() => call(number), throwsA(TypeMatcher<ServerException>()));
      verify(mockDio.get<NumberTriviaModel>(any));
    });
  });
}





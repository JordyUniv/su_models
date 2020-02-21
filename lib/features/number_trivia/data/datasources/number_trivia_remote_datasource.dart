import 'package:exampleone/core/error/exceptions.dart';
import 'package:exampleone/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:dio/dio.dart';

const BASE_TRIVIA_URL = 'http://numbersapi.com/{number}?json';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl extends NumberTriviaRemoteDataSource {
  Dio dio;

  NumberTriviaRemoteDataSourceImpl(this.dio);

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) => performeRequest(BASE_TRIVIA_URL.replaceAll('{number}', number.toString()));

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() => performeRequest(BASE_TRIVIA_URL.replaceAll('{number}', "/random/trivia"));

  Future<NumberTriviaModel> performeRequest(String url) async {
    final result = await dio.get<NumberTriviaModel>(url);
    if(result.statusCode == 200) {
      return result.data;
    } else {
      throw ServerException();
    }
  }
}
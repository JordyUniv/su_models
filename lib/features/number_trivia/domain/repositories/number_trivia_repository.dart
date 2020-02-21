import 'package:dartz/dartz.dart';
import 'package:exampleone/core/error/failures.dart';
import 'package:exampleone/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}
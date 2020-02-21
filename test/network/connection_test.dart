import 'package:exampleone/core/error/exceptions.dart';
import 'package:exampleone/core/error/failures.dart';
import 'package:exampleone/core/network/network_info.dart';
import 'package:exampleone/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:exampleone/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:exampleone/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:exampleone/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:exampleone/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRespositoryImpl repository;
  MockRemoteDataSource remoteDataSource;
  MockLocalDataSource localDataSource;
  MockNetworkInfo networkInfo;

  setUp(() {
    remoteDataSource = MockRemoteDataSource();
    localDataSource = MockLocalDataSource();
    networkInfo = MockNetworkInfo();
    repository = NumberTriviaRespositoryImpl(
        remoteDataSource: remoteDataSource,
        localDataSource: localDataSource,
        networkInfo: networkInfo);
  });

  void runTestOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('connection test', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(text: 'test trivia', number: tNumber);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test('should check if the device is online', () async {
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      repository.getConcreteNumberTrivia(tNumber);
      verify(networkInfo.isConnected);
    });

    runTestOnline(() {
      test(
          'should return data when the call to remote data source is succesful',
          () async {
        when(remoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await repository.getConcreteNumberTrivia(tNumber);
        verify(remoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(Right(tNumberTrivia)));
      });

      test('should cache the data locally', () async {
        when(remoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTriviaModel);
        await repository.getConcreteNumberTrivia(tNumber);
        verify(remoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(localDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test('should return server failure', () async {
        when(remoteDataSource.getConcreteNumberTrivia(any))
            .thenThrow(ServerException());
        final result = await repository.getConcreteNumberTrivia(tNumber);
        verify(remoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(localDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestOffline(() {
      test('return last locally cache data', () async {
        when(localDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await repository.getConcreteNumberTrivia(tNumber);

        verifyZeroInteractions(remoteDataSource);
        verify(localDataSource.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTriviaModel)));
      });

      test('device is offline and there isnt data', () async {
        when(localDataSource.getLastNumberTrivia()).thenThrow(CacheException());
        final result = await repository.getConcreteNumberTrivia(tNumber);
        verifyZeroInteractions(remoteDataSource);
        verify(localDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('connection test for random', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(text: 'test trivia', number: tNumber);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test('should check if the device is online', () async {
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      repository.getRandomNumberTrivia();
      verify(networkInfo.isConnected);
    });

    runTestOnline(() {
      test(
          'should return data when the call to remote data source is succesful',
          () async {
        when(remoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await repository.getRandomNumberTrivia();
        verify(remoteDataSource.getRandomNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test('should cache the data locally', () async {
        when(remoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
        await repository.getRandomNumberTrivia();
        verify(remoteDataSource.getRandomNumberTrivia());
        verify(localDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test('should return server failure', () async {
        when(remoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());
        final result = await repository.getRandomNumberTrivia();
        verify(remoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(localDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestOffline(() {
      test('return last locally cache data', () async {
        when(localDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await repository.getRandomNumberTrivia();

        verifyZeroInteractions(remoteDataSource);
        verify(localDataSource.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTriviaModel)));
      });

      test('device is offline and there isnt data', () async {
        when(localDataSource.getLastNumberTrivia()).thenThrow(CacheException());
        final result = await repository.getRandomNumberTrivia();
        verifyZeroInteractions(remoteDataSource);
        verify(localDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}

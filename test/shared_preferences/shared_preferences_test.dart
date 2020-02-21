import 'dart:convert';
import 'package:exampleone/core/error/exceptions.dart';
import 'package:exampleone/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:exampleone/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

class MockSharedPreferences extends Mock implements SharedPreferences { }

void main() {
  NumberTriviaLocalDataSource dataSource;
  MockSharedPreferences sharedPreferences;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(sharedPreferences);
  });

  final model = NumberTriviaModel(text: 'test', number: 123);
  group('testing shared preferences', () {
    test('get from shared preference', () async {
      when(sharedPreferences.getString(any)).thenReturn(jsonEncode(model));
      final result = await dataSource.getLastNumberTrivia();
      verify(sharedPreferences.getString(TRIVIA_CACHE_KEY));
      expect(result, equals(model));
    });

    test('when there is not data', () async {
      when(sharedPreferences.getString(any)).thenReturn(null);
      final call = dataSource.getLastNumberTrivia;
      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });

    test('save in shared preference', () async {
      dataSource.cacheNumberTrivia(model);
      final expectedJsonString = json.encode(model.toJson());
      verify(sharedPreferences.setString(TRIVIA_CACHE_KEY, expectedJsonString));
    });
  });
}
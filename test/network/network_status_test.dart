import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:exampleone/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
    NetworkInfoImpl networkInfoImpl;
    MockDataConnectionChecker mockDataConnectionChecker;

    setUp((){
      mockDataConnectionChecker = MockDataConnectionChecker();
      networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
    });

    group('isConnected', () {
      test('testing has connect', () async {
        when(mockDataConnectionChecker.hasConnection).thenAnswer((_) async => true);

        final result = await networkInfoImpl.isConnected;
        verify(mockDataConnectionChecker.hasConnection);
        expect(result, true);
      });
    });
}
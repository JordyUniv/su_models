
import 'package:exampleone/core/error/failures.dart';
import 'package:exampleone/core/utilities/convert.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';

void main() {
  Convert convert;

  setUp((){
    convert = Convert();
  });

  test('convert to int succesful', (){
    final intValue = convert.stringToInt("123");
    expect(intValue, Right(123));
  });

  test('convert failure', (){
    final failConvertion = convert.stringToInt("asdf2");
    expect(failConvertion, Left(InvalidInputFailure()));
  });
}
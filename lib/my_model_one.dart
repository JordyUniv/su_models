import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class MyModelOne extends Equatable {
  final String text;
  final int number;

  MyModelOne({
    @required this.text,
    @required this.number,
  }): super([text, number]);
}
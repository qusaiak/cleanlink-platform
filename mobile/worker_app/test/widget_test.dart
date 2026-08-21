import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worker_app/app.dart';

void main() {
  test('Worker app root can be constructed', () {
    expect(const MyApp(), isA<Widget>());
  });
}

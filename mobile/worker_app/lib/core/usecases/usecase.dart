import 'package:equatable/equatable.dart';

abstract class UseCase<Type, Params> {
  // Made the named [params] nullable so use cases that take [NoParams] can be
  // invoked as `call()` while parameterized ones pass `call(params: ...)`.
  Future<Type> call({Params? params});
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}

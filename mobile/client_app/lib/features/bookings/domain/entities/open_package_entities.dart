import 'package:equatable/equatable.dart';

class SelectedOpenPackageAttribute extends Equatable {
  const SelectedOpenPackageAttribute({required this.id, required this.qty});

  final int id;
  final int qty;

  Map<String, dynamic> toJson() => {'id': id, 'qty': qty};

  @override
  List<Object?> get props => [id, qty];
}

class OpenPackageQuote extends Equatable {
  const OpenPackageQuote({required this.totalPrice, required this.duration});

  final double totalPrice;
  final int duration;

  @override
  List<Object?> get props => [totalPrice, duration];
}

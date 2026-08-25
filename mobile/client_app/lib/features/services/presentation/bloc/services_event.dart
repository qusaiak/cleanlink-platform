part of 'services_bloc.dart';

abstract class ServicesEvent extends Equatable {
  const ServicesEvent();

  @override
  List<Object?> get props => const [];
}

class GetServicesEvent extends ServicesEvent {
  const GetServicesEvent({this.refresh = false, this.completer});

  final bool refresh;
  final Completer<void>? completer;

  @override
  List<Object?> get props => [refresh];
}

class GetMoreServicesEvent extends ServicesEvent {
  const GetMoreServicesEvent({this.retry = false});

  final bool retry;

  @override
  List<Object?> get props => [retry];
}

class GetOffersEvent extends ServicesEvent {
  const GetOffersEvent({this.refresh = false, this.completer});

  final bool refresh;
  final Completer<void>? completer;

  @override
  List<Object?> get props => [refresh];
}

class GetMoreOffersEvent extends ServicesEvent {
  const GetMoreOffersEvent({this.retry = false});

  final bool retry;

  @override
  List<Object?> get props => [retry];
}

class GetServiceDetailsEvent extends ServicesEvent {
  final int id;

  const GetServiceDetailsEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class SelectPackageEvent extends ServicesEvent {
  final PackageEntity package;

  const SelectPackageEvent(this.package);

  @override
  List<Object?> get props => [package];
}

class UpdateServiceOpenPackageAttributeQty extends ServicesEvent {
  const UpdateServiceOpenPackageAttributeQty({
    required this.attributeId,
    required this.qty,
  });

  final int attributeId;
  final int qty;

  @override
  List<Object?> get props => [attributeId, qty];
}

class RefreshServiceDetailsEvent extends ServicesEvent {
  final int id;

  const RefreshServiceDetailsEvent(this.id);

  @override
  List<Object?> get props => [id];
}

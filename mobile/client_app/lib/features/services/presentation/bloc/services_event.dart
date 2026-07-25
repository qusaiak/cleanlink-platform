part of 'services_bloc.dart';

abstract class ServicesEvent {}

class GetServicesEvent extends ServicesEvent {}

class GetOffersEvent extends ServicesEvent {}

class GetServiceDetailsEvent extends ServicesEvent {
  final int id;

  GetServiceDetailsEvent(this.id);
}

class SelectPackageEvent extends ServicesEvent {
  final PackageEntity package;

  SelectPackageEvent(this.package);
}

class RefreshServiceDetailsEvent extends ServicesEvent {
  final int id;

  RefreshServiceDetailsEvent(this.id);
}

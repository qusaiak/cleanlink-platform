part of 'services_bloc.dart';

abstract class ServicesState {}

class ServicesInitial extends ServicesState {}

class ServicesLoading extends ServicesState {}

class ServicesLoaded extends ServicesState {
  final List<ServiceEntity> services;

  ServicesLoaded(this.services);
}

class ServicesError extends ServicesState {
  final String message;

  ServicesError(this.message);
}

class OffersLoading extends ServicesState {}

class OffersLoaded extends ServicesState {
  final List<ServiceEntity> offers;

  OffersLoaded(this.offers);
}

class OffersError extends ServicesState {
  final String message;

  OffersError(this.message);
}

class ServiceDetailsInitial extends ServicesState {}

class ServiceDetailsLoading extends ServicesState {}

class ServiceDetailsLoaded extends ServicesState {
  final ServiceEntity service;

  final PackageEntity? selectedPackage;

  ServiceDetailsLoaded({required this.service, this.selectedPackage});

  ServiceDetailsLoaded copyWith({
    ServiceEntity? service,
    PackageEntity? selectedPackage,
  }) {
    return ServiceDetailsLoaded(
      service: service ?? this.service,
      selectedPackage: selectedPackage ?? this.selectedPackage,
    );
  }
}

class ServiceDetailsError extends ServicesState {
  final String message;

  ServiceDetailsError(this.message);
}

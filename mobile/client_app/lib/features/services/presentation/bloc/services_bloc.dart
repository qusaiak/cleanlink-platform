import 'dart:async';

import '../../../../config/constants/pagination_constants.dart';
import '../../../../core/pagination/paginated_result.dart';
import '../../../../core/pagination/pagination_utils.dart';
import 'package:client_app/features/services/domain/usecases/get_service_details_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/package_entity.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/usecases/get_offers_usecase.dart';
import '../../domain/usecases/get_services_usecase.dart';

part 'services_event.dart';
part 'services_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  final GetServicesUseCase getServices;
  final GetOffersUseCase getOffers;
  final GetServiceDetailsUseCase serviceDetailsUseCase;

  ServicesBloc(this.getServices, this.getOffers, this.serviceDetailsUseCase)
    : super(ServicesInitial()) {
    on<GetServicesEvent>(_onGetServices);
    on<GetMoreServicesEvent>(_onGetMoreServices);
    on<GetOffersEvent>(_onGetOffers);
    on<GetMoreOffersEvent>(_onGetMoreOffers);
    on<GetServiceDetailsEvent>(_onGetServiceDetails);
    on<RefreshServiceDetailsEvent>(_onRefreshServiceDetails);
    on<SelectPackageEvent>(_onSelectPackage);
  }

  Future<void> _onGetServices(
    GetServicesEvent event,
    Emitter<ServicesState> emit,
  ) async {
    if (state is ServicesLoading ||
        (event.refresh &&
            state is ServicesLoaded &&
            (state as ServicesLoaded).isLoadingMore)) {
      _complete(event.completer);
      return;
    }
    try {
      emit(ServicesLoading(isRefreshing: event.refresh));

      final result = await getServices(
        page: 1,
        perPage: PaginationConstants.servicesPageSize,
      );

      emit(ServicesLoaded.fromResult(result));
    } catch (e) {
      emit(ServicesError(e.toString()));
    } finally {
      _complete(event.completer);
    }
  }

  Future<void> _onGetMoreServices(
    GetMoreServicesEvent event,
    Emitter<ServicesState> emit,
  ) async {
    final current = state;
    if (current is! ServicesLoaded ||
        !current.canLoadMore ||
        (current.loadMoreError != null && !event.retry)) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true, clearLoadMoreError: true));
    try {
      final result = await getServices(
        page: current.currentPage + 1,
        perPage: PaginationConstants.servicesPageSize,
      );
      emit(
        ServicesLoaded.fromResult(
          result,
          services: mergeWithoutDuplicates(
            current.services,
            result.items,
            (service) => service.id,
          ),
        ),
      );
    } catch (e) {
      emit(current.copyWith(isLoadingMore: false, loadMoreError: e.toString()));
    }
  }

  Future<void> _onGetOffers(
    GetOffersEvent event,
    Emitter<ServicesState> emit,
  ) async {
    if (state is OffersLoading ||
        (event.refresh &&
            state is OffersLoaded &&
            (state as OffersLoaded).isLoadingMore)) {
      _complete(event.completer);
      return;
    }
    try {
      emit(OffersLoading(isRefreshing: event.refresh));
      final result = await getOffers(
        page: 1,
        perPage: PaginationConstants.offersPageSize,
      );
      emit(OffersLoaded.fromResult(result));
    } catch (e) {
      emit(OffersError(e.toString()));
    } finally {
      _complete(event.completer);
    }
  }

  Future<void> _onGetMoreOffers(
    GetMoreOffersEvent event,
    Emitter<ServicesState> emit,
  ) async {
    final current = state;
    if (current is! OffersLoaded ||
        !current.canLoadMore ||
        (current.loadMoreError != null && !event.retry)) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true, clearLoadMoreError: true));
    try {
      final result = await getOffers(
        page: current.currentPage + 1,
        perPage: PaginationConstants.offersPageSize,
      );
      emit(
        OffersLoaded.fromResult(
          result,
          offers: mergeWithoutDuplicates(
            current.offers,
            result.items,
            (offer) => offer.id,
          ),
        ),
      );
    } catch (e) {
      emit(current.copyWith(isLoadingMore: false, loadMoreError: e.toString()));
    }
  }

  Future<void> _onGetServiceDetails(
    GetServiceDetailsEvent event,
    Emitter<ServicesState> emit,
  ) async {
    emit(ServiceDetailsLoading());

    try {
      final service = await serviceDetailsUseCase(event.id);

      emit(
        ServiceDetailsLoaded(
          service: service,
          selectedPackage: service.packages?.isNotEmpty == true
              ? service.packages!.first
              : null,
        ),
      );
    } catch (e) {
      emit(ServiceDetailsError(e.toString()));
    }
  }

  Future<void> _onRefreshServiceDetails(
    RefreshServiceDetailsEvent event,
    Emitter<ServicesState> emit,
  ) async {
    if (state is! ServiceDetailsLoaded) return;
    final current = state as ServiceDetailsLoaded;
    try {
      final service = await serviceDetailsUseCase(event.id);
      emit(current.copyWith(service: service));
    } catch (_) {
      // Preserve details and package selection when a background refresh fails.
    }
  }

  void _onSelectPackage(SelectPackageEvent event, Emitter<ServicesState> emit) {
    if (state is ServiceDetailsLoaded) {
      final current = state as ServiceDetailsLoaded;

      emit(current.copyWith(selectedPackage: event.package));
    }
  }

  static void _complete(Completer<void>? completer) {
    if (completer != null && !completer.isCompleted) completer.complete();
  }
}

import 'package:client_app/features/services/domain/usecases/get_service_details_use_case.dart';
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
    on<GetOffersEvent>(_onGetOffers);
    on<GetServiceDetailsEvent>(_onGetServiceDetails);
    on<RefreshServiceDetailsEvent>(_onRefreshServiceDetails);
    on<SelectPackageEvent>(_onSelectPackage);
  }

  Future<void> _onGetServices(
    GetServicesEvent event,
    Emitter<ServicesState> emit,
  ) async {
    try {
      emit(ServicesLoading());

      final result = await getServices();

      emit(ServicesLoaded(result));
    } catch (e) {
      emit(ServicesError(e.toString()));
    }
  }

  Future<void> _onGetOffers(
    GetOffersEvent event,
    Emitter<ServicesState> emit,
  ) async {
    try {
      emit(OffersLoading());

      final result = await getOffers();

      emit(OffersLoaded(result));
    } catch (e) {
      emit(OffersError(e.toString()));
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
}

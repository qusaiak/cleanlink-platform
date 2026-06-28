import 'package:bloc/bloc.dart';
import 'package:client_app/features/services/domain/usecases/get_service_details_use_case.dart';
import '../../domain/entities/package_entity.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/usecases/get_services_usecase.dart';

part 'services_event.dart';
part 'services_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  final GetServicesUseCase getServices;
  final GetServiceDetailsUseCase serviceDetailsUseCase;

  ServicesBloc(this.getServices, this.serviceDetailsUseCase)
    : super(ServicesInitial()) {
    on<GetServicesEvent>(_onGetServices);
    on<GetServiceDetailsEvent>(_onGetServiceDetails);
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

  void _onSelectPackage(SelectPackageEvent event, Emitter<ServicesState> emit) {
    if (state is ServiceDetailsLoaded) {
      final current = state as ServiceDetailsLoaded;

      emit(current.copyWith(selectedPackage: event.package));
    }
  }
}

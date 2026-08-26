import 'package:client_app/features/bookings/domain/repositories/bookings_repo.dart';
import 'package:client_app/features/bookings/domain/entities/open_package_entities.dart';
import 'package:client_app/features/bookings/domain/usecases/book_order_usecase.dart';
import 'package:client_app/features/bookings/domain/usecases/cancel_order_usecase.dart';
import 'package:client_app/features/bookings/domain/usecases/get_available_slots_usecase.dart';
import 'package:client_app/features/bookings/domain/usecases/get_bookings_usecase.dart';
import 'package:client_app/features/bookings/domain/usecases/show_order_usecase.dart';
import 'package:client_app/features/bookings/presentation/bloc/bookings_bloc.dart';
import 'package:client_app/features/bookings/presentation/pages/booking_details_page.dart';
import 'package:client_app/features/services/domain/entities/attribute_entity.dart';
import 'package:client_app/features/services/domain/entities/package_entity.dart';
import 'package:client_app/features/services/domain/entities/service_entity.dart';
import 'package:client_app/features/services/domain/repositories/services_repo.dart';
import 'package:client_app/features/services/domain/usecases/get_offers_usecase.dart';
import 'package:client_app/features/services/domain/usecases/get_service_details_use_case.dart';
import 'package:client_app/features/services/domain/usecases/get_services_usecase.dart';
import 'package:client_app/features/services/presentation/bloc/services_bloc.dart';
import 'package:client_app/features/services/presentation/widgets/service_packages_section.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('service details displays customizable Open Package attributes', (
    tester,
  ) async {
    final repo = _ServiceDetailsRepo();
    final bloc = ServicesBloc(
      GetServicesUseCase(repo),
      GetOffersUseCase(repo),
      GetServiceDetailsUseCase(repo),
    )..add(const GetServiceDetailsEvent(4));
    addTearDown(bloc.close);
    await bloc.stream.firstWhere((state) => state is ServiceDetailsLoaded);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (_, _) => MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: BlocProvider.value(
              value: bloc,
              child: ServicePackagesSection(packages: [_package]),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('service-open-number-1')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('service-open-boolean-22')),
      findsOneWidget,
    );

    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pump();
    expect(
      (bloc.state as ServiceDetailsLoaded).openPackageAttributeQuantities[1],
      1,
    );
  });

  test('service selections are preserved when booking is configured', () async {
    final repo = _NoopBookingsRepo();
    final bloc = BookingsBloc(
      GetAvailableSlotsUseCase(repo),
      GetOrdersUseCase(repo),
      BookOrderUseCase(repo),
      ShowOrderUseCase(repo),
      CancelOrderUseCase(repo),
    );
    addTearDown(bloc.close);

    bloc.add(
      ConfigureBookingPackage(
        package: _package,
        attributes: [_numberAttribute, _booleanAttribute],
        initialAttributeQuantities: const {1: 3, 22: 1},
      ),
    );
    await bloc.stream.firstWhere(
      (state) => state.openPackageAttributeQuantities.length == 2,
    );

    expect(bloc.state.openPackageAttributeQuantities, const {1: 3, 22: 1});
    expect(bloc.state.openPackageAttributesPayload, const [
      SelectedOpenPackageAttribute(id: 1, qty: 3),
      SelectedOpenPackageAttribute(id: 22, qty: 1),
    ]);
  });

  testWidgets('boolean uses a checkbox while number uses stepper buttons', (
    tester,
  ) async {
    final repo = _NoopBookingsRepo();
    final bloc = BookingsBloc(
      GetAvailableSlotsUseCase(repo),
      GetOrdersUseCase(repo),
      BookOrderUseCase(repo),
      ShowOrderUseCase(repo),
      CancelOrderUseCase(repo),
    );
    addTearDown(bloc.close);

    bloc.add(
      ConfigureBookingPackage(
        package: _package,
        attributes: [_numberAttribute, _booleanAttribute],
      ),
    );
    await bloc.stream.firstWhere(
      (state) => state.openPackageAttributeQuantities.length == 2,
    );

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (_, _) => MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: BlocProvider.value(
              value: bloc,
              child: BlocBuilder<BookingsBloc, BookingsState>(
                builder: (_, state) => OpenPackageCustomizer(
                  attributes: state.serviceAttributes,
                  quantities: state.openPackageAttributeQuantities,
                  quote: state.openPackageQuote,
                  isCalculating: state.isCheckingOpenPackagePrice,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Checkbox), findsOneWidget);
    expect(find.byKey(const ValueKey('open-package-number-1')), findsOneWidget);
    expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('open-package-boolean-22')));
    await tester.pump();
    expect(bloc.state.openPackageAttributeQuantities[22], 1);
    expect(bloc.state.openPackageAttributesPayload, const [
      SelectedOpenPackageAttribute(id: 1, qty: 0),
      SelectedOpenPackageAttribute(id: 22, qty: 1),
    ]);

    await tester.tap(find.byKey(const ValueKey('open-package-boolean-22')));
    await tester.pump();
    expect(bloc.state.openPackageAttributeQuantities[22], 0);
    expect(bloc.state.openPackageAttributesPayload, const [
      SelectedOpenPackageAttribute(id: 1, qty: 0),
      SelectedOpenPackageAttribute(id: 22, qty: 0),
    ]);

    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pump();
    expect(bloc.state.openPackageAttributeQuantities[1], 1);
  });
}

class _NoopBookingsRepo implements BookingsRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _ServiceDetailsRepo implements ServicesRepo {
  @override
  Future<ServiceEntity> getServiceDetails(int id) async => ServiceEntity(
    id: id,
    companyId: 1,
    categoryId: 1,
    name: 'Cleaning',
    description: '',
    rating: 0,
    minDuration: 60,
    maxDuration: 60,
    minPrice: 10,
    maxPrice: 10,
    image: '',
    discount: 0,
    isFavorite: false,
    createdAt: _date,
    updatedAt: _date,
    packages: [_package],
    attributes: [_numberAttribute, _booleanAttribute],
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final _date = DateTime(2026, 8, 14);

final _package = PackageEntity(
  id: 3,
  serviceId: 4,
  name: 'Open Package',
  duration: 60,
  price: 10,
  priceAfterDiscount: 10,
  details: const [],
  minimumWorkers: 1,
  isOpenPackage: true,
  createdAt: _date,
  updatedAt: _date,
);

final _numberAttribute = AttributeEntity(
  id: 1,
  name: 'Extra rooms',
  type: 'number',
  createdAt: _date,
  updatedAt: _date,
  price: 25,
  duration: 45,
);

final _booleanAttribute = AttributeEntity(
  id: 22,
  name: 'Is the home empty?',
  type: 'boolean',
  createdAt: _date,
  updatedAt: _date,
  price: -20,
  duration: -30,
);

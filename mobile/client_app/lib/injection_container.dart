import 'package:client_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:client_app/features/base/presentation/bloc/base_bloc.dart';
import 'package:client_app/features/bookings/domain/usecases/get_available_slots_usecase.dart';
import 'package:client_app/features/bookings/domain/usecases/open_package_usecases.dart';
import 'package:client_app/features/categories/data/data_sources/categories_api_service.dart';
import 'package:client_app/features/categories/data/repositories/categories_repo_impl.dart';
import 'package:client_app/features/categories/domain/repositories/categories_repo.dart';
import 'package:client_app/features/categories/domain/usecases/get_categoris_usecase.dart';
import 'package:client_app/features/categories/domain/usecases/get_category_usecase.dart';
import 'package:client_app/features/categories/presentation/bloc/categories_bloc.dart';
import 'package:client_app/features/favorites/data/data_sources/favorites_api_service.dart';
import 'package:client_app/features/favorites/data/repositories/favorites_repo_impl.dart';
import 'package:client_app/features/favorites/domain/repositories/favorites_repo.dart';
import 'package:client_app/features/favorites/domain/usecases/get_favorites_usecase.dart';
import 'package:client_app/features/favorites/domain/usecases/toggle_favorite_usecase.dart';
import 'package:client_app/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:client_app/features/complaints/data/data_sources/complaints_api_service.dart';
import 'package:client_app/features/complaints/data/repositories/complaints_repository_impl.dart';
import 'package:client_app/features/complaints/domain/repositories/complaints_repository.dart';
import 'package:client_app/features/complaints/domain/usecases/complaints_usecases.dart';
import 'package:client_app/features/complaints/presentation/bloc/complaints_bloc.dart';
import 'package:client_app/features/regions/data/data_sources/regions_api_service.dart';
import 'package:client_app/features/regions/data/repositories/regions_repo_impl.dart';
import 'package:client_app/features/regions/domain/repositories/regions_repo.dart';
import 'package:client_app/features/regions/domain/usecases/get_region_usecase.dart';
import 'package:client_app/features/regions/domain/usecases/get_regions_usecase.dart';
import 'package:client_app/features/regions/presentation/bloc/regions_bloc.dart';
import 'package:client_app/features/companies/data/data_sources/companies_api_service.dart';
import 'package:client_app/features/companies/data/repositories/companies_repo_impl.dart';
import 'package:client_app/features/companies/domain/usecases/get_companies_usecase.dart';
import 'package:client_app/features/companies/domain/usecases/get_company_details_use_case.dart';
import 'package:client_app/features/home/data/data_sources/home_api_service.dart';
import 'package:client_app/features/home/data/repositories/home_repo_impl.dart';
import 'package:client_app/features/home/domain/repositories/home_repo.dart';
import 'package:client_app/features/home/domain/usecases/home_usecase.dart';
import 'package:client_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:client_app/features/notification/data/data_sources/fcm_service.dart';
import 'package:client_app/features/notification/data/repositories/notification_repo_impl.dart';
import 'package:client_app/features/notification/domain/repositories/notification_repo.dart';
import 'package:client_app/features/notification/domain/usecases/get_notifications_usecase.dart';
import 'package:client_app/features/notification/domain/usecases/get_unread_notifications_count_usecase.dart';
import 'package:client_app/features/notification/domain/usecases/mark_notification_as_read_usecase.dart';
import 'package:client_app/features/notification/domain/usecases/update_fcm_token_usecase.dart';
import 'package:client_app/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:client_app/features/profile/data/data_sources/remote/profile_api_service.dart';
import 'package:client_app/features/profile/data/repository/profile_repo_impl.dart';
import 'package:client_app/features/profile/domain/repository/profile_repo.dart';
import 'package:client_app/features/profile/domain/usecases/profile_usecase.dart';
import 'package:client_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:client_app/features/search/data/data_sources/search_api_service.dart';
import 'package:client_app/features/search/data/repositories/search_repo_impl.dart';
import 'package:client_app/features/search/domain/repositories/search_repo.dart';
import 'package:client_app/features/search/domain/usecases/search_usecase.dart';
import 'package:client_app/features/search/presentation/bloc/search_bloc.dart';
import 'package:client_app/features/services/data/data_sources/services_api_service.dart';
import 'package:client_app/features/services/data/repositories/services_repo_impl.dart';
import 'package:client_app/features/services/domain/repositories/services_repo.dart';
import 'package:client_app/features/services/domain/usecases/get_service_details_use_case.dart';
import 'package:client_app/features/services/domain/usecases/get_services_usecase.dart';
import 'package:client_app/features/services/presentation/bloc/services_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'core/network/dio_factory.dart';
import 'core/payment/stripe_payment_service.dart';
import 'core/session/user_session.dart';
import 'firebase_api.dart';
import 'features/auth/data/data_sources/auth_api_service.dart';
import 'features/auth/data/repositories/auth_repo_impl.dart';
import 'features/auth/domain/repositories/auth_repo.dart';
import 'features/auth/domain/usecases/change_password_usecase.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/domain/usecases/resend_otp_usecase.dart';
import 'features/auth/domain/usecases/update_profile_usecase.dart';
import 'features/auth/domain/usecases/verify_otp_usecase.dart';
import 'features/auth/presentation/bloc/personal_details_bloc.dart';
import 'features/bookings/data/data_sources/bookings_api_service.dart';
import 'features/bookings/data/repositories/bookings_repo_impl.dart';
import 'features/bookings/domain/repositories/bookings_repo.dart';
import 'features/bookings/domain/usecases/get_bookings_usecase.dart';
import 'features/bookings/domain/usecases/book_order_usecase.dart';
import 'features/bookings/domain/usecases/cancel_order_usecase.dart';
import 'features/bookings/domain/usecases/show_order_usecase.dart';
import 'features/bookings/presentation/bloc/bookings_bloc.dart';
import 'features/payments/data/data_sources/payments_api_service.dart';
import 'features/payments/data/data_sources/client_payments_api_service.dart';
import 'features/payments/data/repositories/payments_repository_impl.dart';
import 'features/payments/domain/repositories/payments_repository.dart';
import 'features/payments/domain/usecases/create_payment_intent_usecase.dart';
import 'features/payments/presentation/bloc/payments_bloc.dart';
import 'features/payments/domain/usecases/client_payment_usecases.dart';
import 'features/payments/presentation/bloc/payment_history_bloc.dart';
import 'features/locations/domain/services/device_location_service.dart';
import 'features/locations/domain/services/reverse_geocoding_service.dart';
import 'features/locations/data/data_sources/locations_api_service.dart';
import 'features/locations/data/data_sources/locations_local_data_source.dart';
import 'features/locations/data/repositories/locations_repository_impl.dart';
import 'features/locations/domain/repositories/locations_repository.dart';
import 'features/locations/domain/usecases/locations_usecases.dart';
import 'features/locations/presentation/bloc/locations_bloc.dart';
import 'features/companies/domain/repositories/companies_repo.dart';
import 'features/companies/presentation/bloc/companies_bloc.dart';
import 'features/regions/domain/usecases/get_region_names_usecase.dart';
import 'features/reviews/data/data_sources/reviews_api_service.dart';
import 'features/reviews/data/repositories/reviews_repo_impl.dart';
import 'features/reviews/domain/repositories/reviews_repo.dart';
import 'features/reviews/domain/usecases/add_review_use_case.dart';
import 'features/reviews/domain/usecases/get_my_reviews_use_case.dart';
import 'features/reviews/presentation/bloc/review_bloc.dart';
import 'features/reviews/presentation/bloc/my_reviews_bloc.dart';
import 'features/services/domain/usecases/get_offers_usecase.dart';
import 'features/chat/data/data_sources/chat_api_service.dart';
import 'features/chat/data/data_sources/chat_remote_data_source.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/domain/repositories/chat_repository.dart';
import 'features/chat/domain/usecases/chat_usecases.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';
import 'features/chat/presentation/bloc/chat_conversations_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // EXTERNAL
  sl.registerLazySingleton<Dio>(() => DioFactory.createDio());
  sl.registerLazySingleton(() => InternetConnectionChecker.instance);
  sl.registerLazySingleton(() => ImagePicker());
  sl.registerLazySingleton(() => const StripePaymentService());
  sl.registerLazySingleton<DeviceLocationService>(
    () => const GeolocatorDeviceLocationService(),
  );
  sl.registerLazySingleton<ReverseGeocodingService>(
    () => const DeviceReverseGeocodingService(),
  );

  // Session
  sl.registerLazySingleton<UserSession>(() => UserSession());
  sl.registerLazySingleton<FirebaseApi>(() => FirebaseApi());

  // Services
  sl.registerLazySingleton<AuthApiService>(() => AuthApiService(sl()));
  sl.registerLazySingleton<HomeApiService>(() => HomeApiService(sl()));
  sl.registerLazySingleton<CompaniesApiService>(
    () => CompaniesApiService(sl()),
  );
  sl.registerLazySingleton<CategoriesApiService>(
    () => CategoriesApiService(sl()),
  );
  sl.registerLazySingleton<RegionsApiService>(() => RegionsApiService(sl()));
  sl.registerLazySingleton<FavoritesApiService>(
    () => FavoritesApiService(sl()),
  );
  sl.registerLazySingleton<ComplaintsApiService>(
    () => ComplaintsApiService(sl()),
  );
  sl.registerLazySingleton<SearchApiService>(() => SearchApiService(sl()));
  sl.registerLazySingleton<ServicesApiService>(() => ServicesApiService(sl()));
  sl.registerLazySingleton<ReviewsApiService>(() => ReviewsApiService(sl()));
  sl.registerLazySingleton<BookingsApiService>(() => BookingsApiService(sl()));
  sl.registerLazySingleton<PaymentsApiService>(() => PaymentsApiService(sl()));
  sl.registerLazySingleton<ClientPaymentsApiService>(
    () => ClientPaymentsApiService(sl()),
  );
  sl.registerLazySingleton<NotificationsApiService>(
    () => NotificationsApiService(sl()),
  );
  sl.registerLazySingleton<ProfileApiService>(() => ProfileApiService(sl()));
  sl.registerLazySingleton<LocationsApiService>(
    () => LocationsApiService(sl()),
  );
  sl.registerLazySingleton<ChatApiService>(() => ChatApiService(sl()));
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<LocationsLocalDataSource>(
    () => const SharedStorageLocationsLocalDataSource(),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl(), sl()));
  sl.registerLazySingleton<HomeRepo>(() => HomeRepoImpl(sl()));
  sl.registerLazySingleton<CompaniesRepo>(() => CompaniesRepoImpl(sl()));
  sl.registerLazySingleton<CategoriesRepo>(() => CategoriesRepoImpl(sl()));
  sl.registerLazySingleton<RegionsRepo>(() => RegionsRepoImpl(sl()));
  sl.registerLazySingleton<FavoritesRepo>(() => FavoritesRepoImpl(sl()));
  sl.registerLazySingleton<ComplaintsRepository>(
    () => ComplaintsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<SearchRepo>(() => SearchRepoImpl(sl()));
  sl.registerLazySingleton<ServicesRepo>(() => ServicesRepoImpl(sl()));
  sl.registerLazySingleton<ReviewsRepo>(() => ReviewsRepoImpl(sl()));
  sl.registerLazySingleton<BookingsRepo>(() => BookingsRepoImpl(sl()));
  sl.registerLazySingleton<PaymentsRepository>(
    () => PaymentsRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<LocationsRepository>(
    () => LocationsRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(sl()));

  // UseCases
  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));
  sl.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(sl()));
  sl.registerLazySingleton<VerifyOtpUseCase>(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton<ResendOtpUseCase>(() => ResendOtpUseCase(sl()));
  sl.registerLazySingleton<ChangePasswordUseCase>(
    () => ChangePasswordUseCase(sl()),
  );
  sl.registerLazySingleton<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(sl()),
  );
  sl.registerLazySingleton<GetHomeUseCase>(() => GetHomeUseCase(sl()));
  sl.registerLazySingleton<GetCompaniesUseCase>(
    () => GetCompaniesUseCase(sl()),
  );
  sl.registerLazySingleton<GetCompanyDetailsUseCase>(
    () => GetCompanyDetailsUseCase(sl()),
  );
  sl.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(sl()),
  );
  sl.registerLazySingleton<GetCategoryUseCase>(() => GetCategoryUseCase(sl()));
  sl.registerLazySingleton<GetRegionsUseCase>(() => GetRegionsUseCase(sl()));
  sl.registerLazySingleton<GetRegionUseCase>(() => GetRegionUseCase(sl()));
  sl.registerLazySingleton<GetRegionNamesUseCase>(
    () => GetRegionNamesUseCase(sl()),
  );
  sl.registerLazySingleton<GetServicesUseCase>(() => GetServicesUseCase(sl()));
  sl.registerLazySingleton<GetOffersUseCase>(() => GetOffersUseCase(sl()));
  sl.registerLazySingleton<GetServiceDetailsUseCase>(
    () => GetServiceDetailsUseCase(sl()),
  );
  sl.registerLazySingleton<AddReviewUseCase>(() => AddReviewUseCase(sl()));
  sl.registerLazySingleton<GetMyReviewsUseCase>(
    () => GetMyReviewsUseCase(sl()),
  );
  sl.registerLazySingleton<ToggleFavoriteUseCase>(
    () => ToggleFavoriteUseCase(sl()),
  );
  sl.registerLazySingleton<GetFavoritesUseCase>(
    () => GetFavoritesUseCase(sl()),
  );
  sl.registerLazySingleton<GetComplaintsUseCase>(
    () => GetComplaintsUseCase(sl()),
  );
  sl.registerLazySingleton<GetComplaintDetailsUseCase>(
    () => GetComplaintDetailsUseCase(sl()),
  );
  sl.registerLazySingleton<CreateComplaintUseCase>(
    () => CreateComplaintUseCase(sl()),
  );
  sl.registerLazySingleton<GetComplaintUnreadCountUseCase>(
    () => GetComplaintUnreadCountUseCase(sl()),
  );
  sl.registerLazySingleton<MarkComplaintAsReadUseCase>(
    () => MarkComplaintAsReadUseCase(sl()),
  );
  sl.registerLazySingleton<SearchUseCase>(() => SearchUseCase(sl()));
  sl.registerLazySingleton<GetAvailableSlotsUseCase>(
    () => GetAvailableSlotsUseCase(sl()),
  );
  sl.registerLazySingleton<CheckOpenPackagePriceUseCase>(
    () => CheckOpenPackagePriceUseCase(sl()),
  );
  sl.registerLazySingleton<GetOpenPackageAvailableSlotsUseCase>(
    () => GetOpenPackageAvailableSlotsUseCase(sl()),
  );
  sl.registerLazySingleton<GetOrdersUseCase>(() => GetOrdersUseCase(sl()));
  sl.registerLazySingleton<BookOrderUseCase>(() => BookOrderUseCase(sl()));
  sl.registerLazySingleton<CreatePaymentIntentUseCase>(
    () => CreatePaymentIntentUseCase(sl()),
  );
  sl.registerLazySingleton<GetClientPaymentsUseCase>(
    () => GetClientPaymentsUseCase(sl()),
  );
  sl.registerLazySingleton<GetClientPaymentUseCase>(
    () => GetClientPaymentUseCase(sl()),
  );
  sl.registerLazySingleton<ShowOrderUseCase>(() => ShowOrderUseCase(sl()));
  sl.registerLazySingleton<CancelOrderUseCase>(() => CancelOrderUseCase(sl()));
  sl.registerLazySingleton<UpdateFcmTokenUseCase>(
    () => UpdateFcmTokenUseCase(sl()),
  );
  sl.registerLazySingleton<GetNotificationsUseCase>(
    () => GetNotificationsUseCase(sl()),
  );
  sl.registerLazySingleton<GetUnreadNotificationsCountUseCase>(
    () => GetUnreadNotificationsCountUseCase(sl()),
  );
  sl.registerLazySingleton<MarkNotificationAsReadUseCase>(
    () => MarkNotificationAsReadUseCase(sl()),
  );
  sl.registerLazySingleton<UpdateClientProfileUseCase>(
    () => UpdateClientProfileUseCase(sl()),
  );
  sl.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(sl()));
  sl.registerLazySingleton<GetDashboardSummaryUseCase>(
    () => GetDashboardSummaryUseCase(sl()),
  );
  sl.registerLazySingleton<DeleteAccountUseCase>(
    () => DeleteAccountUseCase(sl()),
  );
  sl.registerLazySingleton<GetCachedLocationsUseCase>(
    () => GetCachedLocationsUseCase(sl()),
  );
  sl.registerLazySingleton<RefreshLocationsUseCase>(
    () => RefreshLocationsUseCase(sl()),
  );
  sl.registerLazySingleton<AddLocationUseCase>(() => AddLocationUseCase(sl()));
  sl.registerLazySingleton<UpdateLocationUseCase>(
    () => UpdateLocationUseCase(sl()),
  );
  sl.registerLazySingleton<DeleteLocationUseCase>(
    () => DeleteLocationUseCase(sl()),
  );
  sl.registerLazySingleton<GetChatConversationsUseCase>(
    () => GetChatConversationsUseCase(sl()),
  );
  sl.registerLazySingleton<GetChatConversationUseCase>(
    () => GetChatConversationUseCase(sl()),
  );
  sl.registerLazySingleton<SendChatMessageUseCase>(
    () => SendChatMessageUseCase(sl()),
  );
  sl.registerLazySingleton<DeleteChatConversationUseCase>(
    () => DeleteChatConversationUseCase(sl()),
  );

  // Blocs
  sl.registerFactory(() => BaseBloc());
  sl.registerFactory(() => AuthBloc(sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory(
    () => ProfileBloc(sl(), sl(), sl(), sl(), sl(), sl(), sl()),
  );
  sl.registerFactory(() => HomeBloc(sl()));
  sl.registerFactory(() => CompaniesBloc(sl(), sl()));
  sl.registerFactory(() => CategoriesBloc(sl(), sl()));
  sl.registerFactory(() => RegionsBloc(sl(), sl(), sl()));
  sl.registerFactory(() => ServicesBloc(sl(), sl(), sl()));
  sl.registerFactory(() => ReviewBloc(sl()));
  sl.registerFactory(() => MyReviewsBloc(sl()));
  sl.registerFactory(() => PersonalDetailsBloc(sl(), sl(), sl()));
  sl.registerFactory(() => FavoritesBloc(sl(), sl()));
  sl.registerFactory(() => SearchBloc(sl()));
  sl.registerLazySingleton(() => NotificationsBloc(sl(), sl(), sl(), sl()));
  sl.registerLazySingleton(() => ComplaintsBloc(sl(), sl(), sl(), sl(), sl()));
  sl.registerLazySingleton(() => LocationsBloc(sl(), sl(), sl(), sl(), sl()));

  sl.registerFactory(
    () => BookingsBloc(sl(), sl(), sl(), sl(), sl(), sl(), sl()),
  );
  sl.registerFactory(() => PaymentsBloc(sl(), sl(), sl()));
  sl.registerFactory(() => PaymentHistoryBloc(sl(), sl()));
  sl.registerFactory(() => ChatBloc(sl(), sl(), sl()));
  sl.registerFactory(() => ChatConversationsBloc(sl(), sl()));
}

part of 'profile_bloc.dart';

enum ProfileStatus {
  initial,
  changeTheme,
  changeLanguage,
  loadingProfile,
  profileLoaded,
  pickingImage,
  imagePicked,
  updatingProfile,
  updateSuccess,
  loggingOut,
  logoutSuccess,
  validationError,
  failure,
}

class ProfileState extends Equatable {
  final ProfileStatus status;
  final bool isLight;
  final String languageCode;
  final String fullname;
  final String email;
  final String phone;
  final String address;
  final SelectedMapLocation? selectedMapLocation;
  final String image;
  final File? imageFile;
  final UserEntity? user;
  final String? errorMessage;
  final String? successMessage;
  final DashboardSummaryEntity? dashboardSummary;
  final bool isLoadingDashboardSummary;
  final bool isRefreshingProfile;
  final String? dashboardSummaryError;
  final bool isDeletingAccount;
  final String? deleteAccountError;
  final String? deleteAccountSuccessMessage;
  final bool notificationsEnabled;
  final bool isUpdatingNotificationPreference;
  final NotificationPermissionStatus? notificationPermissionStatus;
  final String? notificationMessage;
  final int notificationUpdateRevision;

  bool get isLoadingProfile => status == ProfileStatus.loadingProfile;
  bool get isUpdatingProfile => status == ProfileStatus.updatingProfile;
  bool get isLoggingOut => status == ProfileStatus.loggingOut;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.isLight = true,
    this.languageCode = "en",
    this.fullname = '',
    this.email = '',
    this.phone = '',
    this.address = '',
    this.selectedMapLocation,
    this.image = '',
    this.imageFile,
    this.user,
    this.errorMessage,
    this.successMessage,
    this.dashboardSummary,
    this.isLoadingDashboardSummary = false,
    this.isRefreshingProfile = false,
    this.dashboardSummaryError,
    this.isDeletingAccount = false,
    this.deleteAccountError,
    this.deleteAccountSuccessMessage,
    this.notificationsEnabled = true,
    this.isUpdatingNotificationPreference = false,
    this.notificationPermissionStatus,
    this.notificationMessage,
    this.notificationUpdateRevision = 0,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    bool? isLight,
    String? languageCode,
    String? fullname,
    String? email,
    String? phone,
    String? address,
    SelectedMapLocation? selectedMapLocation,
    String? image,
    File? imageFile,
    bool clearImageFile = false,
    UserEntity? user,
    String? errorMessage,
    String? successMessage,
    DashboardSummaryEntity? dashboardSummary,
    bool? isLoadingDashboardSummary,
    bool? isRefreshingProfile,
    String? dashboardSummaryError,
    bool clearDashboardError = false,
    bool? isDeletingAccount,
    String? deleteAccountError,
    bool clearDeleteAccountError = false,
    String? deleteAccountSuccessMessage,
    bool clearDeleteAccountSuccessMessage = false,
    bool? notificationsEnabled,
    bool? isUpdatingNotificationPreference,
    NotificationPermissionStatus? notificationPermissionStatus,
    String? notificationMessage,
    bool clearNotificationMessage = false,
    int? notificationUpdateRevision,
  }) {
    return ProfileState(
      status: status ?? this.status,
      isLight: isLight ?? this.isLight,
      languageCode: languageCode ?? this.languageCode,
      fullname: fullname ?? this.fullname,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      selectedMapLocation: selectedMapLocation ?? this.selectedMapLocation,
      image: image ?? this.image,
      imageFile: clearImageFile ? null : imageFile ?? this.imageFile,
      user: user ?? this.user,
      errorMessage: errorMessage,
      successMessage: successMessage,
      dashboardSummary: dashboardSummary ?? this.dashboardSummary,
      isLoadingDashboardSummary:
          isLoadingDashboardSummary ?? this.isLoadingDashboardSummary,
      isRefreshingProfile: isRefreshingProfile ?? this.isRefreshingProfile,
      dashboardSummaryError: clearDashboardError
          ? null
          : dashboardSummaryError ?? this.dashboardSummaryError,
      isDeletingAccount: isDeletingAccount ?? this.isDeletingAccount,
      deleteAccountError: clearDeleteAccountError
          ? null
          : deleteAccountError ?? this.deleteAccountError,
      deleteAccountSuccessMessage: clearDeleteAccountSuccessMessage
          ? null
          : deleteAccountSuccessMessage ?? this.deleteAccountSuccessMessage,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      isUpdatingNotificationPreference:
          isUpdatingNotificationPreference ??
          this.isUpdatingNotificationPreference,
      notificationPermissionStatus:
          notificationPermissionStatus ?? this.notificationPermissionStatus,
      notificationMessage: clearNotificationMessage
          ? null
          : notificationMessage ?? this.notificationMessage,
      notificationUpdateRevision:
          notificationUpdateRevision ?? this.notificationUpdateRevision,
    );
  }

  @override
  List<Object?> get props => [
    status,
    isLight,
    languageCode,
    fullname,
    email,
    phone,
    address,
    selectedMapLocation,
    image,
    imageFile?.path,
    user,
    errorMessage,
    successMessage,
    dashboardSummary,
    isLoadingDashboardSummary,
    isRefreshingProfile,
    dashboardSummaryError,
    isDeletingAccount,
    deleteAccountError,
    deleteAccountSuccessMessage,
    notificationsEnabled,
    isUpdatingNotificationPreference,
    notificationPermissionStatus,
    notificationMessage,
    notificationUpdateRevision,
  ];
}

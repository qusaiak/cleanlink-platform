class ApiEndpoints {
  static const String loginEndpoint = "auth/login";
  static const String registerEndpoint = "auth/register";
  static const String verifyOtpEndpoint = "auth/verify-otp";
  static const String resendOtpEndpoint = "auth/resend-otp";
  static const String changePasswordEndpoint = "auth/change-password";
  static const String profileEndpoint = "profile";
  static const String updateProfileEndpoint = "auth/update";
  static const String logoutEndpoint = "auth/logout";
  static const String homeEndpoint = "home-page";
  static const String companiesEndpoint = "companies";
  static const String categoriesEndpoint = "categories";
  static const String servicesEndpoint = "services";
  static const String offersEndpoint = "offers";
  static const String regionsEndpoint = "regions";
  static const String toggleFavoriteEndpoint = '/favorites/toggle';
  static const String favoritesEndpoint = '/favorites';
  static const String searchEndpoint = '/search';
  static const String regionNamesEndpoint = '/regions/names';
  static const String packageAvailableSlotsEndpoint =
      '/packages/{id}/available-slots';
  static const String openPackageCheckPriceEndpoint =
      '/packages/{id}/open-package/check-price';
  static const String openPackageAvailableSlotsEndpoint =
      '/packages/{id}/open-package/available-slots';
  static const String openPackageOrdersEndpoint = 'orders/open-package';
  static const String ordersEndpoint = 'orders';
  static const String showOrderEndpoint = 'orders/{orderId}';
  static const String cancelOrderEndpoint = 'orders/{orderId}/cancel';
  static const String createPaymentIntentEndpoint = 'payments/create-intent';
  static const String clientPaymentsEndpoint = 'client/payments';
  static const String clientPaymentDetailsEndpoint =
      'client/payments/{paymentId}';
  static const String updateFcmTokenEndpoint = 'auth/fcm-token';
  static const String notificationsEndpoint = 'notifications';
  static const String unreadNotificationsCountEndpoint =
      'notifications/unread-count';
  static const String reviewsEndpoint = '/reviews';
  static const String myReviewsEndpoint = 'my-reviews';
  static const String dashboardSummaryEndpoint = 'dashboard-summary';
  static const String deleteAccountEndpoint = 'auth/delete-account';
  static const String complaintsEndpoint = 'complaints';
  static const String complaintUnreadCountEndpoint = 'complaints/unread-count';
  static const String locationsEndpoint = 'locations';

  static String markNotificationAsReadEndpoint(int notificationId) =>
      'notifications/$notificationId/mark-as-read';
  static String complaintDetailsEndpoint(int complaintId) =>
      'complaints/$complaintId';
  static String markComplaintAsReadEndpoint(int complaintId) =>
      'complaints/$complaintId/mark-read';
}

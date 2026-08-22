import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// The current Language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language;

  /// A programmer greeting
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @help_text_1.
  ///
  /// In en, this message translates to:
  /// **'Choose your service and schedule a cleaning with just a few taps.'**
  String get help_text_1;

  /// No description provided for @help_text_2.
  ///
  /// In en, this message translates to:
  /// **'Our experienced cleaners deliver high-quality and reliable service.'**
  String get help_text_2;

  /// No description provided for @help_text_3.
  ///
  /// In en, this message translates to:
  /// **'Sit back and enjoy your spotless home while we handle the work.'**
  String get help_text_3;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @new_badge.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get new_badge;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @bookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookings;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @error_connection_timeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timed out. Please try again.'**
  String get error_connection_timeout;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @network_no_internet_title.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get network_no_internet_title;

  /// No description provided for @network_no_internet_description.
  ///
  /// In en, this message translates to:
  /// **'Please check your connection and try again.'**
  String get network_no_internet_description;

  /// No description provided for @network_timeout_title.
  ///
  /// In en, this message translates to:
  /// **'The request took too long'**
  String get network_timeout_title;

  /// No description provided for @network_timeout_description.
  ///
  /// In en, this message translates to:
  /// **'The server did not respond in time. Please try again.'**
  String get network_timeout_description;

  /// No description provided for @network_server_title.
  ///
  /// In en, this message translates to:
  /// **'The service is unavailable'**
  String get network_server_title;

  /// No description provided for @network_server_description.
  ///
  /// In en, this message translates to:
  /// **'The server could not complete your request. Please try again shortly.'**
  String get network_server_description;

  /// No description provided for @network_generic_title.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get network_generic_title;

  /// No description provided for @network_generic_description.
  ///
  /// In en, this message translates to:
  /// **'We could not load this content. Please try again.'**
  String get network_generic_description;

  /// No description provided for @logging_in.
  ///
  /// In en, this message translates to:
  /// **'Logging in...'**
  String get logging_in;

  /// No description provided for @successful_login_message.
  ///
  /// In en, this message translates to:
  /// **'Login Successfully'**
  String get successful_login_message;

  /// No description provided for @successful_registration_message.
  ///
  /// In en, this message translates to:
  /// **'Account Registered Successfully'**
  String get successful_registration_message;

  /// No description provided for @personal_details.
  ///
  /// In en, this message translates to:
  /// **'Personal Details'**
  String get personal_details;

  /// No description provided for @personal_details_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete your profile to start booking services'**
  String get personal_details_subtitle;

  /// No description provided for @complete_profile.
  ///
  /// In en, this message translates to:
  /// **'Complete Profile'**
  String get complete_profile;

  /// No description provided for @home_greeting.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String home_greeting(String name);

  /// No description provided for @do_not_have_an_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get do_not_have_an_account;

  /// No description provided for @invalid_mobile_number_error_message.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid mobile number'**
  String get invalid_mobile_number_error_message;

  /// No description provided for @empty_field_error_message.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get empty_field_error_message;

  /// No description provided for @short_password_error_message.
  ///
  /// In en, this message translates to:
  /// **'password must be at least 6 characters'**
  String get short_password_error_message;

  /// No description provided for @password_with_regex_error_message.
  ///
  /// In en, this message translates to:
  /// **'password must contain at least 1 letter and 1 number'**
  String get password_with_regex_error_message;

  /// No description provided for @password_confirmation_error_message.
  ///
  /// In en, this message translates to:
  /// **'Confirm password does not match password'**
  String get password_confirmation_error_message;

  /// No description provided for @verify_account_error_message.
  ///
  /// In en, this message translates to:
  /// **'please verify your account'**
  String get verify_account_error_message;

  /// No description provided for @verify_account_action.
  ///
  /// In en, this message translates to:
  /// **'Verify Account'**
  String get verify_account_action;

  /// No description provided for @did_not_receive_code.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive code? '**
  String get did_not_receive_code;

  /// No description provided for @resend_code.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resend_code;

  /// No description provided for @error_connection.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection'**
  String get error_connection;

  /// No description provided for @creating_account.
  ///
  /// In en, this message translates to:
  /// **'Creating account...'**
  String get creating_account;

  /// No description provided for @verify_account.
  ///
  /// In en, this message translates to:
  /// **'Account Verification'**
  String get verify_account;

  /// No description provided for @verifying.
  ///
  /// In en, this message translates to:
  /// **'Verifying...'**
  String get verifying;

  /// No description provided for @auth_login_title.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get auth_login_title;

  /// No description provided for @auth_login_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue managing your cleaning services'**
  String get auth_login_subtitle;

  /// No description provided for @auth_register_title.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get auth_register_title;

  /// No description provided for @auth_register_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Start your premium journey'**
  String get auth_register_subtitle;

  /// No description provided for @auth_phone_label.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get auth_phone_label;

  /// No description provided for @auth_phone_hint.
  ///
  /// In en, this message translates to:
  /// **'9xx xxx xxx'**
  String get auth_phone_hint;

  /// No description provided for @auth_password_label.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get auth_password_label;

  /// No description provided for @auth_password_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get auth_password_hint;

  /// No description provided for @auth_confirm_password_label.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get auth_confirm_password_label;

  /// No description provided for @auth_confirm_password_hint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get auth_confirm_password_hint;

  /// No description provided for @auth_old_password_label.
  ///
  /// In en, this message translates to:
  /// **'Old password'**
  String get auth_old_password_label;

  /// No description provided for @auth_new_password_label.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get auth_new_password_label;

  /// No description provided for @auth_forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get auth_forgot_password;

  /// No description provided for @auth_create_account.
  ///
  /// In en, this message translates to:
  /// **'Create new account'**
  String get auth_create_account;

  /// No description provided for @auth_have_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get auth_have_account;

  /// No description provided for @auth_sign_in.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get auth_sign_in;

  /// No description provided for @auth_sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get auth_sign_up;

  /// No description provided for @auth_login_button.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get auth_login_button;

  /// No description provided for @auth_register_button.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get auth_register_button;

  /// No description provided for @auth_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get auth_continue;

  /// No description provided for @validation_required.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get validation_required;

  /// No description provided for @validation_phone_invalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid syrian phone number'**
  String get validation_phone_invalid;

  /// No description provided for @validation_password_short.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get validation_password_short;

  /// No description provided for @validation_password_uppercase.
  ///
  /// In en, this message translates to:
  /// **'Must contain an uppercase letter'**
  String get validation_password_uppercase;

  /// No description provided for @validation_password_number.
  ///
  /// In en, this message translates to:
  /// **'Must contain a number'**
  String get validation_password_number;

  /// No description provided for @validation_passwords_no_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get validation_passwords_no_match;

  /// No description provided for @validation_must_accept_terms.
  ///
  /// In en, this message translates to:
  /// **'You must accept the terms'**
  String get validation_must_accept_terms;

  /// No description provided for @validation_age_18.
  ///
  /// In en, this message translates to:
  /// **'You must be at least 18 years old'**
  String get validation_age_18;

  /// No description provided for @validation_required_name.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get validation_required_name;

  /// No description provided for @auth_password_strength.
  ///
  /// In en, this message translates to:
  /// **'Password strength'**
  String get auth_password_strength;

  /// No description provided for @auth_password_weak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get auth_password_weak;

  /// No description provided for @auth_password_medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get auth_password_medium;

  /// No description provided for @auth_password_strong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get auth_password_strong;

  /// No description provided for @auth_forgot_title.
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get auth_forgot_title;

  /// No description provided for @auth_forgot_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number and we\'ll send you a verification code'**
  String get auth_forgot_subtitle;

  /// No description provided for @auth_send_reset_code.
  ///
  /// In en, this message translates to:
  /// **'Send reset code'**
  String get auth_send_reset_code;

  /// No description provided for @auth_back_to_login.
  ///
  /// In en, this message translates to:
  /// **'Back to login'**
  String get auth_back_to_login;

  /// No description provided for @auth_reset_title.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get auth_reset_title;

  /// No description provided for @auth_reset_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a new strong password for your account'**
  String get auth_reset_subtitle;

  /// No description provided for @auth_reset_button.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get auth_reset_button;

  /// No description provided for @auth_change_password_title.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get auth_change_password_title;

  /// No description provided for @auth_change_password_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your password to keep your account safe'**
  String get auth_change_password_subtitle;

  /// No description provided for @auth_update_password.
  ///
  /// In en, this message translates to:
  /// **'Update password'**
  String get auth_update_password;

  /// No description provided for @auth_full_name.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get auth_full_name;

  /// No description provided for @auth_full_name_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get auth_full_name_hint;

  /// No description provided for @auth_gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get auth_gender;

  /// No description provided for @auth_gender_male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get auth_gender_male;

  /// No description provided for @auth_gender_female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get auth_gender_female;

  /// No description provided for @auth_gender_other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get auth_gender_other;

  /// No description provided for @auth_gender_not_say.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get auth_gender_not_say;

  /// No description provided for @auth_birth_date.
  ///
  /// In en, this message translates to:
  /// **'Birth date'**
  String get auth_birth_date;

  /// No description provided for @auth_birth_date_hint.
  ///
  /// In en, this message translates to:
  /// **'Select your birth date'**
  String get auth_birth_date_hint;

  /// No description provided for @auth_otp_title.
  ///
  /// In en, this message translates to:
  /// **'Enter verification code'**
  String get auth_otp_title;

  /// No description provided for @auth_otp_subtitle.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit code to {email}'**
  String auth_otp_subtitle(String email);

  /// No description provided for @auth_otp_resend_in.
  ///
  /// In en, this message translates to:
  /// **'Resend code in {time}'**
  String auth_otp_resend_in(String time);

  /// No description provided for @auth_otp_resend.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get auth_otp_resend;

  /// No description provided for @auth_otp_verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get auth_otp_verify;

  /// No description provided for @auth_otp_incomplete.
  ///
  /// In en, this message translates to:
  /// **'Enter the complete 6-digit verification code'**
  String get auth_otp_incomplete;

  /// No description provided for @auth_otp_code_sent.
  ///
  /// In en, this message translates to:
  /// **'A new code was sent'**
  String get auth_otp_code_sent;

  /// No description provided for @auth_error_generic.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get auth_error_generic;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @session_expired_title.
  ///
  /// In en, this message translates to:
  /// **'Session expired'**
  String get session_expired_title;

  /// No description provided for @session_expired_message.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please log in again to continue.'**
  String get session_expired_message;

  /// No description provided for @no_data_found.
  ///
  /// In en, this message translates to:
  /// **'No data found'**
  String get no_data_found;

  /// No description provided for @try_again_later.
  ///
  /// In en, this message translates to:
  /// **'Please try again later.'**
  String get try_again_later;

  /// No description provided for @no_bookings.
  ///
  /// In en, this message translates to:
  /// **'No bookings yet'**
  String get no_bookings;

  /// No description provided for @no_bookings_message.
  ///
  /// In en, this message translates to:
  /// **'Your reservations will appear here'**
  String get no_bookings_message;

  /// No description provided for @no_categories_found.
  ///
  /// In en, this message translates to:
  /// **'No categories found'**
  String get no_categories_found;

  /// No description provided for @could_not_load_more_categories.
  ///
  /// In en, this message translates to:
  /// **'Could not load more categories'**
  String get could_not_load_more_categories;

  /// No description provided for @could_not_load_more_regions.
  ///
  /// In en, this message translates to:
  /// **'Could not load more regions'**
  String get could_not_load_more_regions;

  /// No description provided for @could_not_load_more_companies.
  ///
  /// In en, this message translates to:
  /// **'Could not load more companies'**
  String get could_not_load_more_companies;

  /// No description provided for @could_not_load_more_services.
  ///
  /// In en, this message translates to:
  /// **'Could not load more services'**
  String get could_not_load_more_services;

  /// No description provided for @could_not_load_more_notifications.
  ///
  /// In en, this message translates to:
  /// **'Could not load more notifications'**
  String get could_not_load_more_notifications;

  /// No description provided for @could_not_load_more_orders.
  ///
  /// In en, this message translates to:
  /// **'Could not load more orders'**
  String get could_not_load_more_orders;

  /// No description provided for @price_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Price unavailable'**
  String get price_unavailable;

  /// No description provided for @from_price.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from_price;

  /// No description provided for @up_to_price.
  ///
  /// In en, this message translates to:
  /// **'Up to'**
  String get up_to_price;

  /// No description provided for @no_offers_found.
  ///
  /// In en, this message translates to:
  /// **'No offers found'**
  String get no_offers_found;

  /// No description provided for @no_favorite_services.
  ///
  /// In en, this message translates to:
  /// **'No favorite services'**
  String get no_favorite_services;

  /// No description provided for @service_favorites_will_appear_here.
  ///
  /// In en, this message translates to:
  /// **'Your favorite services will appear here.'**
  String get service_favorites_will_appear_here;

  /// No description provided for @no_favorite_companies.
  ///
  /// In en, this message translates to:
  /// **'No favorite companies'**
  String get no_favorite_companies;

  /// No description provided for @company_favorites_will_appear_here.
  ///
  /// In en, this message translates to:
  /// **'Your favorite companies will appear here.'**
  String get company_favorites_will_appear_here;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @updates.
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get updates;

  /// No description provided for @check_for_update.
  ///
  /// In en, this message translates to:
  /// **'Check for Updates'**
  String get check_for_update;

  /// No description provided for @help_center_title.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get help_center_title;

  /// No description provided for @contact_us.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get contact_us;

  /// No description provided for @setting_title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get setting_title;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @dialog_change_language_title.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get dialog_change_language_title;

  /// No description provided for @dialog_change_language_body.
  ///
  /// In en, this message translates to:
  /// **'Are you sure about changing application language to Arabic?'**
  String get dialog_change_language_body;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_policy;

  /// No description provided for @terms_of_use.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get terms_of_use;

  /// No description provided for @delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get delete_account;

  /// No description provided for @suggestions.
  ///
  /// In en, this message translates to:
  /// **'Suggestions'**
  String get suggestions;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @notification_setting.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get notification_setting;

  /// No description provided for @notification_setting_description.
  ///
  /// In en, this message translates to:
  /// **'Receive updates about orders, complaints, offers, and account activity.'**
  String get notification_setting_description;

  /// No description provided for @notifications_enabled_message.
  ///
  /// In en, this message translates to:
  /// **'Push notifications are enabled.'**
  String get notifications_enabled_message;

  /// No description provided for @notifications_disabled_message.
  ///
  /// In en, this message translates to:
  /// **'Push notifications are disabled on this device.'**
  String get notifications_disabled_message;

  /// No description provided for @notification_permission_title.
  ///
  /// In en, this message translates to:
  /// **'Notification permission required'**
  String get notification_permission_title;

  /// No description provided for @notification_permission_disabled.
  ///
  /// In en, this message translates to:
  /// **'Notification permission is disabled. Enable it from the application settings to receive updates.'**
  String get notification_permission_disabled;

  /// No description provided for @notification_sync_failed.
  ///
  /// In en, this message translates to:
  /// **'Notifications could not be enabled right now. Check your connection and try again.'**
  String get notification_sync_failed;

  /// No description provided for @open_settings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get open_settings;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @no_notifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get no_notifications;

  /// No description provided for @no_notifications_message.
  ///
  /// In en, this message translates to:
  /// **'Your updates will appear here.'**
  String get no_notifications_message;

  /// No description provided for @unread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get unread;

  /// No description provided for @read.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get read;

  /// No description provided for @notification_marked_as_read.
  ///
  /// In en, this message translates to:
  /// **'Notification marked as read'**
  String get notification_marked_as_read;

  /// No description provided for @notification_open_failed.
  ///
  /// In en, this message translates to:
  /// **'This notification has no order details yet.'**
  String get notification_open_failed;

  /// No description provided for @my_profile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get my_profile;

  /// No description provided for @contact_us_title.
  ///
  /// In en, this message translates to:
  /// **'We\'re here to help'**
  String get contact_us_title;

  /// No description provided for @contact_us_body.
  ///
  /// In en, this message translates to:
  /// **'Send us your issue and we\'ll get back to you.'**
  String get contact_us_body;

  /// No description provided for @mobile_number.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobile_number;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @hint_email.
  ///
  /// In en, this message translates to:
  /// **'gxxxx@gmail.com'**
  String get hint_email;

  /// No description provided for @hint_title.
  ///
  /// In en, this message translates to:
  /// **'Message title'**
  String get hint_title;

  /// No description provided for @hint_description.
  ///
  /// In en, this message translates to:
  /// **'Your message...'**
  String get hint_description;

  /// No description provided for @help_center_body.
  ///
  /// In en, this message translates to:
  /// **'Quick answers to your questions'**
  String get help_center_body;

  /// No description provided for @app_lang.
  ///
  /// In en, this message translates to:
  /// **'Application Language'**
  String get app_lang;

  /// No description provided for @txt_english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get txt_english;

  /// No description provided for @txt_arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get txt_arabic;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @dialog_delete_account_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get dialog_delete_account_title;

  /// No description provided for @dialog_delete_account_body.
  ///
  /// In en, this message translates to:
  /// **'Do you want to continue deleting your account? This action cannot be undone.'**
  String get dialog_delete_account_body;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @book_now.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get book_now;

  /// No description provided for @popular_categories.
  ///
  /// In en, this message translates to:
  /// **'Popular Categories'**
  String get popular_categories;

  /// No description provided for @popular_companies.
  ///
  /// In en, this message translates to:
  /// **'Popular Companies'**
  String get popular_companies;

  /// No description provided for @popular_services.
  ///
  /// In en, this message translates to:
  /// **'Popular Services'**
  String get popular_services;

  /// No description provided for @all_categories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get all_categories;

  /// No description provided for @all_companies.
  ///
  /// In en, this message translates to:
  /// **'All Companies'**
  String get all_companies;

  /// No description provided for @all_services.
  ///
  /// In en, this message translates to:
  /// **'All Services'**
  String get all_services;

  /// No description provided for @available_services.
  ///
  /// In en, this message translates to:
  /// **'Available Services'**
  String get available_services;

  /// No description provided for @all_regions.
  ///
  /// In en, this message translates to:
  /// **'All Regions'**
  String get all_regions;

  /// No description provided for @all_providers.
  ///
  /// In en, this message translates to:
  /// **'All Providers'**
  String get all_providers;

  /// No description provided for @all_offers.
  ///
  /// In en, this message translates to:
  /// **'All Offers'**
  String get all_offers;

  /// No description provided for @services_title.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services_title;

  /// No description provided for @no_services_available.
  ///
  /// In en, this message translates to:
  /// **'No services available'**
  String get no_services_available;

  /// No description provided for @regions_title.
  ///
  /// In en, this message translates to:
  /// **'Regions'**
  String get regions_title;

  /// No description provided for @search_regions.
  ///
  /// In en, this message translates to:
  /// **'Regions'**
  String get search_regions;

  /// No description provided for @no_regions_found.
  ///
  /// In en, this message translates to:
  /// **'No regions found'**
  String get no_regions_found;

  /// No description provided for @companies_title.
  ///
  /// In en, this message translates to:
  /// **'Companies'**
  String get companies_title;

  /// No description provided for @no_companies_found.
  ///
  /// In en, this message translates to:
  /// **'No companies found'**
  String get no_companies_found;

  /// No description provided for @total_companies.
  ///
  /// In en, this message translates to:
  /// **'Total Companies'**
  String get total_companies;

  /// No description provided for @open_companies.
  ///
  /// In en, this message translates to:
  /// **'Open Now'**
  String get open_companies;

  /// No description provided for @open_label.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open_label;

  /// No description provided for @closed_label.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed_label;

  /// No description provided for @manager_label.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get manager_label;

  /// No description provided for @working_hours_label.
  ///
  /// In en, this message translates to:
  /// **'Working hours'**
  String get working_hours_label;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @my_reviews.
  ///
  /// In en, this message translates to:
  /// **'My Reviews'**
  String get my_reviews;

  /// No description provided for @payment_history.
  ///
  /// In en, this message translates to:
  /// **'Payment History'**
  String get payment_history;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get edit_profile;

  /// No description provided for @update_profile.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get update_profile;

  /// No description provided for @profile_updated_successfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profile_updated_successfully;

  /// No description provided for @password_changed_successfully.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get password_changed_successfully;

  /// No description provided for @logout_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logout_confirmation;

  /// No description provided for @logout_successfully.
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully'**
  String get logout_successfully;

  /// No description provided for @change_photo.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get change_photo;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @failed_to_pick_image.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image'**
  String get failed_to_pick_image;

  /// No description provided for @failed_to_update_profile.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile'**
  String get failed_to_update_profile;

  /// No description provided for @failed_to_logout.
  ///
  /// In en, this message translates to:
  /// **'Failed to logout'**
  String get failed_to_logout;

  /// No description provided for @fill_required_fields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get fill_required_fields;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @show_more.
  ///
  /// In en, this message translates to:
  /// **'Show More'**
  String get show_more;

  /// No description provided for @about_us.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get about_us;

  /// No description provided for @booking_details.
  ///
  /// In en, this message translates to:
  /// **'Booking Details'**
  String get booking_details;

  /// No description provided for @selected_package_label.
  ///
  /// In en, this message translates to:
  /// **'Selected Package'**
  String get selected_package_label;

  /// No description provided for @date_label.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date_label;

  /// No description provided for @select_date.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get select_date;

  /// No description provided for @time_label.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time_label;

  /// No description provided for @select_time.
  ///
  /// In en, this message translates to:
  /// **'Select time'**
  String get select_time;

  /// No description provided for @address_label.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address_label;

  /// No description provided for @address_hint.
  ///
  /// In en, this message translates to:
  /// **'Home Address'**
  String get address_hint;

  /// No description provided for @notes_label.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes_label;

  /// No description provided for @coupon_label.
  ///
  /// In en, this message translates to:
  /// **'Coupon'**
  String get coupon_label;

  /// No description provided for @coupon_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter coupon code'**
  String get coupon_hint;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @total_label.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total_label;

  /// No description provided for @confirm_booking.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirm_booking;

  /// No description provided for @coupon_applied.
  ///
  /// In en, this message translates to:
  /// **'Coupon applied'**
  String get coupon_applied;

  /// No description provided for @invalid_coupon.
  ///
  /// In en, this message translates to:
  /// **'Invalid coupon code'**
  String get invalid_coupon;

  /// No description provided for @booking_successful.
  ///
  /// In en, this message translates to:
  /// **'Booking Successful'**
  String get booking_successful;

  /// No description provided for @booking_successful_message.
  ///
  /// In en, this message translates to:
  /// **'Your booking was created successfully.'**
  String get booking_successful_message;

  /// No description provided for @search_title.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search_title;

  /// No description provided for @search_categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get search_categories;

  /// No description provided for @search_companies.
  ///
  /// In en, this message translates to:
  /// **'Companies'**
  String get search_companies;

  /// No description provided for @search_services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get search_services;

  /// No description provided for @search_providers.
  ///
  /// In en, this message translates to:
  /// **'Providers'**
  String get search_providers;

  /// No description provided for @search_offers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get search_offers;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @search_filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get search_filter;

  /// No description provided for @search_tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get search_tags;

  /// No description provided for @search_order.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get search_order;

  /// No description provided for @search_ascending.
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get search_ascending;

  /// No description provided for @search_descending.
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get search_descending;

  /// No description provided for @search_release_year.
  ///
  /// In en, this message translates to:
  /// **'Release Year'**
  String get search_release_year;

  /// No description provided for @search_rate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get search_rate;

  /// No description provided for @search_apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get search_apply;

  /// No description provided for @search_reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get search_reset;

  /// No description provided for @search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search for companies, services, categories and more...'**
  String get search_hint;

  /// No description provided for @search_no_results.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get search_no_results;

  /// No description provided for @search_availability.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get search_availability;

  /// No description provided for @search_price_range.
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get search_price_range;

  /// No description provided for @search_rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get search_rating;

  /// No description provided for @search_distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get search_distance;

  /// No description provided for @search_sort_by.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get search_sort_by;

  /// No description provided for @search_filter_by.
  ///
  /// In en, this message translates to:
  /// **'Filter by'**
  String get search_filter_by;

  /// No description provided for @search_clear_filters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get search_clear_filters;

  /// No description provided for @search_today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get search_today;

  /// No description provided for @search_tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get search_tomorrow;

  /// No description provided for @search_week.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get search_week;

  /// No description provided for @my_bookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get my_bookings;

  /// No description provided for @ongoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get ongoing;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @assigned.
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get assigned;

  /// No description provided for @in_process.
  ///
  /// In en, this message translates to:
  /// **'In Process'**
  String get in_process;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @canceled.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get canceled;

  /// No description provided for @unknown_status.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown_status;

  /// No description provided for @team_leader.
  ///
  /// In en, this message translates to:
  /// **'Team Leader'**
  String get team_leader;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone_number;

  /// No description provided for @could_not_open_phone.
  ///
  /// In en, this message translates to:
  /// **'Could not open phone dialer'**
  String get could_not_open_phone;

  /// No description provided for @track_service_title.
  ///
  /// In en, this message translates to:
  /// **'Track Service'**
  String get track_service_title;

  /// No description provided for @track_open_full_map.
  ///
  /// In en, this message translates to:
  /// **'Open Map'**
  String get track_open_full_map;

  /// No description provided for @track_distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get track_distance;

  /// No description provided for @track_eta.
  ///
  /// In en, this message translates to:
  /// **'ETA'**
  String get track_eta;

  /// No description provided for @track_estimated_arrival.
  ///
  /// In en, this message translates to:
  /// **'Estimated Arrival'**
  String get track_estimated_arrival;

  /// No description provided for @track_minutes_short.
  ///
  /// In en, this message translates to:
  /// **'mins'**
  String get track_minutes_short;

  /// No description provided for @track_kilometers_short.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get track_kilometers_short;

  /// No description provided for @track_now.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get track_now;

  /// No description provided for @status_assigned.
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get status_assigned;

  /// No description provided for @status_on_the_way.
  ///
  /// In en, this message translates to:
  /// **'On The Way'**
  String get status_on_the_way;

  /// No description provided for @status_arrived.
  ///
  /// In en, this message translates to:
  /// **'Arrived'**
  String get status_arrived;

  /// No description provided for @status_service_started.
  ///
  /// In en, this message translates to:
  /// **'Service Started'**
  String get status_service_started;

  /// No description provided for @status_completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get status_completed;

  /// No description provided for @track_msg_assigned.
  ///
  /// In en, this message translates to:
  /// **'A cleaner has been assigned'**
  String get track_msg_assigned;

  /// No description provided for @track_msg_on_the_way.
  ///
  /// In en, this message translates to:
  /// **'Cleaner is approaching'**
  String get track_msg_on_the_way;

  /// No description provided for @track_msg_arrived.
  ///
  /// In en, this message translates to:
  /// **'Cleaner has arrived'**
  String get track_msg_arrived;

  /// No description provided for @track_msg_service_started.
  ///
  /// In en, this message translates to:
  /// **'Service in progress'**
  String get track_msg_service_started;

  /// No description provided for @track_msg_completed.
  ///
  /// In en, this message translates to:
  /// **'Service completed'**
  String get track_msg_completed;

  /// No description provided for @track_assigned_cleaner.
  ///
  /// In en, this message translates to:
  /// **'Assigned Cleaner'**
  String get track_assigned_cleaner;

  /// No description provided for @track_services_done.
  ///
  /// In en, this message translates to:
  /// **'services done'**
  String get track_services_done;

  /// No description provided for @track_call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get track_call;

  /// No description provided for @track_chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get track_chat;

  /// No description provided for @track_progress.
  ///
  /// In en, this message translates to:
  /// **'Service Progress'**
  String get track_progress;

  /// No description provided for @booking_confirmed.
  ///
  /// In en, this message translates to:
  /// **'Booking Confirmed'**
  String get booking_confirmed;

  /// No description provided for @cleaner_assigned.
  ///
  /// In en, this message translates to:
  /// **'Cleaner Assigned'**
  String get cleaner_assigned;

  /// No description provided for @service_details.
  ///
  /// In en, this message translates to:
  /// **'Service Details'**
  String get service_details;

  /// No description provided for @detail_service.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get detail_service;

  /// No description provided for @detail_date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get detail_date;

  /// No description provided for @detail_time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get detail_time;

  /// No description provided for @detail_duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get detail_duration;

  /// No description provided for @detail_address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get detail_address;

  /// No description provided for @detail_payment.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get detail_payment;

  /// No description provided for @track_worker_btn.
  ///
  /// In en, this message translates to:
  /// **'Track Worker'**
  String get track_worker_btn;

  /// No description provided for @cancel_service.
  ///
  /// In en, this message translates to:
  /// **'Cancel Service'**
  String get cancel_service;

  /// No description provided for @track_error_generic.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while loading tracking'**
  String get track_error_generic;

  /// No description provided for @track_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get track_retry;

  /// No description provided for @track_cancel_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Cancel Service?'**
  String get track_cancel_confirm_title;

  /// No description provided for @track_cancel_confirm_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this service? This action cannot be undone.'**
  String get track_cancel_confirm_message;

  /// No description provided for @track_yes_cancel.
  ///
  /// In en, this message translates to:
  /// **'Yes, Cancel'**
  String get track_yes_cancel;

  /// No description provided for @track_keep.
  ///
  /// In en, this message translates to:
  /// **'Keep It'**
  String get track_keep;

  /// No description provided for @track_cancelled_message.
  ///
  /// In en, this message translates to:
  /// **'Service cancelled successfully'**
  String get track_cancelled_message;

  /// No description provided for @validation_email_invalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get validation_email_invalid;

  /// No description provided for @validation_email_required.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get validation_email_required;

  /// No description provided for @auth_email_label.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get auth_email_label;

  /// No description provided for @auth_email_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get auth_email_hint;

  /// No description provided for @sp.
  ///
  /// In en, this message translates to:
  /// **'\$'**
  String get sp;

  /// No description provided for @working_hours.
  ///
  /// In en, this message translates to:
  /// **'Working Hours'**
  String get working_hours;

  /// No description provided for @working_days.
  ///
  /// In en, this message translates to:
  /// **'Working Days'**
  String get working_days;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @open_now.
  ///
  /// In en, this message translates to:
  /// **'Open Now'**
  String get open_now;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @choose_package.
  ///
  /// In en, this message translates to:
  /// **'Choose Package'**
  String get choose_package;

  /// No description provided for @what_is_included.
  ///
  /// In en, this message translates to:
  /// **'What\'s included'**
  String get what_is_included;

  /// No description provided for @customer_reviews.
  ///
  /// In en, this message translates to:
  /// **'Customer Reviews'**
  String get customer_reviews;

  /// No description provided for @view_details.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get view_details;

  /// No description provided for @meet_our_workers.
  ///
  /// In en, this message translates to:
  /// **'Meet Our Workers'**
  String get meet_our_workers;

  /// No description provided for @years_of_experience.
  ///
  /// In en, this message translates to:
  /// **'Years of experience'**
  String get years_of_experience;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @no_available_dates.
  ///
  /// In en, this message translates to:
  /// **'No Available Appointments'**
  String get no_available_dates;

  /// No description provided for @no_available_dates_message.
  ///
  /// In en, this message translates to:
  /// **'There are currently no available dates for this package. Please try again later or choose another package.'**
  String get no_available_dates_message;

  /// No description provided for @no_available_times.
  ///
  /// In en, this message translates to:
  /// **'No Available Times'**
  String get no_available_times;

  /// No description provided for @no_available_times_message.
  ///
  /// In en, this message translates to:
  /// **'There are currently no available times for this date. Please try again later or choose another date.'**
  String get no_available_times_message;

  /// No description provided for @order_details.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get order_details;

  /// No description provided for @order_not_found.
  ///
  /// In en, this message translates to:
  /// **'Order not found'**
  String get order_not_found;

  /// No description provided for @cancel_order.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get cancel_order;

  /// No description provided for @cancel_order_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this order?'**
  String get cancel_order_confirmation;

  /// No description provided for @order_canceled_successfully.
  ///
  /// In en, this message translates to:
  /// **'Order canceled successfully'**
  String get order_canceled_successfully;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @total_price.
  ///
  /// In en, this message translates to:
  /// **'Total Price'**
  String get total_price;

  /// No description provided for @start_time.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get start_time;

  /// No description provided for @end_time.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get end_time;

  /// No description provided for @company_location.
  ///
  /// In en, this message translates to:
  /// **'Company Location'**
  String get company_location;

  /// No description provided for @package_details.
  ///
  /// In en, this message translates to:
  /// **'Package Details'**
  String get package_details;

  /// No description provided for @attributes.
  ///
  /// In en, this message translates to:
  /// **'Attributes'**
  String get attributes;

  /// No description provided for @booking_in_progress.
  ///
  /// In en, this message translates to:
  /// **'Booking...'**
  String get booking_in_progress;

  /// No description provided for @before_and_after.
  ///
  /// In en, this message translates to:
  /// **'Before & After'**
  String get before_and_after;

  /// No description provided for @add_review.
  ///
  /// In en, this message translates to:
  /// **'Add Review'**
  String get add_review;

  /// No description provided for @write_review.
  ///
  /// In en, this message translates to:
  /// **'Write a Review'**
  String get write_review;

  /// No description provided for @rating_required.
  ///
  /// In en, this message translates to:
  /// **'Please select a rating'**
  String get rating_required;

  /// No description provided for @review_comment_hint.
  ///
  /// In en, this message translates to:
  /// **'Share your experience (optional)'**
  String get review_comment_hint;

  /// No description provided for @submit_review.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get submit_review;

  /// No description provided for @review_submitted.
  ///
  /// In en, this message translates to:
  /// **'Review submitted successfully'**
  String get review_submitted;

  /// No description provided for @day_monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get day_monday;

  /// No description provided for @day_tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get day_tuesday;

  /// No description provided for @day_wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get day_wednesday;

  /// No description provided for @day_thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get day_thursday;

  /// No description provided for @day_friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get day_friday;

  /// No description provided for @day_saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get day_saturday;

  /// No description provided for @day_sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get day_sunday;

  /// No description provided for @no_service_reviews_yet.
  ///
  /// In en, this message translates to:
  /// **'No service reviews yet'**
  String get no_service_reviews_yet;

  /// No description provided for @service_reviews_will_appear_here.
  ///
  /// In en, this message translates to:
  /// **'Your reviews for services will appear here.'**
  String get service_reviews_will_appear_here;

  /// No description provided for @no_company_reviews_yet.
  ///
  /// In en, this message translates to:
  /// **'No company reviews yet'**
  String get no_company_reviews_yet;

  /// No description provided for @company_reviews_will_appear_here.
  ///
  /// In en, this message translates to:
  /// **'Your reviews for companies will appear here.'**
  String get company_reviews_will_appear_here;

  /// No description provided for @no_comment.
  ///
  /// In en, this message translates to:
  /// **'No comment'**
  String get no_comment;

  /// No description provided for @your_rating.
  ///
  /// In en, this message translates to:
  /// **'Your rating'**
  String get your_rating;

  /// No description provided for @reviewed_on.
  ///
  /// In en, this message translates to:
  /// **'Reviewed on'**
  String get reviewed_on;

  /// No description provided for @could_not_load_your_reviews.
  ///
  /// In en, this message translates to:
  /// **'Could not load your reviews'**
  String get could_not_load_your_reviews;

  /// No description provided for @could_not_load_profile_summary.
  ///
  /// In en, this message translates to:
  /// **'Could not load profile summary'**
  String get could_not_load_profile_summary;

  /// No description provided for @failed_to_delete_account.
  ///
  /// In en, this message translates to:
  /// **'Could not delete your account. Please try again.'**
  String get failed_to_delete_account;

  /// No description provided for @complaints.
  ///
  /// In en, this message translates to:
  /// **'Complaints'**
  String get complaints;

  /// No description provided for @service_complaints.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get service_complaints;

  /// No description provided for @company_complaints.
  ///
  /// In en, this message translates to:
  /// **'Companies'**
  String get company_complaints;

  /// No description provided for @submit_complaint.
  ///
  /// In en, this message translates to:
  /// **'Submit a Complaint'**
  String get submit_complaint;

  /// No description provided for @complaint_subject.
  ///
  /// In en, this message translates to:
  /// **'Complaint subject'**
  String get complaint_subject;

  /// No description provided for @complaint_message.
  ///
  /// In en, this message translates to:
  /// **'Complaint details'**
  String get complaint_message;

  /// No description provided for @complaint_details.
  ///
  /// In en, this message translates to:
  /// **'Complaint Details'**
  String get complaint_details;

  /// No description provided for @complaint_replies.
  ///
  /// In en, this message translates to:
  /// **'Replies'**
  String get complaint_replies;

  /// No description provided for @no_complaint_replies.
  ///
  /// In en, this message translates to:
  /// **'No replies yet'**
  String get no_complaint_replies;

  /// No description provided for @no_complaints_found.
  ///
  /// In en, this message translates to:
  /// **'No complaints found'**
  String get no_complaints_found;

  /// No description provided for @could_not_load_complaints.
  ///
  /// In en, this message translates to:
  /// **'Could not load complaints'**
  String get could_not_load_complaints;

  /// No description provided for @could_not_load_more_complaints.
  ///
  /// In en, this message translates to:
  /// **'Could not load more complaints'**
  String get could_not_load_more_complaints;

  /// No description provided for @complaint_submitted_successfully.
  ///
  /// In en, this message translates to:
  /// **'Complaint submitted successfully'**
  String get complaint_submitted_successfully;

  /// No description provided for @complaint_pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get complaint_pending;

  /// No description provided for @complaint_replied.
  ///
  /// In en, this message translates to:
  /// **'Replied'**
  String get complaint_replied;

  /// No description provided for @complaint_reviewed.
  ///
  /// In en, this message translates to:
  /// **'Reviewed'**
  String get complaint_reviewed;

  /// No description provided for @company_manager_label.
  ///
  /// In en, this message translates to:
  /// **'Company Manager'**
  String get company_manager_label;

  /// No description provided for @support_team_label.
  ///
  /// In en, this message translates to:
  /// **'CleanLink Support'**
  String get support_team_label;

  /// No description provided for @complaint_message_too_short.
  ///
  /// In en, this message translates to:
  /// **'Complaint details must be at least 10 characters'**
  String get complaint_message_too_short;

  /// No description provided for @required_field.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get required_field;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @minimum_price.
  ///
  /// In en, this message translates to:
  /// **'Minimum price'**
  String get minimum_price;

  /// No description provided for @maximum_price.
  ///
  /// In en, this message translates to:
  /// **'Maximum price'**
  String get maximum_price;

  /// No description provided for @invalid_price_range.
  ///
  /// In en, this message translates to:
  /// **'Minimum price cannot exceed maximum price'**
  String get invalid_price_range;

  /// No description provided for @could_not_load_more_offers.
  ///
  /// In en, this message translates to:
  /// **'Could not load more offers'**
  String get could_not_load_more_offers;

  /// No description provided for @service_location.
  ///
  /// In en, this message translates to:
  /// **'Service location'**
  String get service_location;

  /// No description provided for @select_location.
  ///
  /// In en, this message translates to:
  /// **'Select location'**
  String get select_location;

  /// No description provided for @selected_location.
  ///
  /// In en, this message translates to:
  /// **'Selected location'**
  String get selected_location;

  /// No description provided for @confirm_location.
  ///
  /// In en, this message translates to:
  /// **'Confirm location'**
  String get confirm_location;

  /// No description provided for @choose_location_on_map.
  ///
  /// In en, this message translates to:
  /// **'Choose a location on the map'**
  String get choose_location_on_map;

  /// No description provided for @change_location.
  ///
  /// In en, this message translates to:
  /// **'Change location'**
  String get change_location;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @move_map_to_select_location.
  ///
  /// In en, this message translates to:
  /// **'Move the map to select the exact service location.'**
  String get move_map_to_select_location;

  /// No description provided for @loading_address.
  ///
  /// In en, this message translates to:
  /// **'Loading address...'**
  String get loading_address;

  /// No description provided for @address_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Address unavailable. Enter the address manually.'**
  String get address_unavailable;

  /// No description provided for @use_current_location.
  ///
  /// In en, this message translates to:
  /// **'Use my current location'**
  String get use_current_location;

  /// No description provided for @location_permission_denied_message.
  ///
  /// In en, this message translates to:
  /// **'Location permission is needed to detect your current position. You can still select a location manually from the map.'**
  String get location_permission_denied_message;

  /// No description provided for @location_permission_denied_forever_message.
  ///
  /// In en, this message translates to:
  /// **'Location permission is disabled for CleanLink. Enable it from application settings or select the location manually.'**
  String get location_permission_denied_forever_message;

  /// No description provided for @location_service_disabled_message.
  ///
  /// In en, this message translates to:
  /// **'Turn on your device location service to use your current location. You can still choose a location manually.'**
  String get location_service_disabled_message;

  /// No description provided for @continue_manually.
  ///
  /// In en, this message translates to:
  /// **'Continue manually'**
  String get continue_manually;

  /// No description provided for @open_location_settings.
  ///
  /// In en, this message translates to:
  /// **'Open location settings'**
  String get open_location_settings;

  /// No description provided for @try_again.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get try_again;

  /// No description provided for @please_select_service_location.
  ///
  /// In en, this message translates to:
  /// **'Please select the service location.'**
  String get please_select_service_location;

  /// No description provided for @please_select_date.
  ///
  /// In en, this message translates to:
  /// **'Please select a date.'**
  String get please_select_date;

  /// No description provided for @please_select_available_time.
  ///
  /// In en, this message translates to:
  /// **'Please select an available time.'**
  String get please_select_available_time;

  /// No description provided for @no_available_slots_for_location.
  ///
  /// In en, this message translates to:
  /// **'No available times for this location'**
  String get no_available_slots_for_location;

  /// No description provided for @no_available_slots_for_location_message.
  ///
  /// In en, this message translates to:
  /// **'No available times were found for this location. Try another date or location.'**
  String get no_available_slots_for_location_message;

  /// No description provided for @company_location_missing.
  ///
  /// In en, this message translates to:
  /// **'The company has not configured its location yet.'**
  String get company_location_missing;

  /// No description provided for @travel_time_temporarily_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Travel time is temporarily unavailable. Please retry without changing your selection.'**
  String get travel_time_temporarily_unavailable;

  /// No description provided for @route_unavailable_for_location.
  ///
  /// In en, this message translates to:
  /// **'A driving route is unavailable for this location. Please choose another location.'**
  String get route_unavailable_for_location;

  /// No description provided for @no_qualified_workgroup.
  ///
  /// In en, this message translates to:
  /// **'No qualified workgroup is currently available for this package.'**
  String get no_qualified_workgroup;

  /// No description provided for @travel_allocation.
  ///
  /// In en, this message translates to:
  /// **'Travel allocation'**
  String get travel_allocation;

  /// No description provided for @worker_return.
  ///
  /// In en, this message translates to:
  /// **'Worker return'**
  String get worker_return;

  /// No description provided for @my_locations.
  ///
  /// In en, this message translates to:
  /// **'My locations'**
  String get my_locations;

  /// No description provided for @saved_locations.
  ///
  /// In en, this message translates to:
  /// **'Saved locations'**
  String get saved_locations;

  /// No description provided for @add_location.
  ///
  /// In en, this message translates to:
  /// **'Add location'**
  String get add_location;

  /// No description provided for @edit_location.
  ///
  /// In en, this message translates to:
  /// **'Edit location'**
  String get edit_location;

  /// No description provided for @delete_location.
  ///
  /// In en, this message translates to:
  /// **'Delete location'**
  String get delete_location;

  /// No description provided for @delete_location_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this saved location?'**
  String get delete_location_confirmation;

  /// No description provided for @location_name.
  ///
  /// In en, this message translates to:
  /// **'Location name'**
  String get location_name;

  /// No description provided for @location_name_hint.
  ///
  /// In en, this message translates to:
  /// **'For example, Home or Work (optional)'**
  String get location_name_hint;

  /// No description provided for @location_coordinates.
  ///
  /// In en, this message translates to:
  /// **'Coordinates'**
  String get location_coordinates;

  /// No description provided for @location_added_successfully.
  ///
  /// In en, this message translates to:
  /// **'Location added successfully'**
  String get location_added_successfully;

  /// No description provided for @location_updated_successfully.
  ///
  /// In en, this message translates to:
  /// **'Location updated successfully'**
  String get location_updated_successfully;

  /// No description provided for @location_deleted_successfully.
  ///
  /// In en, this message translates to:
  /// **'Location deleted successfully'**
  String get location_deleted_successfully;

  /// No description provided for @no_saved_locations.
  ///
  /// In en, this message translates to:
  /// **'No saved locations'**
  String get no_saved_locations;

  /// No description provided for @no_saved_locations_message.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any saved locations yet.'**
  String get no_saved_locations_message;

  /// No description provided for @could_not_load_locations.
  ///
  /// In en, this message translates to:
  /// **'Could not load your locations'**
  String get could_not_load_locations;

  /// No description provided for @choose_another_location.
  ///
  /// In en, this message translates to:
  /// **'Choose another location on map'**
  String get choose_another_location;

  /// No description provided for @add_new_saved_location.
  ///
  /// In en, this message translates to:
  /// **'Add new saved location'**
  String get add_new_saved_location;

  /// No description provided for @select_service_location.
  ///
  /// In en, this message translates to:
  /// **'Select service location'**
  String get select_service_location;

  /// No description provided for @save_location.
  ///
  /// In en, this message translates to:
  /// **'Save location'**
  String get save_location;

  /// No description provided for @update_location.
  ///
  /// In en, this message translates to:
  /// **'Update location'**
  String get update_location;

  /// No description provided for @cached_locations_warning.
  ///
  /// In en, this message translates to:
  /// **'Showing saved locations from this device. Pull to retry.'**
  String get cached_locations_warning;

  /// No description provided for @map_address_not_saved.
  ///
  /// In en, this message translates to:
  /// **'The server saves the map address and coordinates. Your location name stays on this device.'**
  String get map_address_not_saved;

  /// No description provided for @travel_considered_message.
  ///
  /// In en, this message translates to:
  /// **'Travel time is already considered when calculating available times.'**
  String get travel_considered_message;

  /// No description provided for @saved_location.
  ///
  /// In en, this message translates to:
  /// **'Saved location'**
  String get saved_location;

  /// No description provided for @customize_your_service.
  ///
  /// In en, this message translates to:
  /// **'Customize your service'**
  String get customize_your_service;

  /// No description provided for @customize_before_schedule.
  ///
  /// In en, this message translates to:
  /// **'Customize your service and check the price and duration to see available dates and times.'**
  String get customize_before_schedule;

  /// No description provided for @no_attributes_available.
  ///
  /// In en, this message translates to:
  /// **'No customization options are available.'**
  String get no_attributes_available;

  /// No description provided for @increase.
  ///
  /// In en, this message translates to:
  /// **'Increase'**
  String get increase;

  /// No description provided for @decrease.
  ///
  /// In en, this message translates to:
  /// **'Decrease'**
  String get decrease;

  /// No description provided for @estimated_price.
  ///
  /// In en, this message translates to:
  /// **'Estimated price'**
  String get estimated_price;

  /// No description provided for @estimated_duration.
  ///
  /// In en, this message translates to:
  /// **'Estimated duration'**
  String get estimated_duration;

  /// No description provided for @calculating.
  ///
  /// In en, this message translates to:
  /// **'Calculating…'**
  String get calculating;

  /// No description provided for @check_price_duration.
  ///
  /// In en, this message translates to:
  /// **'Check Price & Duration'**
  String get check_price_duration;

  /// No description provided for @checking_price_duration.
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get checking_price_duration;

  /// No description provided for @please_check_price_duration_again.
  ///
  /// In en, this message translates to:
  /// **'Please check price and duration for the current configuration first.'**
  String get please_check_price_duration_again;

  /// No description provided for @selected_configuration.
  ///
  /// In en, this message translates to:
  /// **'Selected Configuration'**
  String get selected_configuration;

  /// No description provided for @on_the_way.
  ///
  /// In en, this message translates to:
  /// **'On the Way'**
  String get on_the_way;

  /// No description provided for @payment_method.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get payment_method;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @credit_debit_card.
  ///
  /// In en, this message translates to:
  /// **'Credit / Debit Card'**
  String get credit_debit_card;

  /// No description provided for @electronic_payment_expiry_notice.
  ///
  /// In en, this message translates to:
  /// **'Complete the card payment within 10 minutes after the order is created. Otherwise, the order will be cancelled automatically.'**
  String get electronic_payment_expiry_notice;

  /// No description provided for @creating_payment.
  ///
  /// In en, this message translates to:
  /// **'Creating payment...'**
  String get creating_payment;

  /// No description provided for @preparing_payment.
  ///
  /// In en, this message translates to:
  /// **'Preparing secure payment...'**
  String get preparing_payment;

  /// No description provided for @payment_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Payment cancelled'**
  String get payment_cancelled;

  /// No description provided for @payment_cancelled_message.
  ///
  /// In en, this message translates to:
  /// **'The booking was created, but card payment was cancelled.'**
  String get payment_cancelled_message;

  /// No description provided for @payment_failed.
  ///
  /// In en, this message translates to:
  /// **'Payment failed'**
  String get payment_failed;

  /// No description provided for @payment_failed_message.
  ///
  /// In en, this message translates to:
  /// **'The booking was created, but card payment could not be completed.'**
  String get payment_failed_message;

  /// No description provided for @electronic_payment.
  ///
  /// In en, this message translates to:
  /// **'Electronic payment'**
  String get electronic_payment;

  /// No description provided for @payment_status.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get payment_status;

  /// No description provided for @pending_payment.
  ///
  /// In en, this message translates to:
  /// **'Pending payment'**
  String get pending_payment;

  /// No description provided for @payment_authorized.
  ///
  /// In en, this message translates to:
  /// **'Payment authorized'**
  String get payment_authorized;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @refunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get refunded;

  /// No description provided for @pay_now.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get pay_now;

  /// No description provided for @payment_processing.
  ///
  /// In en, this message translates to:
  /// **'Confirming payment...'**
  String get payment_processing;

  /// No description provided for @payment_processing_message.
  ///
  /// In en, this message translates to:
  /// **'Stripe completed the payment step. The server is still confirming the payment status.'**
  String get payment_processing_message;

  /// No description provided for @payment_confirmed.
  ///
  /// In en, this message translates to:
  /// **'Payment was confirmed by the server.'**
  String get payment_confirmed;

  /// No description provided for @payment_details.
  ///
  /// In en, this message translates to:
  /// **'Payment Details'**
  String get payment_details;

  /// No description provided for @payment_amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get payment_amount;

  /// No description provided for @payment_id.
  ///
  /// In en, this message translates to:
  /// **'Payment ID'**
  String get payment_id;

  /// No description provided for @order_id.
  ///
  /// In en, this message translates to:
  /// **'Order ID'**
  String get order_id;

  /// No description provided for @company_label.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get company_label;

  /// No description provided for @package_label.
  ///
  /// In en, this message translates to:
  /// **'Package'**
  String get package_label;

  /// No description provided for @booking_date.
  ///
  /// In en, this message translates to:
  /// **'Booking date'**
  String get booking_date;

  /// No description provided for @payment_reference.
  ///
  /// In en, this message translates to:
  /// **'Payment reference'**
  String get payment_reference;

  /// No description provided for @no_payments.
  ///
  /// In en, this message translates to:
  /// **'No payments yet'**
  String get no_payments;

  /// No description provided for @no_payments_message.
  ///
  /// In en, this message translates to:
  /// **'Your booking payments will appear here.'**
  String get no_payments_message;

  /// No description provided for @cleanlink_assistant.
  ///
  /// In en, this message translates to:
  /// **'CleanLink Assistant'**
  String get cleanlink_assistant;

  /// No description provided for @ask_cleanlink.
  ///
  /// In en, this message translates to:
  /// **'Ask CleanLink...'**
  String get ask_cleanlink;

  /// No description provided for @chat_welcome_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask about services, companies, locations and your bookings.'**
  String get chat_welcome_subtitle;

  /// No description provided for @assistant_typing.
  ///
  /// In en, this message translates to:
  /// **'CleanLink Assistant is typing...'**
  String get assistant_typing;

  /// No description provided for @previous_chats.
  ///
  /// In en, this message translates to:
  /// **'Previous Chats'**
  String get previous_chats;

  /// No description provided for @new_chat.
  ///
  /// In en, this message translates to:
  /// **'New Chat'**
  String get new_chat;

  /// No description provided for @delete_chat.
  ///
  /// In en, this message translates to:
  /// **'Delete Chat'**
  String get delete_chat;

  /// No description provided for @delete_conversation_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Conversation?'**
  String get delete_conversation_title;

  /// No description provided for @delete_conversation_body.
  ///
  /// In en, this message translates to:
  /// **'This conversation and all its messages will be permanently deleted.'**
  String get delete_conversation_body;

  /// No description provided for @conversation_deleted.
  ///
  /// In en, this message translates to:
  /// **'Conversation deleted successfully.'**
  String get conversation_deleted;

  /// No description provided for @no_previous_conversations.
  ///
  /// In en, this message translates to:
  /// **'No previous conversations'**
  String get no_previous_conversations;

  /// No description provided for @no_previous_conversations_message.
  ///
  /// In en, this message translates to:
  /// **'Your conversations with CleanLink Assistant will appear here.'**
  String get no_previous_conversations_message;

  /// No description provided for @suggestion_services.
  ///
  /// In en, this message translates to:
  /// **'What cleaning services are available?'**
  String get suggestion_services;

  /// No description provided for @suggestion_nearby.
  ///
  /// In en, this message translates to:
  /// **'Find cleaning companies near me'**
  String get suggestion_nearby;

  /// No description provided for @suggestion_booking.
  ///
  /// In en, this message translates to:
  /// **'What is the status of my latest booking?'**
  String get suggestion_booking;

  /// No description provided for @suggestion_compare.
  ///
  /// In en, this message translates to:
  /// **'Help me compare cleaning companies'**
  String get suggestion_compare;

  /// No description provided for @chat_connection_error.
  ///
  /// In en, this message translates to:
  /// **'Unable to reach CleanLink. Check your connection and try again.'**
  String get chat_connection_error;

  /// No description provided for @chat_message_too_long.
  ///
  /// In en, this message translates to:
  /// **'Messages can contain up to 2000 characters.'**
  String get chat_message_too_long;

  /// No description provided for @chat_load_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not load this conversation'**
  String get chat_load_failed;

  /// No description provided for @chat_history_load_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not load previous conversations'**
  String get chat_history_load_failed;

  /// No description provided for @chat_quota_exceeded.
  ///
  /// In en, this message translates to:
  /// **'The AI assistant has reached its free usage limit for now. Please try again later.'**
  String get chat_quota_exceeded;

  /// No description provided for @chat_temporarily_unavailable.
  ///
  /// In en, this message translates to:
  /// **'The AI assistant is temporarily unavailable. Please try again in a moment.'**
  String get chat_temporarily_unavailable;

  /// No description provided for @chat_provider_connection_error.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t connect to the AI assistant. Please check your connection and try again.'**
  String get chat_provider_connection_error;

  /// No description provided for @chat_error.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t complete your message. Please try again.'**
  String get chat_error;

  /// No description provided for @message_count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No messages} =1{1 message} other{{count} messages}}'**
  String message_count(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

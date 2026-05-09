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
  /// **'We sent a 6-digit code to {phone}'**
  String auth_otp_subtitle(String phone);

  /// No description provided for @auth_otp_resend_in.
  ///
  /// In en, this message translates to:
  /// **'Resend code in {seconds}s'**
  String auth_otp_resend_in(int seconds);

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

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

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

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;
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

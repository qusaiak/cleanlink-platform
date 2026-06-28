// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'English';

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get welcome => 'Welcome';

  @override
  String get help_text_1 =>
      'Choose your service and schedule a cleaning with just a few taps.';

  @override
  String get help_text_2 =>
      'Our experienced cleaners deliver high-quality and reliable service.';

  @override
  String get help_text_3 =>
      'Sit back and enjoy your spotless home while we handle the work.';

  @override
  String get skip => 'Skip';

  @override
  String get new_badge => 'NEW';

  @override
  String get home => 'Home';

  @override
  String get search => 'Search';

  @override
  String get history => 'History';

  @override
  String get bookings => 'Bookings';

  @override
  String get profile => 'Profile';

  @override
  String get error_connection_timeout =>
      'Connection timed out. Please try again.';

  @override
  String get retry => 'Retry';

  @override
  String get logging_in => 'Logging in...';

  @override
  String get successful_login_message => 'Login Successfully';

  @override
  String get successful_registration_message =>
      'Account Registered Successfully';

  @override
  String get personal_details => 'Personal Details';

  @override
  String get personal_details_subtitle =>
      'Complete your profile to start booking services';

  @override
  String get complete_profile => 'Complete Profile';

  @override
  String home_greeting(String name) {
    return 'Hello, $name';
  }

  @override
  String get do_not_have_an_account => 'Don\'t have an account? ';

  @override
  String get invalid_mobile_number_error_message =>
      'Please enter a valid mobile number';

  @override
  String get empty_field_error_message => 'This field is required';

  @override
  String get short_password_error_message =>
      'password must be at least 6 characters';

  @override
  String get password_with_regex_error_message =>
      'password must contain at least 1 letter and 1 number';

  @override
  String get password_confirmation_error_message =>
      'Confirm password does not match password';

  @override
  String get verify_account_error_message => 'please verify your account';

  @override
  String get verify_account_action => 'Verify Account';

  @override
  String get did_not_receive_code => 'Didn\'t receive code? ';

  @override
  String get resend_code => 'Resend code';

  @override
  String get error_connection => 'Please check your internet connection';

  @override
  String get creating_account => 'Creating account...';

  @override
  String get verify_account => 'Account Verification';

  @override
  String get verifying => 'Verifying...';

  @override
  String get auth_login_title => 'Welcome';

  @override
  String get auth_login_subtitle =>
      'Sign in to continue managing your cleaning services';

  @override
  String get auth_register_title => 'Create account';

  @override
  String get auth_register_subtitle => 'Start your premium journey';

  @override
  String get auth_phone_label => 'Phone number';

  @override
  String get auth_phone_hint => '9xx xxx xxx';

  @override
  String get auth_password_label => 'Password';

  @override
  String get auth_password_hint => 'Enter your password';

  @override
  String get auth_confirm_password_label => 'Confirm password';

  @override
  String get auth_confirm_password_hint => 'Re-enter your password';

  @override
  String get auth_old_password_label => 'Old password';

  @override
  String get auth_new_password_label => 'New password';

  @override
  String get auth_forgot_password => 'Forgot password?';

  @override
  String get auth_create_account => 'Create new account';

  @override
  String get auth_have_account => 'Already have an account? ';

  @override
  String get auth_sign_in => 'Sign in';

  @override
  String get auth_sign_up => 'Sign up';

  @override
  String get auth_login_button => 'Login';

  @override
  String get auth_register_button => 'Register';

  @override
  String get auth_continue => 'Continue';

  @override
  String get validation_required => 'This field is required';

  @override
  String get validation_phone_invalid => 'Enter a valid syrian phone number';

  @override
  String get validation_password_short => 'At least 8 characters';

  @override
  String get validation_password_uppercase =>
      'Must contain an uppercase letter';

  @override
  String get validation_password_number => 'Must contain a number';

  @override
  String get validation_passwords_no_match => 'Passwords do not match';

  @override
  String get validation_must_accept_terms => 'You must accept the terms';

  @override
  String get validation_age_18 => 'You must be at least 18 years old';

  @override
  String get validation_required_name => 'Please enter your name';

  @override
  String get auth_password_strength => 'Password strength';

  @override
  String get auth_password_weak => 'Weak';

  @override
  String get auth_password_medium => 'Medium';

  @override
  String get auth_password_strong => 'Strong';

  @override
  String get auth_forgot_title => 'Forgot password';

  @override
  String get auth_forgot_subtitle =>
      'Enter your phone number and we\'ll send you a verification code';

  @override
  String get auth_send_reset_code => 'Send reset code';

  @override
  String get auth_back_to_login => 'Back to login';

  @override
  String get auth_reset_title => 'Reset password';

  @override
  String get auth_reset_subtitle =>
      'Create a new strong password for your account';

  @override
  String get auth_reset_button => 'Reset password';

  @override
  String get auth_change_password_title => 'Change password';

  @override
  String get auth_change_password_subtitle =>
      'Update your password to keep your account safe';

  @override
  String get auth_update_password => 'Update password';

  @override
  String get auth_full_name => 'Full name';

  @override
  String get auth_full_name_hint => 'Enter your full name';

  @override
  String get auth_gender => 'Gender';

  @override
  String get auth_gender_male => 'Male';

  @override
  String get auth_gender_female => 'Female';

  @override
  String get auth_gender_other => 'Other';

  @override
  String get auth_gender_not_say => 'Prefer not to say';

  @override
  String get auth_birth_date => 'Birth date';

  @override
  String get auth_birth_date_hint => 'Select your birth date';

  @override
  String get auth_otp_title => 'Enter verification code';

  @override
  String auth_otp_subtitle(String phone) {
    return 'We sent a 6-digit code to $phone';
  }

  @override
  String auth_otp_resend_in(int seconds) {
    return 'Resend code in ${seconds}s';
  }

  @override
  String get auth_otp_resend => 'Resend code';

  @override
  String get auth_otp_verify => 'Verify';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get ok => 'OK';

  @override
  String get support => 'Support';

  @override
  String get updates => 'Updates';

  @override
  String get check_for_update => 'Check for Updates';

  @override
  String get help_center_title => 'Help Center';

  @override
  String get contact_us => 'Contact us';

  @override
  String get setting_title => 'Settings';

  @override
  String get logout => 'Logout';

  @override
  String get dialog_change_language_title => 'Change language';

  @override
  String get dialog_change_language_body =>
      'Are you sure about changing application language to Arabic?';

  @override
  String get privacy_policy => 'Privacy Policy';

  @override
  String get terms_of_use => 'Terms of Use';

  @override
  String get delete_account => 'Delete Account';

  @override
  String get suggestions => 'Suggestions';

  @override
  String get appearance => 'Appearance';

  @override
  String get notification_setting => 'Push Notifications';

  @override
  String get my_profile => 'My Profile';

  @override
  String get contact_us_title => 'We\'re here to help';

  @override
  String get contact_us_body =>
      'Send us your issue and we\'ll get back to you.';

  @override
  String get mobile_number => 'Mobile Number';

  @override
  String get title => 'Title';

  @override
  String get email => 'Email';

  @override
  String get description => 'Description';

  @override
  String get send => 'Send';

  @override
  String get optional => 'Optional';

  @override
  String get hint_email => 'gxxxx@gmail.com';

  @override
  String get hint_title => 'Message title';

  @override
  String get hint_description => 'Your message...';

  @override
  String get help_center_body => 'Quick answers to your questions';

  @override
  String get app_lang => 'Application Language';

  @override
  String get txt_english => 'English';

  @override
  String get txt_arabic => 'Arabic';

  @override
  String get save => 'Save';

  @override
  String get dialog_delete_account_title => 'Delete Account';

  @override
  String get dialog_delete_account_body =>
      'Do you want to continue deleting your account? This action cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get book_now => 'Book Now';

  @override
  String get popular_categories => 'Popular Categories';

  @override
  String get popular_companies => 'Popular Companies';

  @override
  String get popular_services => 'Popular Services';

  @override
  String get all_categories => 'All Categories';

  @override
  String get all_companies => 'All Companies';

  @override
  String get all_services => 'All Services';

  @override
  String get all_regions => 'All Regions';

  @override
  String get all_providers => 'All Providers';

  @override
  String get all_offers => 'All Offers';

  @override
  String get activity => 'Activity';

  @override
  String get favorites => 'Favorites';

  @override
  String get my_reviews => 'My Reviews';

  @override
  String get payment_history => 'Payment History';

  @override
  String get security => 'Security';

  @override
  String get edit => 'Edit';

  @override
  String get reviews => 'Reviews';

  @override
  String get show_more => 'Show More';

  @override
  String get about_us => 'About Us';

  @override
  String get booking_details => 'Booking Details';

  @override
  String get selected_package_label => 'Selected Package';

  @override
  String get date_label => 'Date';

  @override
  String get select_date => 'Select date';

  @override
  String get time_label => 'Time';

  @override
  String get select_time => 'Select time';

  @override
  String get address_label => 'Address';

  @override
  String get address_hint => 'Home Address';

  @override
  String get notes_label => 'Notes';

  @override
  String get coupon_label => 'Coupon';

  @override
  String get coupon_hint => 'Enter coupon code';

  @override
  String get apply => 'Apply';

  @override
  String get total_label => 'Total';

  @override
  String get confirm_booking => 'Confirm Booking';

  @override
  String get coupon_applied => 'Coupon applied';

  @override
  String get invalid_coupon => 'Invalid coupon code';

  @override
  String get booking_successful => 'Booking Successful';

  @override
  String get booking_successful_message =>
      'Your booking was created successfully.';

  @override
  String get search_title => 'Search';

  @override
  String get search_categories => 'Categories';

  @override
  String get search_companies => 'Companies';

  @override
  String get search_services => 'Services';

  @override
  String get search_regions => 'Regions';

  @override
  String get search_providers => 'Providers';

  @override
  String get search_offers => 'Offers';

  @override
  String get all => 'All';

  @override
  String get search_filter => 'Filter';

  @override
  String get search_tags => 'Tags';

  @override
  String get search_order => 'Order';

  @override
  String get search_ascending => 'Ascending';

  @override
  String get search_descending => 'Descending';

  @override
  String get search_release_year => 'Release Year';

  @override
  String get search_rate => 'Rate';

  @override
  String get search_apply => 'Apply';

  @override
  String get search_reset => 'Reset';

  @override
  String get search_hint =>
      'Search for companies, services, categories and more...';

  @override
  String get search_no_results => 'No results found';

  @override
  String get search_availability => 'Availability';

  @override
  String get search_price_range => 'Price Range';

  @override
  String get search_rating => 'Rating';

  @override
  String get search_distance => 'Distance';

  @override
  String get search_sort_by => 'Sort by';

  @override
  String get search_filter_by => 'Filter by';

  @override
  String get search_clear_filters => 'Clear filters';

  @override
  String get search_today => 'Today';

  @override
  String get search_tomorrow => 'Tomorrow';

  @override
  String get search_week => 'This Week';

  @override
  String get my_bookings => 'My Bookings';

  @override
  String get ongoing => 'Ongoing';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get completed => 'Completed';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get track_service_title => 'Track Service';

  @override
  String get track_open_full_map => 'Open Map';

  @override
  String get track_distance => 'Distance';

  @override
  String get track_eta => 'ETA';

  @override
  String get track_estimated_arrival => 'Estimated Arrival';

  @override
  String get track_minutes_short => 'mins';

  @override
  String get track_kilometers_short => 'km';

  @override
  String get track_now => 'Now';

  @override
  String get status_assigned => 'Assigned';

  @override
  String get status_on_the_way => 'On The Way';

  @override
  String get status_arrived => 'Arrived';

  @override
  String get status_service_started => 'Service Started';

  @override
  String get status_completed => 'Completed';

  @override
  String get track_msg_assigned => 'A cleaner has been assigned';

  @override
  String get track_msg_on_the_way => 'Cleaner is approaching';

  @override
  String get track_msg_arrived => 'Cleaner has arrived';

  @override
  String get track_msg_service_started => 'Service in progress';

  @override
  String get track_msg_completed => 'Service completed';

  @override
  String get track_assigned_cleaner => 'Assigned Cleaner';

  @override
  String get track_services_done => 'services done';

  @override
  String get track_call => 'Call';

  @override
  String get track_chat => 'Chat';

  @override
  String get track_progress => 'Service Progress';

  @override
  String get booking_confirmed => 'Booking Confirmed';

  @override
  String get cleaner_assigned => 'Cleaner Assigned';

  @override
  String get service_details => 'Service Details';

  @override
  String get detail_service => 'Service';

  @override
  String get detail_date => 'Date';

  @override
  String get detail_time => 'Time';

  @override
  String get detail_duration => 'Duration';

  @override
  String get detail_address => 'Address';

  @override
  String get detail_payment => 'Payment Method';

  @override
  String get track_worker_btn => 'Track Worker';

  @override
  String get cancel_service => 'Cancel Service';

  @override
  String get track_error_generic =>
      'Something went wrong while loading tracking';

  @override
  String get track_retry => 'Retry';

  @override
  String get track_cancel_confirm_title => 'Cancel Service?';

  @override
  String get track_cancel_confirm_message =>
      'Are you sure you want to cancel this service? This action cannot be undone.';

  @override
  String get track_yes_cancel => 'Yes, Cancel';

  @override
  String get track_keep => 'Keep It';

  @override
  String get track_cancelled_message => 'Service cancelled successfully';

  @override
  String get validation_email_invalid => 'Please enter a valid email address';

  @override
  String get validation_email_required => 'Email is required';

  @override
  String get auth_email_label => 'Email';

  @override
  String get auth_email_hint => 'Enter your email';

  @override
  String get sp => 'S.P';

  @override
  String get working_hours => 'Working Hours';

  @override
  String get working_days => 'Working Days';

  @override
  String get closed => 'Closed';

  @override
  String get open_now => 'Open Now';

  @override
  String get overview => 'Overview';

  @override
  String get choose_package => 'Choose Package';

  @override
  String get what_is_included => 'What\'s included';

  @override
  String get customer_reviews => 'Customer Reviews';

  @override
  String get view_details => 'View Details';
}

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
  String get network_no_internet_title => 'No internet connection';

  @override
  String get network_no_internet_description =>
      'Please check your connection and try again.';

  @override
  String get network_timeout_title => 'The request took too long';

  @override
  String get network_timeout_description =>
      'The server did not respond in time. Please try again.';

  @override
  String get network_server_title => 'The service is unavailable';

  @override
  String get network_server_description =>
      'The server could not complete your request. Please try again shortly.';

  @override
  String get network_generic_title => 'Something went wrong';

  @override
  String get network_generic_description =>
      'We could not load this content. Please try again.';

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
  String auth_otp_subtitle(String email) {
    return 'We sent a 6-digit code to $email';
  }

  @override
  String auth_otp_resend_in(String time) {
    return 'Resend code in $time';
  }

  @override
  String get auth_otp_resend => 'Resend code';

  @override
  String get auth_otp_verify => 'Verify';

  @override
  String get auth_otp_incomplete =>
      'Enter the complete 6-digit verification code';

  @override
  String get auth_otp_code_sent => 'A new code was sent';

  @override
  String get auth_error_generic => 'Something went wrong. Please try again.';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get ok => 'OK';

  @override
  String get success => 'Success';

  @override
  String get error => 'Error';

  @override
  String get warning => 'Warning';

  @override
  String get info => 'Info';

  @override
  String get session_expired_title => 'Session expired';

  @override
  String get session_expired_message =>
      'Your session has expired. Please log in again to continue.';

  @override
  String get no_data_found => 'No data found';

  @override
  String get try_again_later => 'Please try again later.';

  @override
  String get no_bookings => 'No bookings yet';

  @override
  String get no_bookings_message => 'Your reservations will appear here';

  @override
  String get no_categories_found => 'No categories found';

  @override
  String get could_not_load_more_categories => 'Could not load more categories';

  @override
  String get could_not_load_more_regions => 'Could not load more regions';

  @override
  String get could_not_load_more_companies => 'Could not load more companies';

  @override
  String get could_not_load_more_services => 'Could not load more services';

  @override
  String get could_not_load_more_notifications =>
      'Could not load more notifications';

  @override
  String get could_not_load_more_orders => 'Could not load more orders';

  @override
  String get price_unavailable => 'Price unavailable';

  @override
  String get from_price => 'From';

  @override
  String get up_to_price => 'Up to';

  @override
  String get no_offers_found => 'No offers found';

  @override
  String get no_favorite_services => 'No favorite services';

  @override
  String get service_favorites_will_appear_here =>
      'Your favorite services will appear here.';

  @override
  String get no_favorite_companies => 'No favorite companies';

  @override
  String get company_favorites_will_appear_here =>
      'Your favorite companies will appear here.';

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
  String get notification_setting_description =>
      'Receive updates about orders, complaints, offers, and account activity.';

  @override
  String get notifications_enabled_message => 'Push notifications are enabled.';

  @override
  String get notifications_disabled_message =>
      'Push notifications are disabled on this device.';

  @override
  String get notification_permission_title =>
      'Notification permission required';

  @override
  String get notification_permission_disabled =>
      'Notification permission is disabled. Enable it from the application settings to receive updates.';

  @override
  String get notification_sync_failed =>
      'Notifications could not be enabled right now. Check your connection and try again.';

  @override
  String get open_settings => 'Open Settings';

  @override
  String get notifications => 'Notifications';

  @override
  String get no_notifications => 'No notifications';

  @override
  String get no_notifications_message => 'Your updates will appear here.';

  @override
  String get unread => 'Unread';

  @override
  String get read => 'Read';

  @override
  String get notification_marked_as_read => 'Notification marked as read';

  @override
  String get notification_open_failed =>
      'This notification has no order details yet.';

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
  String get available_services => 'Available Services';

  @override
  String get all_regions => 'All Regions';

  @override
  String get all_providers => 'All Providers';

  @override
  String get all_offers => 'All Offers';

  @override
  String get services_title => 'Services';

  @override
  String get no_services_available => 'No services available';

  @override
  String get regions_title => 'Regions';

  @override
  String get search_regions => 'Regions';

  @override
  String get no_regions_found => 'No regions found';

  @override
  String get companies_title => 'Companies';

  @override
  String get no_companies_found => 'No companies found';

  @override
  String get total_companies => 'Total Companies';

  @override
  String get open_companies => 'Open Now';

  @override
  String get open_label => 'Open';

  @override
  String get closed_label => 'Closed';

  @override
  String get manager_label => 'Manager';

  @override
  String get working_hours_label => 'Working hours';

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
  String get edit_profile => 'Edit Profile';

  @override
  String get update_profile => 'Update Profile';

  @override
  String get profile_updated_successfully => 'Profile updated successfully';

  @override
  String get password_changed_successfully => 'Password changed successfully';

  @override
  String get logout_confirmation => 'Are you sure you want to logout?';

  @override
  String get logout_successfully => 'Logged out successfully';

  @override
  String get change_photo => 'Change photo';

  @override
  String get update => 'Update';

  @override
  String get failed_to_pick_image => 'Failed to pick image';

  @override
  String get failed_to_update_profile => 'Failed to update profile';

  @override
  String get failed_to_logout => 'Failed to logout';

  @override
  String get fill_required_fields => 'Please fill all required fields';

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
  String get pending => 'Pending';

  @override
  String get assigned => 'Assigned';

  @override
  String get in_process => 'In Process';

  @override
  String get completed => 'Completed';

  @override
  String get canceled => 'Canceled';

  @override
  String get unknown_status => 'Unknown';

  @override
  String get team_leader => 'Team Leader';

  @override
  String get call => 'Call';

  @override
  String get phone_number => 'Phone Number';

  @override
  String get could_not_open_phone => 'Could not open phone dialer';

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
  String get sp => '\$';

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

  @override
  String get meet_our_workers => 'Meet Our Workers';

  @override
  String get years_of_experience => 'Years of experience';

  @override
  String get close => 'Close';

  @override
  String get no_available_dates => 'No Available Appointments';

  @override
  String get no_available_dates_message =>
      'There are currently no available dates for this package. Please try again later or choose another package.';

  @override
  String get no_available_times => 'No Available Times';

  @override
  String get no_available_times_message =>
      'There are currently no available times for this date. Please try again later or choose another date.';

  @override
  String get order_details => 'Order Details';

  @override
  String get order_not_found => 'Order not found';

  @override
  String get cancel_order => 'Cancel Order';

  @override
  String get cancel_order_confirmation =>
      'Are you sure you want to cancel this order?';

  @override
  String get order_canceled_successfully => 'Order canceled successfully';

  @override
  String get location => 'Location';

  @override
  String get note => 'Note';

  @override
  String get duration => 'Duration';

  @override
  String get minutes => 'minutes';

  @override
  String get total_price => 'Total Price';

  @override
  String get start_time => 'Start Time';

  @override
  String get end_time => 'End Time';

  @override
  String get company_location => 'Company Location';

  @override
  String get package_details => 'Package Details';

  @override
  String get attributes => 'Attributes';

  @override
  String get booking_in_progress => 'Booking...';

  @override
  String get before_and_after => 'Before & After';

  @override
  String get add_review => 'Add Review';

  @override
  String get write_review => 'Write a Review';

  @override
  String get rating_required => 'Please select a rating';

  @override
  String get review_comment_hint => 'Share your experience (optional)';

  @override
  String get submit_review => 'Submit Review';

  @override
  String get review_submitted => 'Review submitted successfully';

  @override
  String get day_monday => 'Monday';

  @override
  String get day_tuesday => 'Tuesday';

  @override
  String get day_wednesday => 'Wednesday';

  @override
  String get day_thursday => 'Thursday';

  @override
  String get day_friday => 'Friday';

  @override
  String get day_saturday => 'Saturday';

  @override
  String get day_sunday => 'Sunday';

  @override
  String get no_service_reviews_yet => 'No service reviews yet';

  @override
  String get service_reviews_will_appear_here =>
      'Your reviews for services will appear here.';

  @override
  String get no_company_reviews_yet => 'No company reviews yet';

  @override
  String get company_reviews_will_appear_here =>
      'Your reviews for companies will appear here.';

  @override
  String get no_comment => 'No comment';

  @override
  String get your_rating => 'Your rating';

  @override
  String get reviewed_on => 'Reviewed on';

  @override
  String get could_not_load_your_reviews => 'Could not load your reviews';

  @override
  String get could_not_load_profile_summary => 'Could not load profile summary';

  @override
  String get failed_to_delete_account =>
      'Could not delete your account. Please try again.';

  @override
  String get complaints => 'Complaints';

  @override
  String get service_complaints => 'Services';

  @override
  String get company_complaints => 'Companies';

  @override
  String get submit_complaint => 'Submit a Complaint';

  @override
  String get complaint_subject => 'Complaint subject';

  @override
  String get complaint_message => 'Complaint details';

  @override
  String get complaint_details => 'Complaint Details';

  @override
  String get complaint_replies => 'Replies';

  @override
  String get no_complaint_replies => 'No replies yet';

  @override
  String get no_complaints_found => 'No complaints found';

  @override
  String get could_not_load_complaints => 'Could not load complaints';

  @override
  String get could_not_load_more_complaints => 'Could not load more complaints';

  @override
  String get complaint_submitted_successfully =>
      'Complaint submitted successfully';

  @override
  String get complaint_pending => 'Pending';

  @override
  String get complaint_replied => 'Replied';

  @override
  String get complaint_reviewed => 'Reviewed';

  @override
  String get company_manager_label => 'Company Manager';

  @override
  String get support_team_label => 'CleanLink Support';

  @override
  String get complaint_message_too_short =>
      'Complaint details must be at least 10 characters';

  @override
  String get required_field => 'This field is required';

  @override
  String get submit => 'Submit';

  @override
  String get minimum_price => 'Minimum price';

  @override
  String get maximum_price => 'Maximum price';

  @override
  String get invalid_price_range => 'Minimum price cannot exceed maximum price';

  @override
  String get could_not_load_more_offers => 'Could not load more offers';

  @override
  String get service_location => 'Service location';

  @override
  String get select_location => 'Select location';

  @override
  String get selected_location => 'Selected location';

  @override
  String get confirm_location => 'Confirm location';

  @override
  String get choose_location_on_map => 'Choose a location on the map';

  @override
  String get change_location => 'Change location';

  @override
  String get select => 'Select';

  @override
  String get move_map_to_select_location =>
      'Move the map to select the exact service location.';

  @override
  String get loading_address => 'Loading address...';

  @override
  String get address_unavailable =>
      'Address unavailable. Enter the address manually.';

  @override
  String get use_current_location => 'Use my current location';

  @override
  String get location_permission_denied_message =>
      'Location permission is needed to detect your current position. You can still select a location manually from the map.';

  @override
  String get location_permission_denied_forever_message =>
      'Location permission is disabled for CleanLink. Enable it from application settings or select the location manually.';

  @override
  String get location_service_disabled_message =>
      'Turn on your device location service to use your current location. You can still choose a location manually.';

  @override
  String get continue_manually => 'Continue manually';

  @override
  String get open_location_settings => 'Open location settings';

  @override
  String get try_again => 'Try again';

  @override
  String get please_select_service_location =>
      'Please select the service location.';

  @override
  String get please_select_date => 'Please select a date.';

  @override
  String get please_select_available_time => 'Please select an available time.';

  @override
  String get no_available_slots_for_location =>
      'No available times for this location';

  @override
  String get no_available_slots_for_location_message =>
      'No available times were found for this location. Try another date or location.';

  @override
  String get company_location_missing =>
      'The company has not configured its location yet.';

  @override
  String get travel_time_temporarily_unavailable =>
      'Travel time is temporarily unavailable. Please retry without changing your selection.';

  @override
  String get route_unavailable_for_location =>
      'A driving route is unavailable for this location. Please choose another location.';

  @override
  String get no_qualified_workgroup =>
      'No qualified workgroup is currently available for this package.';

  @override
  String get travel_allocation => 'Travel allocation';

  @override
  String get worker_return => 'Worker return';

  @override
  String get my_locations => 'My locations';

  @override
  String get saved_locations => 'Saved locations';

  @override
  String get add_location => 'Add location';

  @override
  String get edit_location => 'Edit location';

  @override
  String get delete_location => 'Delete location';

  @override
  String get delete_location_confirmation =>
      'Are you sure you want to delete this saved location?';

  @override
  String get location_name => 'Location name';

  @override
  String get location_name_hint => 'For example, Home or Work (optional)';

  @override
  String get location_coordinates => 'Coordinates';

  @override
  String get location_added_successfully => 'Location added successfully';

  @override
  String get location_updated_successfully => 'Location updated successfully';

  @override
  String get location_deleted_successfully => 'Location deleted successfully';

  @override
  String get no_saved_locations => 'No saved locations';

  @override
  String get no_saved_locations_message =>
      'You don\'t have any saved locations yet.';

  @override
  String get could_not_load_locations => 'Could not load your locations';

  @override
  String get choose_another_location => 'Choose another location on map';

  @override
  String get add_new_saved_location => 'Add new saved location';

  @override
  String get select_service_location => 'Select service location';

  @override
  String get save_location => 'Save location';

  @override
  String get update_location => 'Update location';

  @override
  String get cached_locations_warning =>
      'Showing saved locations from this device. Pull to retry.';

  @override
  String get map_address_not_saved =>
      'The server saves the map address and coordinates. Your location name stays on this device.';

  @override
  String get travel_considered_message =>
      'Travel time is already considered when calculating available times.';

  @override
  String get saved_location => 'Saved location';

  @override
  String get customize_your_service => 'Customize your service';

  @override
  String get customize_before_schedule =>
      'Customize your service and check the price and duration to see available dates and times.';

  @override
  String get no_attributes_available =>
      'No customization options are available.';

  @override
  String get increase => 'Increase';

  @override
  String get decrease => 'Decrease';

  @override
  String get estimated_price => 'Estimated price';

  @override
  String get estimated_duration => 'Estimated duration';

  @override
  String get calculating => 'Calculating…';

  @override
  String get check_price_duration => 'Check Price & Duration';

  @override
  String get checking_price_duration => 'Checking…';

  @override
  String get please_check_price_duration_again =>
      'Please check price and duration for the current configuration first.';

  @override
  String get selected_configuration => 'Selected Configuration';

  @override
  String get on_the_way => 'On the Way';

  @override
  String get payment_method => 'Payment Method';

  @override
  String get cash => 'Cash';

  @override
  String get credit_debit_card => 'Credit / Debit Card';

  @override
  String get electronic_payment_expiry_notice =>
      'Complete the card payment within 10 minutes after the order is created. Otherwise, the order will be cancelled automatically.';

  @override
  String get creating_payment => 'Creating payment...';

  @override
  String get preparing_payment => 'Preparing secure payment...';

  @override
  String get payment_cancelled => 'Payment cancelled';

  @override
  String get payment_cancelled_message =>
      'The booking was created, but card payment was cancelled.';

  @override
  String get payment_failed => 'Payment failed';

  @override
  String get payment_failed_message =>
      'The booking was created, but card payment could not be completed.';

  @override
  String get electronic_payment => 'Electronic payment';

  @override
  String get payment_status => 'Payment Status';

  @override
  String get pending_payment => 'Pending payment';

  @override
  String get payment_authorized => 'Payment authorized';

  @override
  String get paid => 'Paid';

  @override
  String get refunded => 'Refunded';

  @override
  String get pay_now => 'Pay Now';

  @override
  String get payment_processing => 'Confirming payment...';

  @override
  String get payment_processing_message =>
      'Stripe completed the payment step. The server is still confirming the payment status.';

  @override
  String get payment_confirmed => 'Payment was confirmed by the server.';

  @override
  String get payment_details => 'Payment Details';

  @override
  String get payment_amount => 'Amount';

  @override
  String get payment_id => 'Payment ID';

  @override
  String get order_id => 'Order ID';

  @override
  String get company_label => 'Company';

  @override
  String get package_label => 'Package';

  @override
  String get booking_date => 'Booking date';

  @override
  String get payment_reference => 'Payment reference';

  @override
  String get no_payments => 'No payments yet';

  @override
  String get no_payments_message => 'Your booking payments will appear here.';

  @override
  String get cleanlink_assistant => 'CleanLink Assistant';

  @override
  String get ask_cleanlink => 'Ask CleanLink...';

  @override
  String get chat_welcome_subtitle =>
      'Ask about services, companies, locations and your bookings.';

  @override
  String get assistant_typing => 'CleanLink Assistant is typing...';

  @override
  String get previous_chats => 'Previous Chats';

  @override
  String get new_chat => 'New Chat';

  @override
  String get delete_chat => 'Delete Chat';

  @override
  String get delete_conversation_title => 'Delete Conversation?';

  @override
  String get delete_conversation_body =>
      'This conversation and all its messages will be permanently deleted.';

  @override
  String get conversation_deleted => 'Conversation deleted successfully.';

  @override
  String get no_previous_conversations => 'No previous conversations';

  @override
  String get no_previous_conversations_message =>
      'Your conversations with CleanLink Assistant will appear here.';

  @override
  String get suggestion_services => 'What cleaning services are available?';

  @override
  String get suggestion_nearby => 'Find cleaning companies near me';

  @override
  String get suggestion_booking => 'What is the status of my latest booking?';

  @override
  String get suggestion_compare => 'Help me compare cleaning companies';

  @override
  String get chat_connection_error =>
      'Unable to reach CleanLink. Check your connection and try again.';

  @override
  String get chat_message_too_long =>
      'Messages can contain up to 2000 characters.';

  @override
  String get chat_load_failed => 'Could not load this conversation';

  @override
  String get chat_history_load_failed =>
      'Could not load previous conversations';

  @override
  String get chat_quota_exceeded =>
      'The AI assistant has reached its free usage limit for now. Please try again later.';

  @override
  String get chat_temporarily_unavailable =>
      'The AI assistant is temporarily unavailable. Please try again in a moment.';

  @override
  String get chat_provider_connection_error =>
      'We couldn\'t connect to the AI assistant. Please check your connection and try again.';

  @override
  String get chat_error =>
      'We couldn\'t complete your message. Please try again.';

  @override
  String message_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count messages',
      one: '1 message',
      zero: 'No messages',
    );
    return '$_temp0';
  }
}

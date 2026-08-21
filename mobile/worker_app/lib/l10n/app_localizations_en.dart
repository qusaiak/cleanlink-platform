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
  String get auth_email_label => 'Email';

  @override
  String get auth_email_hint => 'Enter your email';

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
  String get validation_email_invalid => 'Enter a valid email address';

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
  String get password_changed_successfully => 'Password changed successfully';

  @override
  String get account => 'Account';

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
  String get categories => 'Categories';

  @override
  String get popular_companies => 'Popular Companies';

  @override
  String get popular_services => 'Popular Services';

  @override
  String get tasks_title => 'My Daily Tasks';

  @override
  String get tasks_remaining_today => 'Remaining Today';

  @override
  String get tasks_pending_today => 'Pending Today';

  @override
  String get tasks_completed_label => 'Completed Tasks';

  @override
  String get tasks_list_title => 'Task List';

  @override
  String get tasks_filter => 'Filter';

  @override
  String get filter_all => 'All';

  @override
  String task_request_number(String number) {
    return 'Request #$number';
  }

  @override
  String get task_status_assigned => 'Assigned';

  @override
  String get task_status_on_the_way => 'On the way';

  @override
  String get task_status_in_progress => 'In Progress';

  @override
  String get task_status_paused => 'Paused';

  @override
  String get task_status_completed => 'Completed';

  @override
  String get task_status_cancelled => 'Cancelled';

  @override
  String get task_action_start => 'Start Work';

  @override
  String get task_action_complete => 'Complete';

  @override
  String get task_action_pause => 'Pause';

  @override
  String get tasks_empty_title => 'No current tasks';

  @override
  String get tasks_empty_subtitle =>
      'New tasks will appear here once they are assigned to you.';

  @override
  String get tasks_load_failed => 'Failed to load tasks';

  @override
  String get task_started_message => 'Task started';

  @override
  String get task_paused_message => 'Task paused';

  @override
  String get task_completed_message => 'Task completed successfully';

  @override
  String get task_accepted_message => 'Task accepted';

  @override
  String get task_cancelled_message => 'Task cancelled';

  @override
  String task_status_updated_message(String status) {
    return 'Status updated to $status';
  }

  @override
  String get task_action_failed_message => 'Action failed. Please try again';

  @override
  String get task_open_failed => 'Couldn\'t open the task. Please try again';

  @override
  String get task_progress_section => 'Task Progress';

  @override
  String task_advance_to(String status) {
    return 'Move to: $status';
  }

  @override
  String get task_on_way_message => 'You\'re on your way to the location';

  @override
  String get invalid_status_transition_message =>
      'The task status must advance one step in order (Assigned → On the way → In Progress → Completed); going backward or skipping a step isn\'t allowed';

  @override
  String get images_only_when_done_message =>
      'Before/after photos can only be uploaded when completing the task';

  @override
  String get task_management_title => 'Task Management';

  @override
  String get task_details_section => 'Task Details';

  @override
  String get task_required_tools => 'Required Tools';

  @override
  String get task_time_label => 'Time';

  @override
  String get task_date_label => 'Date';

  @override
  String get task_duration_label => 'Duration';

  @override
  String get task_package_label => 'Package';

  @override
  String get task_included_section => 'What\'s included';

  @override
  String get task_urgent_badge => 'Urgent Task';

  @override
  String get task_price_label => 'Total Price';

  @override
  String get task_package_details_label => 'Package Details';

  @override
  String get task_service_section => 'Service';

  @override
  String get task_service_rating_label => 'Rating';

  @override
  String get task_leader_section => 'Team Leader';

  @override
  String get task_leader_yes => 'Yes';

  @override
  String get task_leader_no => 'No';

  @override
  String get task_schedule_section => 'Schedule';

  @override
  String get task_expected_end => 'Expected end';

  @override
  String get task_travel_buffer => 'Travel buffer';

  @override
  String minutes_value(int minutes) {
    return '$minutes min';
  }

  @override
  String get task_client_section => 'Client';

  @override
  String get task_team_section => 'Team';

  @override
  String get task_team_member => 'Team member';

  @override
  String get task_you_badge => 'You';

  @override
  String get task_leader_badge => 'Leader';

  @override
  String get task_payment_section => 'Payment';

  @override
  String get task_payment_method => 'Method';

  @override
  String get task_payment_status => 'Status';

  @override
  String get payment_method_manual => 'Cash';

  @override
  String get payment_method_electric => 'Electronic payment';

  @override
  String get payment_status_pending => 'Pending';

  @override
  String get payment_status_held => 'Authorized';

  @override
  String get payment_status_paid => 'Paid';

  @override
  String get payment_status_captured => 'Captured';

  @override
  String get payment_status_failed => 'Failed';

  @override
  String get task_notes_section => 'Notes';

  @override
  String get task_location_section => 'Location';

  @override
  String get task_view_map => 'View map';

  @override
  String get task_navigate => 'Navigate';

  @override
  String get task_map_unavailable => 'Map coordinates are unavailable';

  @override
  String get task_service_details => 'Service & package';

  @override
  String get task_minimum_workers => 'Minimum workers';

  @override
  String get today_summary_unavailable => 'Today\'s summary is unavailable';

  @override
  String get visual_documentation => 'Visual Documentation';

  @override
  String get photo_before => 'Photo before start';

  @override
  String get photo_after => 'Photo after completion';

  @override
  String get update_status_section => 'Update Status';

  @override
  String get update_status_button => 'Update Status';

  @override
  String get attach_photo_title => 'Add photo';

  @override
  String get take_photo => 'Take a photo';

  @override
  String get choose_from_gallery => 'Choose from gallery';

  @override
  String get photo_added_message => 'Photo added';

  @override
  String get photo_pick_failed_message => 'Couldn\'t add the photo';

  @override
  String get current_status => 'Current Status';

  @override
  String get availability_available => 'Available';

  @override
  String get availability_busy => 'Busy';

  @override
  String get availability_offline => 'Offline';

  @override
  String get manual_busy_not_allowed_message =>
      'The \"Busy\" status is set automatically by the system and can\'t be selected manually';

  @override
  String get overall_rating => 'Overall Rating';

  @override
  String get completed_tasks_count => 'Completed Tasks';

  @override
  String get profile_experience_years => 'Years of Experience';

  @override
  String get profile_leader_badge => 'Leader';

  @override
  String get profile_worker_badge => 'Worker';

  @override
  String get profile_leader_status_label => 'Leader';

  @override
  String get profile_not_leader => 'Not a Leader';

  @override
  String get profile_skills_title => 'Skills';

  @override
  String get profile_no_skills => 'No skills added yet';

  @override
  String get edit_name_title => 'Edit name';

  @override
  String get edit_address_title => 'Edit address';

  @override
  String get edit_phone_title => 'Edit phone number';

  @override
  String get edit_photo_title => 'Change profile photo';

  @override
  String get job_id_label => 'Job ID';

  @override
  String get profile_address_label => 'Address';

  @override
  String get profile_phone_label => 'Phone';

  @override
  String get profile_load_failed => 'Failed to load profile';

  @override
  String get profile_updated_message => 'Profile updated successfully';

  @override
  String get edit_email_title => 'Edit email';

  @override
  String get edit_job_id_title => 'Edit Job ID';

  @override
  String availability_updated_message(String status) {
    return 'Your status changed to $status';
  }

  @override
  String get notifications_title => 'Notifications';

  @override
  String get notifications_mark_all_read => 'Mark all read';

  @override
  String get notifications_empty_title => 'No notifications yet';

  @override
  String get notifications_empty_subtitle =>
      'When a client requests you for a service, it will show up here.';

  @override
  String get notifications_load_failed => 'Failed to load notifications';

  @override
  String get notification_received => 'Received';

  @override
  String get notification_mark_as_read => 'Mark as read';

  @override
  String get search_title => 'Search';

  @override
  String get search_mode_general => 'General';

  @override
  String get search_mode_custom => 'Custom';

  @override
  String get search_by_service_name => 'Service name';

  @override
  String get search_by_client_name => 'Client name';

  @override
  String get search_by_location => 'Location';

  @override
  String get search_by_time => 'Time';

  @override
  String get search_general_hint => 'Search across all services…';

  @override
  String search_custom_hint(String field) {
    return 'Search by $field…';
  }

  @override
  String get search_hint_prompt =>
      'Search services by name, client, location or time.';

  @override
  String get search_no_results => 'No services match your search';

  @override
  String get search_failed => 'Search failed. Please try again';

  @override
  String price_amount(String amount) {
    return '$amount SAR';
  }

  @override
  String get greeting_hello => 'Hello,';

  @override
  String get availability_off => 'Not Available';

  @override
  String get validation_experience_invalid =>
      'Enter a valid number of years (0 or more)';

  @override
  String get edit_experience_title => 'Edit experience';

  @override
  String get profile_skills_loading => 'Loading skills…';

  @override
  String get profile_all_skills_assigned =>
      'All available skills are already assigned.';

  @override
  String get profile_add_skill_hint => 'Add a skill';

  @override
  String get profile_skill_added_message => 'Skill added';

  @override
  String get logout_confirm_message => 'Are you sure you want to log out?';

  @override
  String get logout_failed_message =>
      'Couldn\'t reach the server, but you\'ve been logged out.';

  @override
  String get skills_available_title => 'Skills you can add';

  @override
  String get skills_load_failed => 'Couldn\'t load the skills list';

  @override
  String get skills_removed_message => 'Skill removed';

  @override
  String get skills_empty_dictionary => 'No skills are available right now.';
}

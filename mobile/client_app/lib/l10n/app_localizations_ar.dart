// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get language => 'اللغة';

  @override
  String get helloWorld => 'مرحبا عالم!';

  @override
  String get welcome => 'أهلا';

  @override
  String get help_text_1 =>
      'اختر الخدمة التي تناسبك وحدد موعدًا للتنظيف ببضع نقرات فقط.';

  @override
  String get help_text_2 =>
      'يقدم عمال النظافة ذوو الخبرة لدينا خدمة عالية الجودة وموثوقة.';

  @override
  String get help_text_3 =>
      'استرخِ واستمتع بمنزلك النظيف بينما نتولى نحن العمل.';

  @override
  String get skip => 'تخطي';

  @override
  String get new_badge => 'جديد';

  @override
  String get home => 'الرئيسية';

  @override
  String get search => 'البحث';

  @override
  String get history => 'السجل';

  @override
  String get bookings => 'الحجوزات';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get error_connection_timeout =>
      'انتهت مهلة الاتصال. يرجى المحاولة مرة أخرى.';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get network_no_internet_title => 'لا يوجد اتصال بالإنترنت';

  @override
  String get network_no_internet_description =>
      'يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى.';

  @override
  String get network_timeout_title => 'استغرق الطلب وقتاً طويلاً';

  @override
  String get network_timeout_description =>
      'لم يستجب الخادم في الوقت المحدد. يرجى المحاولة مرة أخرى.';

  @override
  String get network_server_title => 'الخدمة غير متاحة';

  @override
  String get network_server_description =>
      'تعذر على الخادم إكمال طلبك. يرجى المحاولة بعد قليل.';

  @override
  String get network_generic_title => 'حدث خطأ ما';

  @override
  String get network_generic_description =>
      'تعذر تحميل هذا المحتوى. يرجى المحاولة مرة أخرى.';

  @override
  String get logging_in => 'جاري تسجيل الدخول…';

  @override
  String get successful_login_message => 'تم تسجيل الدخول بنجاح';

  @override
  String get successful_registration_message => 'تم إنشاء الحساب بنجاح';

  @override
  String get personal_details => 'معلومات شخصية';

  @override
  String get personal_details_subtitle => 'أكمل ملفك الشخصي لبدء حجز الخدمات';

  @override
  String get complete_profile => 'إكمال الملف الشخصي';

  @override
  String home_greeting(String name) {
    return 'أهلاً، $name';
  }

  @override
  String get do_not_have_an_account => 'ليس لديك حساب؟';

  @override
  String get invalid_mobile_number_error_message =>
      'الرجاء إدخال رقم موبايل صحيح';

  @override
  String get empty_field_error_message => 'هذا الحقل مطلوب';

  @override
  String get short_password_error_message =>
      'كلمة المرور يجب أن تكون 6 محارف على الأقل';

  @override
  String get password_with_regex_error_message =>
      'كلمة المرور يجب أن تحتوي حرف واحد ورقم واحد على الأقل';

  @override
  String get password_confirmation_error_message =>
      'تأكيد كلمة المرور لا يطابق كلمة المرور';

  @override
  String get verify_account_error_message => 'الرجاء القيام بتأكيد الحساب';

  @override
  String get verify_account_action => 'أكد حسابك';

  @override
  String get did_not_receive_code => 'لم يصلك الرمز؟';

  @override
  String get resend_code => 'إعادة إرسال الرمز';

  @override
  String get error_connection => 'يرجى التحقق من الإتصال بالإنترنت';

  @override
  String get creating_account => 'جاري إنشاء الحساب…';

  @override
  String get verify_account => 'تأكيد الحساب';

  @override
  String get verifying => 'جاري التأكيد…';

  @override
  String get auth_login_title => 'أهلاً بك';

  @override
  String get auth_login_subtitle =>
      'سجّل الدخول لمتابعة إدارة خدمات التنظيف الخاصة بك';

  @override
  String get auth_register_title => 'إنشاء حساب';

  @override
  String get auth_register_subtitle => 'ابدأ تجربتك المميزة الآن';

  @override
  String get auth_phone_label => 'رقم الهاتف';

  @override
  String get auth_phone_hint => '9xx xxx xxx';

  @override
  String get auth_password_label => 'كلمة المرور';

  @override
  String get auth_password_hint => 'أدخل كلمة المرور';

  @override
  String get auth_confirm_password_label => 'تأكيد كلمة المرور';

  @override
  String get auth_confirm_password_hint => 'أعد إدخال كلمة المرور';

  @override
  String get auth_old_password_label => 'كلمة المرور الحالية';

  @override
  String get auth_new_password_label => 'كلمة المرور الجديدة';

  @override
  String get auth_forgot_password => 'نسيت كلمة المرور؟';

  @override
  String get auth_create_account => 'إنشاء حساب جديد';

  @override
  String get auth_have_account => 'لديك حساب بالفعل؟ ';

  @override
  String get auth_sign_in => 'تسجيل الدخول';

  @override
  String get auth_sign_up => 'إنشاء حساب';

  @override
  String get auth_login_button => 'تسجيل الدخول';

  @override
  String get auth_register_button => 'إنشاء الحساب';

  @override
  String get auth_continue => 'متابعة';

  @override
  String get validation_required => 'هذا الحقل مطلوب';

  @override
  String get validation_phone_invalid => 'أدخل رقم هاتف سوري صحيح';

  @override
  String get validation_password_short => '8 أحرف على الأقل';

  @override
  String get validation_password_uppercase => 'يجب أن تحتوي على حرف كبير';

  @override
  String get validation_password_number => 'يجب أن تحتوي على رقم';

  @override
  String get validation_passwords_no_match => 'كلمات المرور غير متطابقة';

  @override
  String get validation_must_accept_terms => 'يجب الموافقة على الشروط';

  @override
  String get validation_age_18 => 'يجب أن يكون عمرك 18 سنة على الأقل';

  @override
  String get validation_required_name => 'الرجاء إدخال الاسم';

  @override
  String get auth_password_strength => 'قوة كلمة المرور';

  @override
  String get auth_password_weak => 'ضعيفة';

  @override
  String get auth_password_medium => 'متوسطة';

  @override
  String get auth_password_strong => 'قوية';

  @override
  String get auth_forgot_title => 'نسيت كلمة المرور';

  @override
  String get auth_forgot_subtitle => 'أدخل رقم هاتفك وسنرسل إليك رمز التحقق';

  @override
  String get auth_send_reset_code => 'إرسال رمز التحقق';

  @override
  String get auth_back_to_login => 'العودة لتسجيل الدخول';

  @override
  String get auth_reset_title => 'إعادة تعيين كلمة المرور';

  @override
  String get auth_reset_subtitle => 'أنشئ كلمة مرور جديدة وقوية لحسابك';

  @override
  String get auth_reset_button => 'إعادة تعيين كلمة المرور';

  @override
  String get auth_change_password_title => 'تغيير كلمة المرور';

  @override
  String get auth_change_password_subtitle =>
      'حدّث كلمة المرور للحفاظ على حسابك آمناً';

  @override
  String get auth_update_password => 'تحديث كلمة المرور';

  @override
  String get auth_full_name => 'الاسم الكامل';

  @override
  String get auth_full_name_hint => 'أدخل اسمك الكامل';

  @override
  String get auth_gender => 'الجنس';

  @override
  String get auth_gender_male => 'ذكر';

  @override
  String get auth_gender_female => 'أنثى';

  @override
  String get auth_gender_other => 'آخر';

  @override
  String get auth_gender_not_say => 'أفضّل عدم الإجابة';

  @override
  String get auth_birth_date => 'تاريخ الميلاد';

  @override
  String get auth_birth_date_hint => 'اختر تاريخ ميلادك';

  @override
  String get auth_otp_title => 'أدخل رمز التحقق';

  @override
  String auth_otp_subtitle(String email) {
    return 'أرسلنا رمز تحقق مكوناً من 6 أرقام إلى $email';
  }

  @override
  String auth_otp_resend_in(String time) {
    return 'إعادة إرسال الرمز خلال $time';
  }

  @override
  String get auth_otp_resend => 'إعادة إرسال الرمز';

  @override
  String get auth_otp_verify => 'تحقق';

  @override
  String get auth_otp_incomplete => 'أدخل رمز التحقق الكامل المكون من 6 أرقام';

  @override
  String get auth_otp_code_sent => 'تم إرسال رمز جديد';

  @override
  String get auth_error_generic => 'حدث خطأ ما. يرجى المحاولة مرة أخرى.';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get ok => 'حسناً';

  @override
  String get success => 'نجاح';

  @override
  String get error => 'خطأ';

  @override
  String get warning => 'تنبيه';

  @override
  String get info => 'معلومة';

  @override
  String get session_expired_title => 'انتهت الجلسة';

  @override
  String get session_expired_message =>
      'انتهت صلاحية الجلسة الخاصة بك. يرجى تسجيل الدخول مرة أخرى للمتابعة.';

  @override
  String get no_data_found => 'لا توجد بيانات';

  @override
  String get try_again_later => 'يرجى المحاولة مرة أخرى لاحقاً.';

  @override
  String get no_bookings => 'لا توجد حجوزات بعد';

  @override
  String get no_bookings_message => 'ستظهر حجوزاتك هنا';

  @override
  String get no_categories_found => 'لا توجد تصنيفات';

  @override
  String get could_not_load_more_categories => 'تعذر تحميل المزيد من التصنيفات';

  @override
  String get could_not_load_more_regions => 'تعذر تحميل المزيد من المناطق';

  @override
  String get could_not_load_more_companies => 'تعذر تحميل المزيد من الشركات';

  @override
  String get could_not_load_more_services => 'تعذر تحميل المزيد من الخدمات';

  @override
  String get could_not_load_more_notifications =>
      'تعذر تحميل المزيد من الإشعارات';

  @override
  String get could_not_load_more_orders => 'تعذر تحميل المزيد من الطلبات';

  @override
  String get price_unavailable => 'السعر غير متاح';

  @override
  String get from_price => 'ابتداءً من';

  @override
  String get up_to_price => 'حتى';

  @override
  String get no_offers_found => 'لا توجد عروض';

  @override
  String get no_favorite_services => 'لا توجد خدمات مفضلة';

  @override
  String get service_favorites_will_appear_here => 'ستظهر خدماتك المفضلة هنا.';

  @override
  String get no_favorite_companies => 'لا توجد شركات مفضلة';

  @override
  String get company_favorites_will_appear_here => 'ستظهر شركاتك المفضلة هنا.';

  @override
  String get support => 'الدعم';

  @override
  String get updates => 'التحديثات';

  @override
  String get check_for_update => 'تحقق من وجود تحديث';

  @override
  String get help_center_title => 'مركز المساعدة';

  @override
  String get contact_us => 'تواصل معنا';

  @override
  String get setting_title => 'الإعدادات';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get dialog_change_language_title => 'تغيير اللغة';

  @override
  String get dialog_change_language_body =>
      'هل انت متأكد من تغيير لغة التطبيق إلى الإنكليزية؟';

  @override
  String get privacy_policy => 'سياسة الخصوصية';

  @override
  String get terms_of_use => 'شروط الاستخدام';

  @override
  String get delete_account => 'حذف الحساب';

  @override
  String get suggestions => 'اقتراحات';

  @override
  String get appearance => 'المظهر';

  @override
  String get notification_setting => 'الإشعارات';

  @override
  String get notification_setting_description =>
      'تلقي تحديثات حول الطلبات والشكاوى والعروض ونشاط الحساب.';

  @override
  String get notifications_enabled_message => 'تم تفعيل الإشعارات.';

  @override
  String get notifications_disabled_message =>
      'تم إيقاف الإشعارات على هذا الجهاز.';

  @override
  String get notification_permission_title => 'إذن الإشعارات مطلوب';

  @override
  String get notification_permission_disabled =>
      'تم تعطيل إذن الإشعارات. فعّله من إعدادات التطبيق لتلقي التحديثات.';

  @override
  String get notification_sync_failed =>
      'تعذر تفعيل الإشعارات الآن. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get open_settings => 'فتح الإعدادات';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get no_notifications => 'لا توجد إشعارات';

  @override
  String get no_notifications_message => 'ستظهر تحديثاتك هنا.';

  @override
  String get unread => 'غير مقروء';

  @override
  String get read => 'مقروء';

  @override
  String get notification_marked_as_read => 'تم تعليم الإشعار كمقروء';

  @override
  String get notification_open_failed =>
      'لا يحتوي هذا الإشعار على تفاصيل طلب حالياً.';

  @override
  String get my_profile => 'الملف الشخصي';

  @override
  String get contact_us_title => 'نحن هنا للمساعدة';

  @override
  String get contact_us_body => 'أرسل إلينا مشكلتك، وسنتواصل معك.';

  @override
  String get mobile_number => 'رقم الموبايل';

  @override
  String get title => 'العنوان';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get description => 'الوصف';

  @override
  String get send => 'إرسال';

  @override
  String get optional => 'اختياري';

  @override
  String get hint_email => 'gxxxx@gmail.com';

  @override
  String get hint_title => 'عنوان الرسالة';

  @override
  String get hint_description => 'اكتب رسالتك...';

  @override
  String get help_center_body => 'إجابات سريعة على أسئلتك';

  @override
  String get app_lang => 'اللغة';

  @override
  String get txt_english => 'اللغة الإنكليزية';

  @override
  String get txt_arabic => 'اللغة العربية';

  @override
  String get save => 'حفظ';

  @override
  String get dialog_delete_account_title => 'حذف الحساب';

  @override
  String get dialog_delete_account_body =>
      'هل تريد متابعة حذف حسابك؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get cancel => 'إلغاء';

  @override
  String get book_now => 'احجز الآن';

  @override
  String get popular_categories => 'أفضل التصنيفات';

  @override
  String get popular_companies => 'أفضل الشركات';

  @override
  String get popular_services => 'أفضل الخدمات';

  @override
  String get all_categories => 'جميع التصنيفات';

  @override
  String get all_companies => 'جميع الشركات';

  @override
  String get all_services => 'جميع الخدمات';

  @override
  String get available_services => 'الخدمات المتاحة';

  @override
  String get all_regions => 'جميع المناطق';

  @override
  String get all_providers => 'جميع المزودين';

  @override
  String get all_offers => 'جميع الباقات';

  @override
  String get services_title => 'الخدمات';

  @override
  String get no_services_available => 'لا توجد خدمات متاحة';

  @override
  String get regions_title => 'المناطق';

  @override
  String get search_regions => 'المناطق';

  @override
  String get no_regions_found => 'لا توجد مناطق';

  @override
  String get companies_title => 'الشركات';

  @override
  String get no_companies_found => 'لا توجد شركات';

  @override
  String get total_companies => 'إجمالي الشركات';

  @override
  String get open_companies => 'المفتوحة الآن';

  @override
  String get open_label => 'مفتوح';

  @override
  String get closed_label => 'مغلق';

  @override
  String get manager_label => 'المدير';

  @override
  String get working_hours_label => 'ساعات العمل';

  @override
  String get activity => 'النشاط';

  @override
  String get favorites => 'المفضلة';

  @override
  String get my_reviews => 'تقييماتي';

  @override
  String get payment_history => 'سجل الدفع';

  @override
  String get security => 'الحماية';

  @override
  String get edit => 'تعديل';

  @override
  String get edit_profile => 'تعديل الملف الشخصي';

  @override
  String get update_profile => 'تحديث الملف الشخصي';

  @override
  String get profile_updated_successfully => 'تم تحديث الملف الشخصي بنجاح';

  @override
  String get password_changed_successfully => 'تم تغيير كلمة المرور بنجاح';

  @override
  String get logout_confirmation => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get logout_successfully => 'تم تسجيل الخروج بنجاح';

  @override
  String get change_photo => 'تغيير الصورة';

  @override
  String get update => 'تحديث';

  @override
  String get failed_to_pick_image => 'فشل اختيار الصورة';

  @override
  String get failed_to_update_profile => 'فشل تحديث الملف الشخصي';

  @override
  String get failed_to_logout => 'فشل تسجيل الخروج';

  @override
  String get fill_required_fields => 'يرجى تعبئة جميع الحقول المطلوبة';

  @override
  String get reviews => 'التقييمات';

  @override
  String get show_more => 'عرض المزيد';

  @override
  String get about_us => 'معلومات عنا';

  @override
  String get booking_details => 'تفاصيل الحجز';

  @override
  String get selected_package_label => 'الباقة المختارة';

  @override
  String get date_label => 'التاريخ';

  @override
  String get select_date => 'اختر التاريخ';

  @override
  String get time_label => 'الوقت';

  @override
  String get select_time => 'اختر الوقت';

  @override
  String get address_label => 'العنوان';

  @override
  String get address_hint => 'عنوان المنزل';

  @override
  String get notes_label => 'ملاحظات';

  @override
  String get coupon_label => 'كود الخصم';

  @override
  String get coupon_hint => 'أدخل كود الخصم';

  @override
  String get apply => 'تطبيق';

  @override
  String get total_label => 'الإجمالي';

  @override
  String get confirm_booking => 'تأكيد الحجز';

  @override
  String get coupon_applied => 'تم تطبيق كود الخصم';

  @override
  String get invalid_coupon => 'كود الخصم غير صالح';

  @override
  String get booking_successful => 'تم الحجز بنجاح';

  @override
  String get booking_successful_message => 'تم إنشاء الحجز بنجاح.';

  @override
  String get search_title => 'استكشف';

  @override
  String get search_categories => 'التصنيفات';

  @override
  String get search_companies => 'الشركات';

  @override
  String get search_services => 'الخدمات';

  @override
  String get search_providers => 'المزودين';

  @override
  String get search_offers => 'العروض';

  @override
  String get all => 'الكل';

  @override
  String get search_filter => 'تصفية';

  @override
  String get search_tags => 'الوسوم';

  @override
  String get search_order => 'الترتيب';

  @override
  String get search_ascending => 'تصاعدي';

  @override
  String get search_descending => 'تنازلي';

  @override
  String get search_release_year => 'سنة الإصدار';

  @override
  String get search_rate => 'التقييم';

  @override
  String get search_apply => 'تطبيق';

  @override
  String get search_reset => 'إعادة تعيين';

  @override
  String get search_hint => 'ابحث عن شركات، خدمات، تصنيفات والمزيد...';

  @override
  String get search_no_results => 'لم يتم العثور على نتائج';

  @override
  String get search_availability => 'التوفر';

  @override
  String get search_price_range => 'نطاق السعر';

  @override
  String get search_rating => 'التقييم';

  @override
  String get search_distance => 'المسافة';

  @override
  String get search_sort_by => 'ترتيب حسب';

  @override
  String get search_filter_by => 'تصفية حسب';

  @override
  String get search_clear_filters => 'مسح الفلاتر';

  @override
  String get search_today => 'اليوم';

  @override
  String get search_tomorrow => 'غداً';

  @override
  String get search_week => 'هذا الأسبوع';

  @override
  String get my_bookings => 'حجوزاتي';

  @override
  String get ongoing => 'جارٍ';

  @override
  String get upcoming => 'قادم';

  @override
  String get pending => 'قيد الانتظار';

  @override
  String get assigned => 'تم التعيين';

  @override
  String get in_process => 'قيد التنفيذ';

  @override
  String get completed => 'مكتمل';

  @override
  String get canceled => 'ملغى';

  @override
  String get unknown_status => 'غير معروف';

  @override
  String get team_leader => 'قائد الفريق';

  @override
  String get call => 'اتصال';

  @override
  String get phone_number => 'رقم الهاتف';

  @override
  String get could_not_open_phone => 'تعذر فتح تطبيق الهاتف';

  @override
  String get track_service_title => 'تتبع الخدمة';

  @override
  String get track_open_full_map => 'فتح الخريطة';

  @override
  String get track_distance => 'المسافة';

  @override
  String get track_eta => 'وقت الوصول';

  @override
  String get track_estimated_arrival => 'الوصول المتوقع';

  @override
  String get track_minutes_short => 'دقيقة';

  @override
  String get track_kilometers_short => 'كم';

  @override
  String get track_now => 'الآن';

  @override
  String get status_assigned => 'تم التعيين';

  @override
  String get status_on_the_way => 'في الطريق';

  @override
  String get status_arrived => 'وصل';

  @override
  String get status_service_started => 'بدأت الخدمة';

  @override
  String get status_completed => 'اكتملت';

  @override
  String get track_msg_assigned => 'تم تعيين عامل نظافة';

  @override
  String get track_msg_on_the_way => 'عامل النظافة في الطريق إليك';

  @override
  String get track_msg_arrived => 'وصل عامل النظافة';

  @override
  String get track_msg_service_started => 'الخدمة قيد التنفيذ';

  @override
  String get track_msg_completed => 'اكتملت الخدمة';

  @override
  String get track_assigned_cleaner => 'عامل النظافة المعين';

  @override
  String get track_services_done => 'خدمة منجزة';

  @override
  String get track_call => 'اتصال';

  @override
  String get track_chat => 'محادثة';

  @override
  String get track_progress => 'مراحل الخدمة';

  @override
  String get booking_confirmed => 'تم تأكيد الحجز';

  @override
  String get cleaner_assigned => 'تم تعيين عامل النظافة';

  @override
  String get service_details => 'تفاصيل الخدمة';

  @override
  String get detail_service => 'الخدمة';

  @override
  String get detail_date => 'التاريخ';

  @override
  String get detail_time => 'الوقت';

  @override
  String get detail_duration => 'المدة';

  @override
  String get detail_address => 'العنوان';

  @override
  String get detail_payment => 'طريقة الدفع';

  @override
  String get track_worker_btn => 'تتبع العامل';

  @override
  String get cancel_service => 'إلغاء الخدمة';

  @override
  String get track_error_generic => 'حدث خطأ أثناء تحميل التتبع';

  @override
  String get track_retry => 'إعادة المحاولة';

  @override
  String get track_cancel_confirm_title => 'إلغاء الخدمة؟';

  @override
  String get track_cancel_confirm_message =>
      'هل أنت متأكد أنك تريد إلغاء هذه الخدمة؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get track_yes_cancel => 'نعم، إلغاء';

  @override
  String get track_keep => 'الاحتفاظ بها';

  @override
  String get track_cancelled_message => 'تم إلغاء الخدمة بنجاح';

  @override
  String get validation_email_invalid => 'الرجاء إدخال بريد إلكتروني صالح';

  @override
  String get validation_email_required => 'البريد الإلكتروني مطلوب';

  @override
  String get auth_email_label => 'البريد الإلكتروني';

  @override
  String get auth_email_hint => 'أدخل بريدك الإلكتروني';

  @override
  String get sp => 'ل.س';

  @override
  String get working_hours => 'ساعات العمل';

  @override
  String get working_days => 'أيام العمل';

  @override
  String get closed => 'مغلق';

  @override
  String get open_now => 'مفتوح الآن';

  @override
  String get overview => 'نظرة عامة';

  @override
  String get choose_package => 'اختر الباقة';

  @override
  String get what_is_included => 'ما الذي يشمله';

  @override
  String get customer_reviews => 'تقييمات العملاء';

  @override
  String get view_details => 'عرض التفاصيل';

  @override
  String get meet_our_workers => 'تعرّف على فريق عملنا';

  @override
  String get years_of_experience => 'سنوات الخبرة';

  @override
  String get close => 'إغلاق';

  @override
  String get no_available_dates => 'لا توجد مواعيد متاحة';

  @override
  String get no_available_dates_message =>
      'لا توجد حاليًا مواعيد متاحة لهذه الباقة. يُرجى المحاولة لاحقًا أو اختيار باقة أخرى.';

  @override
  String get no_available_times => 'لا توجد أوقات متاحة';

  @override
  String get no_available_times_message =>
      'لا توجد حاليًا أوقات متاحة لهذا التاريخ. يُرجى المحاولة لاحقًا أو اختيار تاريخ آخر.';

  @override
  String get order_details => 'تفاصيل الطلب';

  @override
  String get order_not_found => 'لم يتم العثور على الطلب';

  @override
  String get cancel_order => 'إلغاء الطلب';

  @override
  String get cancel_order_confirmation =>
      'هل أنت متأكد من رغبتك في إلغاء هذا الطلب؟';

  @override
  String get order_canceled_successfully => 'تم إلغاء الطلب بنجاح';

  @override
  String get location => 'الموقع';

  @override
  String get note => 'الملاحظة';

  @override
  String get duration => 'المدة';

  @override
  String get minutes => 'دقيقة';

  @override
  String get total_price => 'السعر الإجمالي';

  @override
  String get start_time => 'وقت البدء';

  @override
  String get end_time => 'وقت الانتهاء';

  @override
  String get company_location => 'موقع الشركة';

  @override
  String get package_details => 'تفاصيل الباقة';

  @override
  String get attributes => 'الخصائص';

  @override
  String get booking_in_progress => 'جارٍ الحجز...';

  @override
  String get before_and_after => 'قبل وبعد';

  @override
  String get add_review => 'إضافة تقييم';

  @override
  String get write_review => 'اكتب تقييماً';

  @override
  String get rating_required => 'يرجى اختيار التقييم';

  @override
  String get review_comment_hint => 'شارك تجربتك (اختياري)';

  @override
  String get submit_review => 'إرسال التقييم';

  @override
  String get review_submitted => 'تم إرسال التقييم بنجاح';

  @override
  String get day_monday => 'الاثنين';

  @override
  String get day_tuesday => 'الثلاثاء';

  @override
  String get day_wednesday => 'الأربعاء';

  @override
  String get day_thursday => 'الخميس';

  @override
  String get day_friday => 'الجمعة';

  @override
  String get day_saturday => 'السبت';

  @override
  String get day_sunday => 'الأحد';

  @override
  String get no_service_reviews_yet => 'لا توجد تقييمات للخدمات بعد';

  @override
  String get service_reviews_will_appear_here => 'ستظهر تقييماتك للخدمات هنا.';

  @override
  String get no_company_reviews_yet => 'لا توجد تقييمات للشركات بعد';

  @override
  String get company_reviews_will_appear_here => 'ستظهر تقييماتك للشركات هنا.';

  @override
  String get no_comment => 'لا يوجد تعليق';

  @override
  String get your_rating => 'تقييمك';

  @override
  String get reviewed_on => 'تم التقييم في';

  @override
  String get could_not_load_your_reviews => 'تعذر تحميل تقييماتك';

  @override
  String get could_not_load_profile_summary => 'تعذر تحميل ملخص الملف الشخصي';

  @override
  String get failed_to_delete_account =>
      'تعذر حذف حسابك. يرجى المحاولة مرة أخرى.';

  @override
  String get complaints => 'الشكاوى';

  @override
  String get service_complaints => 'الخدمات';

  @override
  String get company_complaints => 'الشركات';

  @override
  String get submit_complaint => 'تقديم شكوى';

  @override
  String get complaint_subject => 'عنوان الشكوى';

  @override
  String get complaint_message => 'تفاصيل الشكوى';

  @override
  String get complaint_details => 'تفاصيل الشكوى';

  @override
  String get complaint_replies => 'الردود';

  @override
  String get no_complaint_replies => 'لا توجد ردود بعد';

  @override
  String get no_complaints_found => 'لا توجد شكاوى';

  @override
  String get could_not_load_complaints => 'تعذر تحميل الشكاوى';

  @override
  String get could_not_load_more_complaints => 'تعذر تحميل المزيد من الشكاوى';

  @override
  String get complaint_submitted_successfully => 'تم تقديم الشكوى بنجاح';

  @override
  String get complaint_pending => 'قيد الانتظار';

  @override
  String get complaint_replied => 'تم الرد';

  @override
  String get complaint_reviewed => 'تمت المراجعة';

  @override
  String get company_manager_label => 'مدير الشركة';

  @override
  String get support_team_label => 'فريق دعم كلين لينك';

  @override
  String get complaint_message_too_short =>
      'يجب ألا تقل تفاصيل الشكوى عن 10 أحرف';

  @override
  String get required_field => 'هذا الحقل مطلوب';

  @override
  String get submit => 'إرسال';

  @override
  String get minimum_price => 'الحد الأدنى للسعر';

  @override
  String get maximum_price => 'الحد الأعلى للسعر';

  @override
  String get invalid_price_range =>
      'لا يمكن أن يكون الحد الأدنى للسعر أكبر من الحد الأعلى';

  @override
  String get could_not_load_more_offers => 'تعذر تحميل المزيد من العروض';

  @override
  String get service_location => 'موقع الخدمة';

  @override
  String get select_location => 'اختيار الموقع';

  @override
  String get selected_location => 'الموقع المحدد';

  @override
  String get confirm_location => 'تأكيد الموقع';

  @override
  String get choose_location_on_map => 'اختر موقعاً على الخريطة';

  @override
  String get change_location => 'تغيير الموقع';

  @override
  String get select => 'اختيار';

  @override
  String get move_map_to_select_location =>
      'حرّك الخريطة لاختيار موقع الخدمة بدقة.';

  @override
  String get loading_address => 'جارٍ تحميل العنوان...';

  @override
  String get address_unavailable => 'العنوان غير متاح. أدخل العنوان يدوياً.';

  @override
  String get use_current_location => 'استخدام موقعي الحالي';

  @override
  String get location_permission_denied_message =>
      'يلزم إذن الموقع لتحديد موقعك الحالي. لا يزال بإمكانك اختيار الموقع يدوياً من الخريطة.';

  @override
  String get location_permission_denied_forever_message =>
      'إذن الموقع معطّل لتطبيق كلين لينك. فعّله من إعدادات التطبيق أو اختر الموقع يدوياً.';

  @override
  String get location_service_disabled_message =>
      'فعّل خدمة الموقع في جهازك لاستخدام موقعك الحالي. لا يزال بإمكانك اختيار الموقع يدوياً.';

  @override
  String get continue_manually => 'المتابعة يدوياً';

  @override
  String get open_location_settings => 'فتح إعدادات الموقع';

  @override
  String get try_again => 'المحاولة مجدداً';

  @override
  String get please_select_service_location => 'يرجى اختيار موقع الخدمة.';

  @override
  String get please_select_date => 'يرجى اختيار التاريخ.';

  @override
  String get please_select_available_time => 'يرجى اختيار وقت متاح.';

  @override
  String get no_available_slots_for_location =>
      'لا توجد أوقات متاحة لهذا الموقع';

  @override
  String get no_available_slots_for_location_message =>
      'لم يتم العثور على أوقات متاحة لهذا الموقع. جرّب تاريخاً أو موقعاً آخر.';

  @override
  String get company_location_missing => 'لم تقم الشركة بإعداد موقعها بعد.';

  @override
  String get travel_time_temporarily_unavailable =>
      'وقت التنقل غير متاح مؤقتاً. أعد المحاولة دون تغيير اختيارك.';

  @override
  String get route_unavailable_for_location =>
      'مسار القيادة غير متاح لهذا الموقع. يرجى اختيار موقع آخر.';

  @override
  String get no_qualified_workgroup =>
      'لا توجد حالياً مجموعة عمل مؤهلة لهذه الباقة.';

  @override
  String get travel_allocation => 'الوقت المخصص للتنقل';

  @override
  String get worker_return => 'عودة العامل';

  @override
  String get my_locations => 'مواقعي';

  @override
  String get saved_locations => 'المواقع المحفوظة';

  @override
  String get add_location => 'إضافة موقع';

  @override
  String get edit_location => 'تعديل الموقع';

  @override
  String get delete_location => 'حذف الموقع';

  @override
  String get delete_location_confirmation =>
      'هل أنت متأكد من حذف هذا الموقع المحفوظ؟';

  @override
  String get location_name => 'اسم الموقع';

  @override
  String get location_name_hint => 'مثلاً المنزل أو العمل (اختياري)';

  @override
  String get location_coordinates => 'الإحداثيات';

  @override
  String get location_added_successfully => 'تمت إضافة الموقع بنجاح';

  @override
  String get location_updated_successfully => 'تم تحديث الموقع بنجاح';

  @override
  String get location_deleted_successfully => 'تم حذف الموقع بنجاح';

  @override
  String get no_saved_locations => 'لا توجد مواقع محفوظة';

  @override
  String get no_saved_locations_message => 'ليس لديك أي مواقع محفوظة بعد.';

  @override
  String get could_not_load_locations => 'تعذر تحميل مواقعك';

  @override
  String get choose_another_location => 'اختيار موقع آخر على الخريطة';

  @override
  String get add_new_saved_location => 'إضافة موقع محفوظ جديد';

  @override
  String get select_service_location => 'اختيار موقع الخدمة';

  @override
  String get save_location => 'حفظ الموقع';

  @override
  String get update_location => 'تحديث الموقع';

  @override
  String get cached_locations_warning =>
      'يتم عرض المواقع المحفوظة على هذا الجهاز. اسحب لإعادة المحاولة.';

  @override
  String get map_address_not_saved =>
      'يحفظ الخادم عنوان الخريطة والإحداثيات، ويبقى اسم الموقع على هذا الجهاز.';

  @override
  String get travel_considered_message =>
      'يتم احتساب وقت التنقل مسبقاً عند تحديد الأوقات المتاحة.';

  @override
  String get saved_location => 'موقع محفوظ';

  @override
  String get customize_your_service => 'خصّص خدمتك';

  @override
  String get no_attributes_available => 'لا تتوفر خيارات تخصيص.';

  @override
  String get increase => 'زيادة';

  @override
  String get decrease => 'تقليل';

  @override
  String get estimated_price => 'السعر التقديري';

  @override
  String get estimated_duration => 'المدة التقديرية';

  @override
  String get calculating => 'جارٍ الحساب…';

  @override
  String get check_price_duration => 'تحقق من السعر والمدة';

  @override
  String get checking_price_duration => 'جارٍ التحقق…';

  @override
  String get please_check_price_duration_again =>
      'يرجى التحقق من السعر والمدة للإعداد الحالي أولاً.';

  @override
  String get selected_configuration => 'الإعداد المختار';

  @override
  String get on_the_way => 'في الطريق';
}

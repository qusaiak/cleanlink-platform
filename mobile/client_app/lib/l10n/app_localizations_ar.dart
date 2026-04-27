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
  String get profile => 'الملف الشخصي';

  @override
  String get error_connection_timeout =>
      'انتهت مهلة الاتصال. يرجى المحاولة مرة أخرى.';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get logging_in => 'جاري تسجيل الدخول…';

  @override
  String get successful_login_message => 'تم تسجيل الدخول بنجاح';

  @override
  String get successful_registration_message => 'تم إنشاء الحساب بنجاح';

  @override
  String get personal_details => 'معلومات شخصية';

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
}

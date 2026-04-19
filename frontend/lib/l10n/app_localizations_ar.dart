// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'سند';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get dashboardSubtitle => 'مواردك وفوائدك التي يمكن الوصول إليها.';

  @override
  String get quickActions => 'إجراءات سريعة';

  @override
  String get findJobs => 'البحث عن وظائف';

  @override
  String get findDoctor => 'ابحث عن طبيب';

  @override
  String get requestBook => 'اطلب كتاباً';

  @override
  String get signLanguage => 'لغة الإشارة';

  @override
  String get opportunities => 'الفرص';

  @override
  String get viewAllJobs => 'عرض جميع الوظائف';

  @override
  String get verifiedAccessible => 'موثق لسهولة الوصول';

  @override
  String get viewDetails => 'عرض التفاصيل';

  @override
  String get medicalNetwork => 'الشبكة الطبية';

  @override
  String get findCare => 'البحث عن الرعاية';

  @override
  String reviews(num count) {
    return '$count مراجعات';
  }

  @override
  String get book => 'حجز';

  @override
  String get learnAndGrow => 'تعلم وانمو';

  @override
  String get browseBooks => 'تصفح الكتب';

  @override
  String get audioBook => 'كتاب صوتي';

  @override
  String get braille => 'برايل';

  @override
  String get eBook => 'كتاب إلكتروني';

  @override
  String get largePrint => 'خط كبير';

  @override
  String get tapToSign => 'اضغط على الزر ووقع رسالتك';

  @override
  String get translateNow => 'ترجم الآن';

  @override
  String get home => 'الرئيسية';

  @override
  String get translator => 'المترجم';

  @override
  String get settings => 'الإعدادات';

  @override
  String get welcomeTitle => 'رفيق';

  @override
  String get welcomeSubtitle =>
      'شريكك الداعم للحياة اليومية. يربطك بالرعاية والمجتمع والثقة.';

  @override
  String get emailAddress => 'عنوان البريد الإلكتروني';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get password => 'كلمة المرور';

  @override
  String get passwordHint => 'أدخل كلمة المرور الخاصة بك';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get noAccount => 'ليس لديك حساب؟';

  @override
  String get createOne => 'أنشئ حساباً';

  @override
  String get dataSecure => '🔒 بياناتك آمنة وخاصة';

  @override
  String get welcomeBack => 'مرحباً بعودتك';

  @override
  String get fillFields => 'يرجى ملء جميع الحقول';

  @override
  String get searchBooks => 'البحث عن كتب...';

  @override
  String get availableFormats => 'متوفر بتنسيقات متعددة';

  @override
  String get availableFormatsSubtitle =>
      'اطلب أي كتاب بتنسيق صوتي أو برايل أو خط كبير أو كتاب إلكتروني.';

  @override
  String get allFormats => 'جميع التنسيقات';

  @override
  String get searchJobs => 'البحث عن وظائف...';

  @override
  String get uploadCV => 'ارفع سيرتك الذاتية';

  @override
  String get uploadCVSubtitle =>
      'دعنا نوفقك مع الوظائف المناسبة التي يمكن الوصول إليها';

  @override
  String get uploadCVButton => 'رفع السيرة الذاتية';

  @override
  String get allJobs => 'جميع الوظائف';

  @override
  String get remote => 'عن بعد';

  @override
  String get fullTime => 'دوام كامل';

  @override
  String get hybrid => 'هجين';

  @override
  String get contract => 'عقد';

  @override
  String get partTime => 'دوام جزئي';

  @override
  String availableJobsCount(num count) {
    return '$count وظائف متاحة';
  }

  @override
  String get verified => 'موثق';

  @override
  String get applyNow => 'قدم الآن';

  @override
  String get searchSpecialists => 'البحث عن متخصصين...';

  @override
  String get all => 'الكل';

  @override
  String get neurology => 'مخ وأعصاب';

  @override
  String get physical => 'علاج طبيعي';

  @override
  String get occupational => 'علاج وظيفي';

  @override
  String get speech => 'تخاطب';

  @override
  String get neurologySpecialist => 'أخصائي مخ وأعصاب';

  @override
  String get physicalTherapy => 'علاج طبيعي';

  @override
  String get occupationalTherapy => 'علاج وظيفي';

  @override
  String get wheelchairAccess => 'مدخل كراسي متحركة';

  @override
  String get audioAids => 'وسائل مساعدة سمعية';

  @override
  String get bookAppointment => 'حجز موعد';

  @override
  String get upcomingEvents => 'الفعاليات القادمة';

  @override
  String get noUpcomingEvents => 'لا توجد فعاليات قادمة';

  @override
  String get register => 'تسجيل';

  @override
  String copiedToClipboard(String text) {
    return 'تم نسخ $text إلى الحافظة';
  }

  @override
  String get noContactEmail => 'لا يوجد بريد إلكتروني للتواصل';

  @override
  String get myMedications => 'أدويتي';

  @override
  String get noMedicationReminders => 'لا توجد تذكيرات بالأدوية';

  @override
  String get addFirstReminder => 'أضف تذكيرك الأول';

  @override
  String get addMedication => 'إضافة دواء';

  @override
  String get medicationDetails => 'تفاصيل الدواء';

  @override
  String get medicationName => 'اسم الدواء';

  @override
  String get medicationNameHint => 'مثلاً: فيتامين د';

  @override
  String get dosageOptional => 'الجرعة (اختياري)';

  @override
  String get dosageHint => 'مثلاً: قرص واحد، 500 ملغ';

  @override
  String get reminderTime => 'وقت التذكير';

  @override
  String get saveReminder => 'حفظ التذكير';

  @override
  String get enterMedicationName => 'يرجى إدخال اسم الدواء';

  @override
  String get communityServices => 'الخدمات المجتمعية';

  @override
  String get offerHelp => 'تقديم المساعدة';

  @override
  String get serviceTitle => 'عنوان الخدمة';

  @override
  String get description => 'الوصف';

  @override
  String get category => 'الفئة';

  @override
  String get yourName => 'اسمك';

  @override
  String get contactEmail => 'البريد الإلكتروني للتواصل';

  @override
  String get cancel => 'إلغاء';

  @override
  String get submit => 'إرسال';

  @override
  String get serviceOfferedSuccess => 'تم تقديم الخدمة بنجاح!';

  @override
  String get noServicesAvailable => 'لا توجد خدمات متاحة';

  @override
  String get requestHelp => 'طلب مساعدة';

  @override
  String get currentlyUnavailable => 'غير متاح حالياً';

  @override
  String get readFullStory => 'اقرأ القصة كاملة';
}

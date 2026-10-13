// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Logic 42';

  @override
  String get continueLabel => 'متابعة';

  @override
  String get onboardingTitle => 'اعثر على القاعدة المخفية';

  @override
  String get onboardingBody =>
      'خمس صفوف مكتملة تعرض نمطاً. أدخل الناتج الناقص في الصف السادس. كل رقم يبقى بين 1 و42.';

  @override
  String get homeTitle => 'الرئيسية';

  @override
  String get classic => 'كلاسيكي';

  @override
  String get daily => 'يومي';

  @override
  String get speed => 'سرعة';

  @override
  String get discovery => 'اكتشاف';

  @override
  String get stats => 'إحصاءات';

  @override
  String get achievements => 'شارات';

  @override
  String get settings => 'الإعدادات';

  @override
  String get profile => 'الملف';

  @override
  String get about => 'حول';

  @override
  String get privacy => 'الخصوصية';

  @override
  String get terms => 'الشروط';

  @override
  String get worlds => 'العوالم';

  @override
  String get worldBasicPatterns => 'أنماط أساسية';

  @override
  String get worldModularRules => 'قواعد معيارية';

  @override
  String get worldNumberGroups => 'مجموعات عددية';

  @override
  String get worldPrimeLogic => 'منطق الأعداد الأولية';

  @override
  String get worldFortyTwoSymmetry => 'تناظر 42';

  @override
  String get worldMetaRules => 'قواعد مركبة';

  @override
  String get submit => 'إرسال';

  @override
  String get delete => 'حذف';

  @override
  String get pause => 'إيقاف';

  @override
  String get resume => 'استئناف';

  @override
  String get hint => 'تلميح';

  @override
  String get giveUp => 'استسلام';

  @override
  String get nextPuzzle => 'اللغز التالي';

  @override
  String get solution => 'الحل المفصل';

  @override
  String get correct => 'صحيح';

  @override
  String get incorrect => 'ليس بعد. حاول مرة أخرى.';

  @override
  String get xpEarned => 'نقاط الخبرة';

  @override
  String level(int n) {
    return 'المستوى $n';
  }

  @override
  String get theme => 'المظهر';

  @override
  String get sound => 'الصوت';

  @override
  String get haptics => 'الاهتزاز';

  @override
  String get reduceMotion => 'تقليل الحركة';

  @override
  String get highContrast => 'تباين عالٍ';

  @override
  String get signInUpgrade => 'ربط الحساب (اختياري)';

  @override
  String get offlineAccount => 'اللعب دون اتصال بملف محلي.';

  @override
  String get premiumTitle => 'بريميوم';

  @override
  String get premiumBody => 'الشراء غير مفعّل في هذا الإصدار.';

  @override
  String get legalPlaceholder =>
      'سيستبدل مالك المشروع هذا النص القانوني. لا يقدم هذا الشاشة ضمانات قانونية.';

  @override
  String get enterNumber => 'أدخل رقماً من 1 إلى 42';

  @override
  String cellLabel(int row, String col) {
    return 'صف $row، عمود $col';
  }

  @override
  String get resultColumn => 'الناتج';

  @override
  String get attempts => 'محاولات';

  @override
  String get hintsUsed => 'تلميحات';

  @override
  String get bestTime => 'أفضل وقت';

  @override
  String get streak => 'سلسلة';

  @override
  String get xp => 'خبرة';

  @override
  String get play => 'العب';

  @override
  String get locked => 'مقفل';

  @override
  String get practice => 'تدريب';

  @override
  String get rankedUsed =>
      'المحاولة المصنفة لليوم استُخدمت. التدريب ما زال متاحاً.';

  @override
  String get speedStart => 'ابدأ جولة من 5 ألغاز';

  @override
  String get speedPaused => 'توقف المؤقت في الخلفية. وقت الخلفية لا يُحسب.';

  @override
  String get skipOnboarding => 'تخطي';

  @override
  String get splashTagline => 'أنماط من 1 إلى 42';
}

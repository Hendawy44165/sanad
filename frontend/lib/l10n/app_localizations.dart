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

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Sanad'**
  String get appTitle;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @dashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your accessible resources and benefits.'**
  String get dashboardSubtitle;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @findJobs.
  ///
  /// In en, this message translates to:
  /// **'Find Jobs'**
  String get findJobs;

  /// No description provided for @findDoctor.
  ///
  /// In en, this message translates to:
  /// **'Find a Doctor'**
  String get findDoctor;

  /// No description provided for @requestBook.
  ///
  /// In en, this message translates to:
  /// **'Request a Book'**
  String get requestBook;

  /// No description provided for @signLanguage.
  ///
  /// In en, this message translates to:
  /// **'Sign Language'**
  String get signLanguage;

  /// No description provided for @opportunities.
  ///
  /// In en, this message translates to:
  /// **'Opportunities'**
  String get opportunities;

  /// No description provided for @viewAllJobs.
  ///
  /// In en, this message translates to:
  /// **'VIEW ALL JOBS'**
  String get viewAllJobs;

  /// No description provided for @verifiedAccessible.
  ///
  /// In en, this message translates to:
  /// **'Verified Accessible'**
  String get verifiedAccessible;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @medicalNetwork.
  ///
  /// In en, this message translates to:
  /// **'Medical Network'**
  String get medicalNetwork;

  /// No description provided for @findCare.
  ///
  /// In en, this message translates to:
  /// **'FIND CARE'**
  String get findCare;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'{count} reviews'**
  String reviews(num count);

  /// No description provided for @book.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get book;

  /// No description provided for @learnAndGrow.
  ///
  /// In en, this message translates to:
  /// **'Learn & Grow'**
  String get learnAndGrow;

  /// No description provided for @browseBooks.
  ///
  /// In en, this message translates to:
  /// **'BROWSE BOOKS'**
  String get browseBooks;

  /// No description provided for @audioBook.
  ///
  /// In en, this message translates to:
  /// **'Audio Book'**
  String get audioBook;

  /// No description provided for @braille.
  ///
  /// In en, this message translates to:
  /// **'Braille'**
  String get braille;

  /// No description provided for @eBook.
  ///
  /// In en, this message translates to:
  /// **'E-Book'**
  String get eBook;

  /// No description provided for @largePrint.
  ///
  /// In en, this message translates to:
  /// **'Large Print'**
  String get largePrint;

  /// No description provided for @tapToSign.
  ///
  /// In en, this message translates to:
  /// **'Tap the button and sign your message'**
  String get tapToSign;

  /// No description provided for @translateNow.
  ///
  /// In en, this message translates to:
  /// **'TRANSLATE NOW'**
  String get translateNow;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @translator.
  ///
  /// In en, this message translates to:
  /// **'Translator'**
  String get translator;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Companion'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your supportive partner for everyday life. Connecting you with care, community, and confidence.'**
  String get welcomeSubtitle;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get emailHint;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @createOne.
  ///
  /// In en, this message translates to:
  /// **'Create one'**
  String get createOne;

  /// No description provided for @dataSecure.
  ///
  /// In en, this message translates to:
  /// **'🔒 Your data is secure and private'**
  String get dataSecure;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @fillFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields'**
  String get fillFields;

  /// No description provided for @searchBooks.
  ///
  /// In en, this message translates to:
  /// **'Search books...'**
  String get searchBooks;

  /// No description provided for @availableFormats.
  ///
  /// In en, this message translates to:
  /// **'Available in Multiple Formats'**
  String get availableFormats;

  /// No description provided for @availableFormatsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Request any book in audio, Braille, large print, or e-book format.'**
  String get availableFormatsSubtitle;

  /// No description provided for @allFormats.
  ///
  /// In en, this message translates to:
  /// **'All Formats'**
  String get allFormats;

  /// No description provided for @searchJobs.
  ///
  /// In en, this message translates to:
  /// **'Search jobs...'**
  String get searchJobs;

  /// No description provided for @uploadCV.
  ///
  /// In en, this message translates to:
  /// **'Upload Your CV'**
  String get uploadCV;

  /// No description provided for @uploadCVSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Let us match you with the right accessible jobs'**
  String get uploadCVSubtitle;

  /// No description provided for @uploadCVButton.
  ///
  /// In en, this message translates to:
  /// **'Upload CV'**
  String get uploadCVButton;

  /// No description provided for @allJobs.
  ///
  /// In en, this message translates to:
  /// **'All Jobs'**
  String get allJobs;

  /// No description provided for @remote.
  ///
  /// In en, this message translates to:
  /// **'Remote'**
  String get remote;

  /// No description provided for @fullTime.
  ///
  /// In en, this message translates to:
  /// **'Full-Time'**
  String get fullTime;

  /// No description provided for @hybrid.
  ///
  /// In en, this message translates to:
  /// **'Hybrid'**
  String get hybrid;

  /// No description provided for @contract.
  ///
  /// In en, this message translates to:
  /// **'Contract'**
  String get contract;

  /// No description provided for @partTime.
  ///
  /// In en, this message translates to:
  /// **'Part-Time'**
  String get partTime;

  /// No description provided for @availableJobsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Available Jobs'**
  String availableJobsCount(num count);

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @applyNow.
  ///
  /// In en, this message translates to:
  /// **'Apply Now'**
  String get applyNow;

  /// No description provided for @searchSpecialists.
  ///
  /// In en, this message translates to:
  /// **'Search specialists...'**
  String get searchSpecialists;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @neurology.
  ///
  /// In en, this message translates to:
  /// **'Neurology'**
  String get neurology;

  /// No description provided for @physical.
  ///
  /// In en, this message translates to:
  /// **'Physical'**
  String get physical;

  /// No description provided for @occupational.
  ///
  /// In en, this message translates to:
  /// **'Occupational'**
  String get occupational;

  /// No description provided for @speech.
  ///
  /// In en, this message translates to:
  /// **'Speech'**
  String get speech;

  /// No description provided for @neurologySpecialist.
  ///
  /// In en, this message translates to:
  /// **'Neurology Specialist'**
  String get neurologySpecialist;

  /// No description provided for @physicalTherapy.
  ///
  /// In en, this message translates to:
  /// **'Physical Therapy'**
  String get physicalTherapy;

  /// No description provided for @occupationalTherapy.
  ///
  /// In en, this message translates to:
  /// **'Occupational Therapy'**
  String get occupationalTherapy;

  /// No description provided for @wheelchairAccess.
  ///
  /// In en, this message translates to:
  /// **'Wheelchair Access'**
  String get wheelchairAccess;

  /// No description provided for @audioAids.
  ///
  /// In en, this message translates to:
  /// **'Audio Aids'**
  String get audioAids;

  /// No description provided for @bookAppointment.
  ///
  /// In en, this message translates to:
  /// **'Book Appointment'**
  String get bookAppointment;

  /// No description provided for @upcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Events'**
  String get upcomingEvents;

  /// No description provided for @noUpcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'No upcoming events'**
  String get noUpcomingEvents;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied {text} to clipboard'**
  String copiedToClipboard(String text);

  /// No description provided for @noContactEmail.
  ///
  /// In en, this message translates to:
  /// **'No contact email available'**
  String get noContactEmail;

  /// No description provided for @myMedications.
  ///
  /// In en, this message translates to:
  /// **'My Medications'**
  String get myMedications;

  /// No description provided for @noMedicationReminders.
  ///
  /// In en, this message translates to:
  /// **'No medication reminders'**
  String get noMedicationReminders;

  /// No description provided for @addFirstReminder.
  ///
  /// In en, this message translates to:
  /// **'Add your first reminder'**
  String get addFirstReminder;

  /// No description provided for @addMedication.
  ///
  /// In en, this message translates to:
  /// **'Add Medication'**
  String get addMedication;

  /// No description provided for @medicationDetails.
  ///
  /// In en, this message translates to:
  /// **'Medication Details'**
  String get medicationDetails;

  /// No description provided for @medicationName.
  ///
  /// In en, this message translates to:
  /// **'Medication Name'**
  String get medicationName;

  /// No description provided for @medicationNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Vitamin D'**
  String get medicationNameHint;

  /// No description provided for @dosageOptional.
  ///
  /// In en, this message translates to:
  /// **'Dosage (Optional)'**
  String get dosageOptional;

  /// No description provided for @dosageHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 1 tablet, 500mg'**
  String get dosageHint;

  /// No description provided for @reminderTime.
  ///
  /// In en, this message translates to:
  /// **'Reminder Time'**
  String get reminderTime;

  /// No description provided for @saveReminder.
  ///
  /// In en, this message translates to:
  /// **'Save Reminder'**
  String get saveReminder;

  /// No description provided for @enterMedicationName.
  ///
  /// In en, this message translates to:
  /// **'Please enter medication name'**
  String get enterMedicationName;

  /// No description provided for @communityServices.
  ///
  /// In en, this message translates to:
  /// **'Community Services'**
  String get communityServices;

  /// No description provided for @offerHelp.
  ///
  /// In en, this message translates to:
  /// **'Offer Help'**
  String get offerHelp;

  /// No description provided for @serviceTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Title'**
  String get serviceTitle;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get yourName;

  /// No description provided for @contactEmail.
  ///
  /// In en, this message translates to:
  /// **'Contact Email'**
  String get contactEmail;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @serviceOfferedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Service offered successfully!'**
  String get serviceOfferedSuccess;

  /// No description provided for @noServicesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No services available'**
  String get noServicesAvailable;

  /// No description provided for @requestHelp.
  ///
  /// In en, this message translates to:
  /// **'Request Help'**
  String get requestHelp;

  /// No description provided for @currentlyUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Currently Unavailable'**
  String get currentlyUnavailable;

  /// No description provided for @readFullStory.
  ///
  /// In en, this message translates to:
  /// **'Read Full Story'**
  String get readFullStory;
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

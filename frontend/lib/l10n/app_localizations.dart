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

  /// No description provided for @requestBookShort.
  ///
  /// In en, this message translates to:
  /// **'Request Book'**
  String get requestBookShort;

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

  /// No description provided for @jobs.
  ///
  /// In en, this message translates to:
  /// **'Jobs'**
  String get jobs;

  /// No description provided for @doctors.
  ///
  /// In en, this message translates to:
  /// **'Doctors'**
  String get doctors;

  /// No description provided for @books.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get books;

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

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

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
  /// **'Create account'**
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

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get profileTitle;

  /// No description provided for @verifiedMember.
  ///
  /// In en, this message translates to:
  /// **'Verified Member'**
  String get verifiedMember;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationsOn.
  ///
  /// In en, this message translates to:
  /// **'You will receive all app notifications'**
  String get notificationsOn;

  /// No description provided for @notificationsOff.
  ///
  /// In en, this message translates to:
  /// **'Notifications are turned off'**
  String get notificationsOff;

  /// No description provided for @myCV.
  ///
  /// In en, this message translates to:
  /// **'My CV'**
  String get myCV;

  /// No description provided for @noCvUploaded.
  ///
  /// In en, this message translates to:
  /// **'No CV uploaded yet'**
  String get noCvUploaded;

  /// No description provided for @noCvSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload your CV to find accessible jobs faster'**
  String get noCvSubtitle;

  /// No description provided for @cvUploaded.
  ///
  /// In en, this message translates to:
  /// **'CV Uploaded'**
  String get cvUploaded;

  /// No description provided for @cvUploadedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your CV is active and visible to employers'**
  String get cvUploadedSubtitle;

  /// No description provided for @reuploadCV.
  ///
  /// In en, this message translates to:
  /// **'Re-upload CV'**
  String get reuploadCV;

  /// No description provided for @cvUploadedSuccess.
  ///
  /// In en, this message translates to:
  /// **'CV uploaded successfully!'**
  String get cvUploadedSuccess;

  /// No description provided for @cvUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'CV upload failed. Please try again.'**
  String get cvUploadFailed;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get logout;

  /// No description provided for @editName.
  ///
  /// In en, this message translates to:
  /// **'Edit Name'**
  String get editName;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterName;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @err_anonymousProviderDisabled.
  ///
  /// In en, this message translates to:
  /// **'Anonymous sign-ins are disabled.'**
  String get err_anonymousProviderDisabled;

  /// No description provided for @err_badCodeVerifier.
  ///
  /// In en, this message translates to:
  /// **'Invalid code verifier. Please try again.'**
  String get err_badCodeVerifier;

  /// No description provided for @err_badJson.
  ///
  /// In en, this message translates to:
  /// **'Invalid request format.'**
  String get err_badJson;

  /// No description provided for @err_badJwt.
  ///
  /// In en, this message translates to:
  /// **'Invalid authentication token.'**
  String get err_badJwt;

  /// No description provided for @err_badOauthCallback.
  ///
  /// In en, this message translates to:
  /// **'OAuth authentication failed. Please try again.'**
  String get err_badOauthCallback;

  /// No description provided for @err_badOauthState.
  ///
  /// In en, this message translates to:
  /// **'OAuth state is invalid. Please try again.'**
  String get err_badOauthState;

  /// No description provided for @err_captchaFailed.
  ///
  /// In en, this message translates to:
  /// **'CAPTCHA verification failed. Please try again.'**
  String get err_captchaFailed;

  /// No description provided for @err_conflict.
  ///
  /// In en, this message translates to:
  /// **'A conflict occurred. Please try again.'**
  String get err_conflict;

  /// No description provided for @err_couldNotAddElevenLabsApiKey.
  ///
  /// In en, this message translates to:
  /// **'Could not add ElevenLabs API key. Please try again.'**
  String get err_couldNotAddElevenLabsApiKey;

  /// No description provided for @err_couldNotDeleteElevenLabsApiKey.
  ///
  /// In en, this message translates to:
  /// **'Could not delete ElevenLabs API key. Please try again.'**
  String get err_couldNotDeleteElevenLabsApiKey;

  /// No description provided for @err_couldNotGetElevenLabsApiKeys.
  ///
  /// In en, this message translates to:
  /// **'Could not retrieve ElevenLabs API keys. Please try again.'**
  String get err_couldNotGetElevenLabsApiKeys;

  /// No description provided for @err_emailAddressInvalid.
  ///
  /// In en, this message translates to:
  /// **'Email address is invalid. Please use a valid email.'**
  String get err_emailAddressInvalid;

  /// No description provided for @err_emailAddressNotAuthorized.
  ///
  /// In en, this message translates to:
  /// **'This email address is not authorized.'**
  String get err_emailAddressNotAuthorized;

  /// No description provided for @err_emailConflictIdentityNotDeletable.
  ///
  /// In en, this message translates to:
  /// **'Cannot unlink this identity due to email conflict.'**
  String get err_emailConflictIdentityNotDeletable;

  /// No description provided for @err_emailExists.
  ///
  /// In en, this message translates to:
  /// **'Email address already exists in the system.'**
  String get err_emailExists;

  /// No description provided for @err_emailNotConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your email address before signing in.'**
  String get err_emailNotConfirmed;

  /// No description provided for @err_emailProviderDisabled.
  ///
  /// In en, this message translates to:
  /// **'Email sign-ups are currently disabled.'**
  String get err_emailProviderDisabled;

  /// No description provided for @err_flowStateExpired.
  ///
  /// In en, this message translates to:
  /// **'Authentication session expired. Please sign in again.'**
  String get err_flowStateExpired;

  /// No description provided for @err_flowStateNotFound.
  ///
  /// In en, this message translates to:
  /// **'Authentication session not found. Please sign in again.'**
  String get err_flowStateNotFound;

  /// No description provided for @err_googleIdTokenMissing.
  ///
  /// In en, this message translates to:
  /// **'Google ID token is missing. Please try signing in again.'**
  String get err_googleIdTokenMissing;

  /// No description provided for @err_googleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in failed. Please try again.'**
  String get err_googleSignInFailed;

  /// No description provided for @err_hookPayloadInvalidContentType.
  ///
  /// In en, this message translates to:
  /// **'Invalid webhook payload format.'**
  String get err_hookPayloadInvalidContentType;

  /// No description provided for @err_hookPayloadOverSizeLimit.
  ///
  /// In en, this message translates to:
  /// **'Webhook payload exceeds size limit.'**
  String get err_hookPayloadOverSizeLimit;

  /// No description provided for @err_hookTimeout.
  ///
  /// In en, this message translates to:
  /// **'Webhook request timed out.'**
  String get err_hookTimeout;

  /// No description provided for @err_hookTimeoutAfterRetry.
  ///
  /// In en, this message translates to:
  /// **'Webhook request failed after retries.'**
  String get err_hookTimeoutAfterRetry;

  /// No description provided for @err_identityAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'This identity is already linked to another user.'**
  String get err_identityAlreadyExists;

  /// No description provided for @err_identityNotFound.
  ///
  /// In en, this message translates to:
  /// **'Identity not found.'**
  String get err_identityNotFound;

  /// No description provided for @err_insufficientAal.
  ///
  /// In en, this message translates to:
  /// **'Additional authentication required. Please complete MFA.'**
  String get err_insufficientAal;

  /// No description provided for @err_invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password.'**
  String get err_invalidCredentials;

  /// No description provided for @err_inviteNotFound.
  ///
  /// In en, this message translates to:
  /// **'Invitation expired or already used.'**
  String get err_inviteNotFound;

  /// No description provided for @err_manualLinkingDisabled.
  ///
  /// In en, this message translates to:
  /// **'Manual account linking is disabled.'**
  String get err_manualLinkingDisabled;

  /// No description provided for @err_mfaChallengeExpired.
  ///
  /// In en, this message translates to:
  /// **'MFA challenge expired. Please request a new code.'**
  String get err_mfaChallengeExpired;

  /// No description provided for @err_mfaFactorNameConflict.
  ///
  /// In en, this message translates to:
  /// **'MFA factor name already exists. Choose a different name.'**
  String get err_mfaFactorNameConflict;

  /// No description provided for @err_mfaFactorNotFound.
  ///
  /// In en, this message translates to:
  /// **'MFA factor not found.'**
  String get err_mfaFactorNotFound;

  /// No description provided for @err_mfaIpAddressMismatch.
  ///
  /// In en, this message translates to:
  /// **'IP address mismatch during MFA enrollment.'**
  String get err_mfaIpAddressMismatch;

  /// No description provided for @err_mfaPhoneEnrollNotEnabled.
  ///
  /// In en, this message translates to:
  /// **'Phone MFA enrollment is disabled.'**
  String get err_mfaPhoneEnrollNotEnabled;

  /// No description provided for @err_mfaPhoneVerifyNotEnabled.
  ///
  /// In en, this message translates to:
  /// **'Phone MFA verification is disabled.'**
  String get err_mfaPhoneVerifyNotEnabled;

  /// No description provided for @err_mfaTotpEnrollNotEnabled.
  ///
  /// In en, this message translates to:
  /// **'TOTP MFA enrollment is disabled.'**
  String get err_mfaTotpEnrollNotEnabled;

  /// No description provided for @err_mfaTotpVerifyNotEnabled.
  ///
  /// In en, this message translates to:
  /// **'TOTP MFA verification is disabled.'**
  String get err_mfaTotpVerifyNotEnabled;

  /// No description provided for @err_mfaVerificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Incorrect MFA code. Please try again.'**
  String get err_mfaVerificationFailed;

  /// No description provided for @err_mfaVerificationRejected.
  ///
  /// In en, this message translates to:
  /// **'MFA verification rejected.'**
  String get err_mfaVerificationRejected;

  /// No description provided for @err_mfaVerifiedFactorExists.
  ///
  /// In en, this message translates to:
  /// **'A verified phone factor already exists.'**
  String get err_mfaVerifiedFactorExists;

  /// No description provided for @err_mfaWebAuthnEnrollNotEnabled.
  ///
  /// In en, this message translates to:
  /// **'WebAuthn MFA enrollment is disabled.'**
  String get err_mfaWebAuthnEnrollNotEnabled;

  /// No description provided for @err_mfaWebAuthnVerifyNotEnabled.
  ///
  /// In en, this message translates to:
  /// **'WebAuthn MFA verification is disabled.'**
  String get err_mfaWebAuthnVerifyNotEnabled;

  /// No description provided for @err_noAuthorization.
  ///
  /// In en, this message translates to:
  /// **'Authorization required.'**
  String get err_noAuthorization;

  /// No description provided for @err_notAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin access required.'**
  String get err_notAdmin;

  /// No description provided for @err_oauthProviderNotSupported.
  ///
  /// In en, this message translates to:
  /// **'OAuth provider is not supported.'**
  String get err_oauthProviderNotSupported;

  /// No description provided for @err_otpDisabled.
  ///
  /// In en, this message translates to:
  /// **'OTP sign-in is disabled.'**
  String get err_otpDisabled;

  /// No description provided for @err_otpExpired.
  ///
  /// In en, this message translates to:
  /// **'OTP code expired. Please request a new one.'**
  String get err_otpExpired;

  /// No description provided for @err_overEmailSendRateLimit.
  ///
  /// In en, this message translates to:
  /// **'Too many emails sent. Please try again later.'**
  String get err_overEmailSendRateLimit;

  /// No description provided for @err_overRequestRateLimit.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please try again later.'**
  String get err_overRequestRateLimit;

  /// No description provided for @err_overSmsSendRateLimit.
  ///
  /// In en, this message translates to:
  /// **'Too many SMS sent. Please try again later.'**
  String get err_overSmsSendRateLimit;

  /// No description provided for @err_phoneExists.
  ///
  /// In en, this message translates to:
  /// **'Phone number already exists in the system.'**
  String get err_phoneExists;

  /// No description provided for @err_phoneNotConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your phone number before signing in.'**
  String get err_phoneNotConfirmed;

  /// No description provided for @err_phoneProviderDisabled.
  ///
  /// In en, this message translates to:
  /// **'Phone sign-ups are currently disabled.'**
  String get err_phoneProviderDisabled;

  /// No description provided for @err_providerDisabled.
  ///
  /// In en, this message translates to:
  /// **'This authentication provider is disabled.'**
  String get err_providerDisabled;

  /// No description provided for @err_providerEmailNeedsVerification.
  ///
  /// In en, this message translates to:
  /// **'Email verification required from OAuth provider.'**
  String get err_providerEmailNeedsVerification;

  /// No description provided for @err_reauthenticationNeeded.
  ///
  /// In en, this message translates to:
  /// **'Please reauthenticate to continue.'**
  String get err_reauthenticationNeeded;

  /// No description provided for @err_reauthenticationNotValid.
  ///
  /// In en, this message translates to:
  /// **'Reauthentication failed. Please try again.'**
  String get err_reauthenticationNotValid;

  /// No description provided for @err_refreshTokenAlreadyUsed.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please sign in again.'**
  String get err_refreshTokenAlreadyUsed;

  /// No description provided for @err_refreshTokenNotFound.
  ///
  /// In en, this message translates to:
  /// **'Session not found. Please sign in again.'**
  String get err_refreshTokenNotFound;

  /// No description provided for @err_requestTimeout.
  ///
  /// In en, this message translates to:
  /// **'Request timed out. Please try again.'**
  String get err_requestTimeout;

  /// No description provided for @err_samePassword.
  ///
  /// In en, this message translates to:
  /// **'New password must be different from current password.'**
  String get err_samePassword;

  /// No description provided for @err_samlAssertionNoEmail.
  ///
  /// In en, this message translates to:
  /// **'No email found in SAML response.'**
  String get err_samlAssertionNoEmail;

  /// No description provided for @err_samlAssertionNoUserId.
  ///
  /// In en, this message translates to:
  /// **'No user ID found in SAML response.'**
  String get err_samlAssertionNoUserId;

  /// No description provided for @err_samlEntityIdMismatch.
  ///
  /// In en, this message translates to:
  /// **'SAML entity ID mismatch.'**
  String get err_samlEntityIdMismatch;

  /// No description provided for @err_samlIdpAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'SAML identity provider already exists.'**
  String get err_samlIdpAlreadyExists;

  /// No description provided for @err_samlIdpNotFound.
  ///
  /// In en, this message translates to:
  /// **'SAML identity provider not found.'**
  String get err_samlIdpNotFound;

  /// No description provided for @err_samlMetadataFetchFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch SAML metadata.'**
  String get err_samlMetadataFetchFailed;

  /// No description provided for @err_samlProviderDisabled.
  ///
  /// In en, this message translates to:
  /// **'SAML authentication is disabled.'**
  String get err_samlProviderDisabled;

  /// No description provided for @err_samlRelayStateExpired.
  ///
  /// In en, this message translates to:
  /// **'SAML authentication expired. Please sign in again.'**
  String get err_samlRelayStateExpired;

  /// No description provided for @err_samlRelayStateNotFound.
  ///
  /// In en, this message translates to:
  /// **'SAML authentication session not found. Please sign in again.'**
  String get err_samlRelayStateNotFound;

  /// No description provided for @err_sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please sign in again.'**
  String get err_sessionExpired;

  /// No description provided for @err_sessionNotFound.
  ///
  /// In en, this message translates to:
  /// **'Session not found. Please sign in again.'**
  String get err_sessionNotFound;

  /// No description provided for @err_signupDisabled.
  ///
  /// In en, this message translates to:
  /// **'Sign-ups are currently disabled.'**
  String get err_signupDisabled;

  /// No description provided for @err_singleIdentityNotDeletable.
  ///
  /// In en, this message translates to:
  /// **'Cannot delete your only authentication method.'**
  String get err_singleIdentityNotDeletable;

  /// No description provided for @err_smsSendFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send SMS. Please try again.'**
  String get err_smsSendFailed;

  /// No description provided for @err_ssoDomainAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'SSO domain already exists.'**
  String get err_ssoDomainAlreadyExists;

  /// No description provided for @err_ssoProviderNotFound.
  ///
  /// In en, this message translates to:
  /// **'SSO provider not found.'**
  String get err_ssoProviderNotFound;

  /// No description provided for @err_tooManyEnrolledMfaFactors.
  ///
  /// In en, this message translates to:
  /// **'Too many MFA factors enrolled.'**
  String get err_tooManyEnrolledMfaFactors;

  /// No description provided for @err_unexpectedAudience.
  ///
  /// In en, this message translates to:
  /// **'Unexpected token audience.'**
  String get err_unexpectedAudience;

  /// No description provided for @err_unexpectedFailure.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get err_unexpectedFailure;

  /// No description provided for @err_userAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'User already exists.'**
  String get err_userAlreadyExists;

  /// No description provided for @err_userBanned.
  ///
  /// In en, this message translates to:
  /// **'User account is temporarily banned.'**
  String get err_userBanned;

  /// No description provided for @err_userNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found.'**
  String get err_userNotFound;

  /// No description provided for @err_userSsoManaged.
  ///
  /// In en, this message translates to:
  /// **'User is managed by SSO.'**
  String get err_userSsoManaged;

  /// No description provided for @err_validationFailed.
  ///
  /// In en, this message translates to:
  /// **'Validation failed. Please check your input.'**
  String get err_validationFailed;

  /// No description provided for @err_weakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak. Please use a stronger password.'**
  String get err_weakPassword;

  /// No description provided for @err_unknown.
  ///
  /// In en, this message translates to:
  /// **'An error has occurred.'**
  String get err_unknown;

  /// No description provided for @loginSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Login Successful'**
  String get loginSuccessful;

  /// No description provided for @signUpSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Sign Up Successful'**
  String get signUpSuccessful;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get emailInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @firstNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your first name'**
  String get firstNameRequired;

  /// No description provided for @lastNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your last name'**
  String get lastNameRequired;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: '**
  String get errorPrefix;

  /// No description provided for @failedToPickImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image: '**
  String get failedToPickImage;

  /// No description provided for @onboardingWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome, Friend!'**
  String get onboardingWelcome;

  /// No description provided for @onboardingQuestion.
  ///
  /// In en, this message translates to:
  /// **'How can we best support you?'**
  String get onboardingQuestion;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select your primary need so we can personalize your experience and show relevant resources.'**
  String get onboardingSubtitle;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @changeAnytime.
  ///
  /// In en, this message translates to:
  /// **'You can change this anytime in settings'**
  String get changeAnytime;

  /// No description provided for @visualLabel.
  ///
  /// In en, this message translates to:
  /// **'Visual'**
  String get visualLabel;

  /// No description provided for @visualDesc.
  ///
  /// In en, this message translates to:
  /// **'Blindness, low vision, or color blindness'**
  String get visualDesc;

  /// No description provided for @hearingLabel.
  ///
  /// In en, this message translates to:
  /// **'Hearing'**
  String get hearingLabel;

  /// No description provided for @hearingDesc.
  ///
  /// In en, this message translates to:
  /// **'Deafness or hard of hearing'**
  String get hearingDesc;

  /// No description provided for @mobilityLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobility'**
  String get mobilityLabel;

  /// No description provided for @mobilityDesc.
  ///
  /// In en, this message translates to:
  /// **'Difficulty with movement or physical tasks'**
  String get mobilityDesc;

  /// No description provided for @cognitiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Cognitive'**
  String get cognitiveLabel;

  /// No description provided for @cognitiveDesc.
  ///
  /// In en, this message translates to:
  /// **'Learning, memory, or concentration challenges'**
  String get cognitiveDesc;

  /// No description provided for @chronicLabel.
  ///
  /// In en, this message translates to:
  /// **'Chronic Illness'**
  String get chronicLabel;

  /// No description provided for @chronicDesc.
  ///
  /// In en, this message translates to:
  /// **'Long-term health conditions'**
  String get chronicDesc;

  /// No description provided for @otherLabel.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get otherLabel;

  /// No description provided for @otherDesc.
  ///
  /// In en, this message translates to:
  /// **'Another type of disability or multiple'**
  String get otherDesc;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;
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

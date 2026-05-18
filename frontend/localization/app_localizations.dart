import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';

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
    Locale('en'),
    Locale('hi'),
    Locale('kn'),
    Locale('ta'),
    Locale('te'),
  ];

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'AQA SHRIMP AI'**
  String get appName;

  /// Login page welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// Login page subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue to AQA Shrimp AI'**
  String get signInToContinue;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// Email field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// Email validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterYourEmail;

  /// Email format validation
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterValidEmail;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Password field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// Password validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterYourPassword;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// Separator text
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// Create account button
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get createNewAccount;

  /// Terms message on login
  ///
  /// In en, this message translates to:
  /// **'By logging in, you agree to our Terms of Service and Privacy Policy'**
  String get termsAndPrivacy;

  /// Login error message
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// Signup page title
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// Signup page subtitle
  ///
  /// In en, this message translates to:
  /// **'Join AQA Shrimp AI today'**
  String get joinAQAShrimpAI;

  /// Back button text
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Full name field label
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Full name field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterYourFullName;

  /// Full name validation
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get pleaseEnterYourFullName;

  /// Farm name field label
  ///
  /// In en, this message translates to:
  /// **'Farm Name / Pond ID'**
  String get farmNamePondID;

  /// Farm name field hint
  ///
  /// In en, this message translates to:
  /// **'Enter farm or pond name'**
  String get enterFarmOrPondName;

  /// Farm name validation
  ///
  /// In en, this message translates to:
  /// **'Please enter farm name or pond ID'**
  String get pleaseEnterFarmNameOrPondID;

  /// Phone number field label
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// Phone number field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterYourPhoneNumber;

  /// Phone number validation
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseEnterYourPhoneNumber;

  /// Phone number format validation
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get pleaseEnterValidPhoneNumber;

  /// Language selection label
  ///
  /// In en, this message translates to:
  /// **'Preferred Language'**
  String get preferredLanguage;

  /// Password creation hint
  ///
  /// In en, this message translates to:
  /// **'Create a strong password'**
  String get createStrongPassword;

  /// Password required validation
  ///
  /// In en, this message translates to:
  /// **'Please enter a password'**
  String get pleaseEnterPassword;

  /// Password length validation
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Confirm password hint
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get reEnterYourPassword;

  /// Confirm password validation
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get pleaseConfirmYourPassword;

  /// Password mismatch validation
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Login link text on signup
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// Terms message on signup
  ///
  /// In en, this message translates to:
  /// **'By creating an account, you agree to our Terms of Service and Privacy Policy'**
  String get termsAndPrivacySignup;

  /// Signup error message
  ///
  /// In en, this message translates to:
  /// **'Signup failed'**
  String get signupFailed;

  /// Main page welcome text
  ///
  /// In en, this message translates to:
  /// **'Welcome to'**
  String get welcomeTo;

  /// Feature card title
  ///
  /// In en, this message translates to:
  /// **'Smart Analytics'**
  String get smartAnalytics;

  /// Feature card description
  ///
  /// In en, this message translates to:
  /// **'Monitor your shrimp farm with AI-powered insights'**
  String get smartAnalyticsDesc;

  /// Feature card title
  ///
  /// In en, this message translates to:
  /// **'Water Quality'**
  String get waterQuality;

  /// Feature card description
  ///
  /// In en, this message translates to:
  /// **'Real-time water quality monitoring and alerts'**
  String get waterQualityDesc;

  /// Feature card title
  ///
  /// In en, this message translates to:
  /// **'Growth Tracking'**
  String get growthTracking;

  /// Feature card description
  ///
  /// In en, this message translates to:
  /// **'Track shrimp growth and predict harvest times'**
  String get growthTrackingDesc;

  /// Hint message on main page
  ///
  /// In en, this message translates to:
  /// **'Tap the profile icon in the top right to view your account details'**
  String get profileHint;

  /// Profile page title
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// Farm name label on profile
  ///
  /// In en, this message translates to:
  /// **'Farm Name'**
  String get farmName;

  /// Farm name hint on profile
  ///
  /// In en, this message translates to:
  /// **'Enter your farm name'**
  String get enterYourFarmName;

  /// Farm name validation on profile
  ///
  /// In en, this message translates to:
  /// **'Please enter your farm name'**
  String get pleaseEnterYourFarmName;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// Sign out button text
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// Sign out dialog title
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOutConfirmTitle;

  /// Sign out confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get signOutConfirmMessage;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Success message
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// Error loading profile
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile'**
  String get failedToLoadProfile;

  /// Error updating profile
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile'**
  String get failedToUpdateProfile;

  /// Loading text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Signup button on start page
  ///
  /// In en, this message translates to:
  /// **'Signup'**
  String get signup;

  /// Login button on start page
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Start page tagline
  ///
  /// In en, this message translates to:
  /// **'Shrimp Health & Productivity\\nIntelligence'**
  String get shrimpHealthProductivity;

  /// Start page description
  ///
  /// In en, this message translates to:
  /// **'Experience medical-grade aquaculture insights.'**
  String get experienceMedicalGrade;

  /// English language name
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Telugu language name
  ///
  /// In en, this message translates to:
  /// **'Telugu'**
  String get telugu;

  /// Hindi language name
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get hindi;

  /// Tamil language name
  ///
  /// In en, this message translates to:
  /// **'Tamil'**
  String get tamil;

  /// Kannada language name
  ///
  /// In en, this message translates to:
  /// **'Kannada'**
  String get kannada;

  /// Dashboard title
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// Settings menu
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Account menu item
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// Account subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage your profile and account'**
  String get manageYourProfile;

  /// Notifications setting
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Notifications enabled status
  ///
  /// In en, this message translates to:
  /// **'Receive app notifications'**
  String get notificationsEnabled;

  /// Notifications disabled status
  ///
  /// In en, this message translates to:
  /// **'Notifications are disabled'**
  String get notificationsDisabled;

  /// Language change option
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageChange;

  /// Language selection dialog title
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Language change success message
  ///
  /// In en, this message translates to:
  /// **'Language changed successfully'**
  String get languageChanged;

  /// About menu item
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// About subtitle
  ///
  /// In en, this message translates to:
  /// **'App information and policies'**
  String get appInfo;

  /// App version label
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// App version menu item
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// About app section title
  ///
  /// In en, this message translates to:
  /// **'About AQA SHRIMP AI'**
  String get aboutApp;

  /// App description
  ///
  /// In en, this message translates to:
  /// **'AQA SHRIMP AI is an advanced aquaculture management platform powered by artificial intelligence. We provide shrimp farmers with intelligent tools for disease detection, size calculation, feed management, and real-time market insights to maximize productivity and profitability.'**
  String get aboutDescription;

  /// Privacy policy menu item
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Privacy policy content
  ///
  /// In en, this message translates to:
  /// **'Your privacy is important to us. AQA SHRIMP AI collects and processes data necessary to provide our services. We do not sell your personal information to third parties. All data is encrypted and stored securely. By using this app, you agree to our data collection and usage practices.'**
  String get privacyPolicyContent;

  /// Terms of service menu item
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// Terms of service content
  ///
  /// In en, this message translates to:
  /// **'By using AQA SHRIMP AI, you agree to our terms and conditions. This app is provided \'as is\' for informational purposes. While we strive for accuracy, we do not guarantee the precision of AI predictions. Users are responsible for verifying all recommendations before implementation. Professional consultation is advised for critical decisions.'**
  String get termsOfServiceContent;

  /// Developer credit
  ///
  /// In en, this message translates to:
  /// **'Made with ❤️ for Shrimp Farmers'**
  String get madeWithLove;

  /// Close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Disease detection feature title
  ///
  /// In en, this message translates to:
  /// **'Shrimp Disease AI'**
  String get shrimpDiseaseAI;

  /// Disease detection description
  ///
  /// In en, this message translates to:
  /// **'AI-powered disease detection from shrimp images'**
  String get shrimpDiseaseDesc;

  /// Size calculation feature title
  ///
  /// In en, this message translates to:
  /// **'Size Calculation'**
  String get sizeCalculation;

  /// Size calculation page title
  ///
  /// In en, this message translates to:
  /// **'Shrimp Size Calculation'**
  String get shrimpSizeCalculation;

  /// Feed calculator feature title
  ///
  /// In en, this message translates to:
  /// **'Feed Calculator'**
  String get feedCalculator;

  /// Disease upload instruction
  ///
  /// In en, this message translates to:
  /// **'Upload a clear image of the shrimp for AI analysis'**
  String get uploadShrimpImage;

  /// Size calculation upload instruction
  ///
  /// In en, this message translates to:
  /// **'Upload shrimp image to calculate size and weight'**
  String get uploadShrimpImageForSize;

  /// Upload image prompt
  ///
  /// In en, this message translates to:
  /// **'Tap to Upload Image'**
  String get tapToUploadImage;

  /// Analyze button for disease detection
  ///
  /// In en, this message translates to:
  /// **'Analyze Disease'**
  String get analyzeDisease;

  /// Calculate button for size
  ///
  /// In en, this message translates to:
  /// **'Calculate Size'**
  String get calculateSize;

  /// Calculate button for feed
  ///
  /// In en, this message translates to:
  /// **'Calculate Feed'**
  String get calculateFeed;

  /// Clear image button
  ///
  /// In en, this message translates to:
  /// **'Clear Image'**
  String get clearImage;

  /// Analysis result title
  ///
  /// In en, this message translates to:
  /// **'Analysis Result'**
  String get analysisResult;

  /// Calculation result title
  ///
  /// In en, this message translates to:
  /// **'Calculation Result'**
  String get calculationResult;

  /// Detected disease label
  ///
  /// In en, this message translates to:
  /// **'Detected Disease'**
  String get detectedDisease;

  /// Confidence level label
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get confidence;

  /// Severity level label
  ///
  /// In en, this message translates to:
  /// **'Severity'**
  String get severity;

  /// Average length label
  ///
  /// In en, this message translates to:
  /// **'Average Length'**
  String get averageLength;

  /// Average weight label
  ///
  /// In en, this message translates to:
  /// **'Average Weight'**
  String get averageWeight;

  /// Estimated biomass label
  ///
  /// In en, this message translates to:
  /// **'Estimated Biomass'**
  String get estimatedBiomass;

  /// Shrimp count label
  ///
  /// In en, this message translates to:
  /// **'Shrimp Count'**
  String get shrimpCount;

  /// Take photo option
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// Choose from gallery option
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// Image picker error message
  ///
  /// In en, this message translates to:
  /// **'Error picking image'**
  String get errorPickingImage;

  /// Analysis completion message
  ///
  /// In en, this message translates to:
  /// **'Analysis complete!'**
  String get analysisComplete;

  /// Calculation completion message
  ///
  /// In en, this message translates to:
  /// **'Calculation complete!'**
  String get calculationComplete;

  /// Feed calculator instruction
  ///
  /// In en, this message translates to:
  /// **'Enter your pond details to calculate feed requirements'**
  String get enterPondDetails;

  /// Pond information section title
  ///
  /// In en, this message translates to:
  /// **'Pond Information'**
  String get pondInformation;

  /// Pond area field label
  ///
  /// In en, this message translates to:
  /// **'Pond Area'**
  String get pondArea;

  /// Pond area hint
  ///
  /// In en, this message translates to:
  /// **'Enter pond area in square meters'**
  String get enterPondArea;

  /// Pond area validation
  ///
  /// In en, this message translates to:
  /// **'Please enter pond area'**
  String get pleaseEnterPondArea;

  /// Shrimp count hint
  ///
  /// In en, this message translates to:
  /// **'Enter total number of shrimps'**
  String get enterShrimpCount;

  /// Shrimp count validation
  ///
  /// In en, this message translates to:
  /// **'Please enter shrimp count'**
  String get pleaseEnterShrimpCount;

  /// Average size field label
  ///
  /// In en, this message translates to:
  /// **'Average Size'**
  String get averageSize;

  /// Average size hint
  ///
  /// In en, this message translates to:
  /// **'Enter average shrimp size in grams'**
  String get enterAverageSize;

  /// Average size validation
  ///
  /// In en, this message translates to:
  /// **'Please enter average size'**
  String get pleaseEnterAverageSize;

  /// Number validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get pleaseEnterValidNumber;

  /// Feed recommendation section title
  ///
  /// In en, this message translates to:
  /// **'Feed Recommendation'**
  String get feedRecommendation;

  /// Daily feed amount label
  ///
  /// In en, this message translates to:
  /// **'Daily Feed Amount'**
  String get dailyFeedAmount;

  /// Feeding frequency label
  ///
  /// In en, this message translates to:
  /// **'Feeding Frequency'**
  String get feedingFrequency;

  /// Feed per meal label
  ///
  /// In en, this message translates to:
  /// **'Feed Per Meal'**
  String get feedPerMeal;

  /// Monthly feed estimate label
  ///
  /// In en, this message translates to:
  /// **'Monthly Feed Estimate'**
  String get monthlyFeedEstimate;

  /// Feeding schedule title
  ///
  /// In en, this message translates to:
  /// **'Suggested Feeding Schedule'**
  String get suggestedSchedule;

  /// Common diseases section title
  ///
  /// In en, this message translates to:
  /// **'Common Shrimp Diseases'**
  String get commonDiseases;

  /// Symptoms label
  ///
  /// In en, this message translates to:
  /// **'Symptoms'**
  String get symptoms;

  /// Prevention label
  ///
  /// In en, this message translates to:
  /// **'Prevention'**
  String get prevention;

  /// Learn more button
  ///
  /// In en, this message translates to:
  /// **'Learn More'**
  String get learnMore;

  /// WSSV symptoms
  ///
  /// In en, this message translates to:
  /// **'White spots on shell, reduced feeding, lethargy, reddish discoloration'**
  String get wssvSymptoms;

  /// WSSV prevention
  ///
  /// In en, this message translates to:
  /// **'Maintain water quality, quarantine new stock, use PCR-tested seeds, avoid stress'**
  String get wssvPrevention;

  /// EMS symptoms
  ///
  /// In en, this message translates to:
  /// **'Empty stomach, soft shell, pale hepatopancreas, slow growth, high mortality'**
  String get emsSymptoms;

  /// EMS prevention
  ///
  /// In en, this message translates to:
  /// **'Use quality feed, maintain optimal pH, reduce stocking density, improve biosecurity'**
  String get emsPrevention;

  /// IHHNV symptoms
  ///
  /// In en, this message translates to:
  /// **'Stunted growth, deformed rostrum, bent antenna, uneven sizes in pond'**
  String get ihhnvSymptoms;

  /// IHHNV prevention
  ///
  /// In en, this message translates to:
  /// **'Source SPF broodstock, regular health monitoring, maintain water parameters'**
  String get ihhnvPrevention;

  /// YHD symptoms
  ///
  /// In en, this message translates to:
  /// **'Yellow head and gills, pale body, erratic swimming, sudden mass mortality'**
  String get yhdSymptoms;

  /// YHD prevention
  ///
  /// In en, this message translates to:
  /// **'Avoid overstocking, ensure good aeration, use probiotics, regular water exchange'**
  String get yhdPrevention;

  /// Market prices section title
  ///
  /// In en, this message translates to:
  /// **'Market Prices'**
  String get marketPrices;

  /// Weather forecast title
  ///
  /// In en, this message translates to:
  /// **'Weather Forecast'**
  String get weatherForecast;

  /// Humidity label
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// Wind speed label
  ///
  /// In en, this message translates to:
  /// **'Wind Speed'**
  String get windSpeed;

  /// Rainfall probability label
  ///
  /// In en, this message translates to:
  /// **'Rainfall'**
  String get rainfall;

  /// Weather advisory message
  ///
  /// In en, this message translates to:
  /// **'Good conditions for farming. Monitor water quality closely.'**
  String get weatherAdvisory;

  /// Weather unavailable message
  ///
  /// In en, this message translates to:
  /// **'Weather data unavailable. Please check your connection.'**
  String get weatherUnavailable;

  /// Data refresh success message
  ///
  /// In en, this message translates to:
  /// **'Data refreshed successfully'**
  String get dataRefreshed;

  /// Analyzing disease loading message
  ///
  /// In en, this message translates to:
  /// **'Analyzing Disease...'**
  String get analyzingDisease;

  /// AI analysis wait message
  ///
  /// In en, this message translates to:
  /// **'Please wait while AI analyzes the image'**
  String get pleaseWaitAIAnalyzing;

  /// Calculating size loading message
  ///
  /// In en, this message translates to:
  /// **'Calculating Size...'**
  String get calculatingSize;

  /// AI thinking indicator in chatbot
  ///
  /// In en, this message translates to:
  /// **'AI is thinking...'**
  String get aiThinking;

  /// AI initialization message
  ///
  /// In en, this message translates to:
  /// **'Initializing AI Assistant...'**
  String get initializingAI;

  /// Gemini branding message
  ///
  /// In en, this message translates to:
  /// **'Powered by Google Gemini 2.5 Flash'**
  String get poweredByGemini;

  /// Disease information section title
  ///
  /// In en, this message translates to:
  /// **'Disease Information'**
  String get diseaseInformation;

  /// Confidence breakdown section
  ///
  /// In en, this message translates to:
  /// **'Confidence Breakdown'**
  String get confidenceBreakdown;

  /// Affected areas label
  ///
  /// In en, this message translates to:
  /// **'Affected Areas'**
  String get affectedAreas;

  /// Treatment label
  ///
  /// In en, this message translates to:
  /// **'Treatment'**
  String get treatment;

  /// Medications label
  ///
  /// In en, this message translates to:
  /// **'Medications'**
  String get medications;

  /// Precautions label
  ///
  /// In en, this message translates to:
  /// **'Precautions'**
  String get precautions;

  /// Alternatives label
  ///
  /// In en, this message translates to:
  /// **'Alternatives'**
  String get alternatives;

  /// Product recommendations section
  ///
  /// In en, this message translates to:
  /// **'Product Recommendations'**
  String get productRecommendations;

  /// Amazon link button
  ///
  /// In en, this message translates to:
  /// **'View on Amazon'**
  String get viewOnAmazon;

  /// Flipkart link button
  ///
  /// In en, this message translates to:
  /// **'View on Flipkart'**
  String get viewOnFlipkart;

  /// Farmer guidance section
  ///
  /// In en, this message translates to:
  /// **'Farmer Guidance'**
  String get farmerGuidance;

  /// Immediate actions label
  ///
  /// In en, this message translates to:
  /// **'Immediate Actions'**
  String get immediateActions;

  /// Prevention tips label
  ///
  /// In en, this message translates to:
  /// **'Prevention Tips'**
  String get preventionTips;

  /// Monitoring advice label
  ///
  /// In en, this message translates to:
  /// **'Monitoring Advice'**
  String get monitoringAdvice;

  /// Healthy shrimp status
  ///
  /// In en, this message translates to:
  /// **'Healthy Shrimp'**
  String get healthyShrimp;

  /// No disease message
  ///
  /// In en, this message translates to:
  /// **'No diseases detected. Keep up the good work!'**
  String get noDiseasesDetected;

  /// Visual insights section
  ///
  /// In en, this message translates to:
  /// **'Visual Insights'**
  String get visualInsights;

  /// Farmer summary section
  ///
  /// In en, this message translates to:
  /// **'Farmer Summary'**
  String get farmerSummary;

  /// Overall health label
  ///
  /// In en, this message translates to:
  /// **'Overall Health'**
  String get overallHealth;

  /// Days to harvest label
  ///
  /// In en, this message translates to:
  /// **'Estimated Days to Harvest'**
  String get estimatedDaysToHarvest;

  /// Feeding recommendation label
  ///
  /// In en, this message translates to:
  /// **'Feeding Recommendation'**
  String get feedingRecommendation;

  /// Stocking density label
  ///
  /// In en, this message translates to:
  /// **'Stocking Density'**
  String get stockingDensity;

  /// Culture duration label
  ///
  /// In en, this message translates to:
  /// **'Culture Duration'**
  String get cultureDuration;

  /// Growth stage label
  ///
  /// In en, this message translates to:
  /// **'Growth Stage'**
  String get growthStage;

  /// Feeding rate label
  ///
  /// In en, this message translates to:
  /// **'Feeding Rate'**
  String get feedingRate;

  /// Pounds per acre unit
  ///
  /// In en, this message translates to:
  /// **'pounds/acre'**
  String get poundsPerAcre;

  /// Days unit
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// Of body weight unit
  ///
  /// In en, this message translates to:
  /// **'of body weight'**
  String get ofBodyWeight;

  /// Per day unit
  ///
  /// In en, this message translates to:
  /// **'per day'**
  String get perDay;

  /// Morning feeding time
  ///
  /// In en, this message translates to:
  /// **'Morning (Early Dawn)'**
  String get morningEarlyDawn;

  /// Mid-morning feeding time
  ///
  /// In en, this message translates to:
  /// **'Mid-Morning'**
  String get midMorning;

  /// Afternoon feeding time
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get afternoon;

  /// Evening feeding time
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get evening;

  /// Late evening feeding time
  ///
  /// In en, this message translates to:
  /// **'Late Evening'**
  String get lateEvening;

  /// Midnight feeding time
  ///
  /// In en, this message translates to:
  /// **'Midnight/Early Morning'**
  String get midnightEarlyMorning;

  /// Performance metrics section
  ///
  /// In en, this message translates to:
  /// **'Performance Metrics'**
  String get performanceMetrics;

  /// FCR label
  ///
  /// In en, this message translates to:
  /// **'Feed Conversion Ratio (FCR)'**
  String get feedConversionRatio;

  /// Weekly growth label
  ///
  /// In en, this message translates to:
  /// **'Weekly Growth'**
  String get weeklyGrowth;

  /// Survival rate label
  ///
  /// In en, this message translates to:
  /// **'Survival Rate'**
  String get survivalRate;

  /// Cost analysis section
  ///
  /// In en, this message translates to:
  /// **'Cost Analysis'**
  String get costAnalysis;

  /// Daily cost label
  ///
  /// In en, this message translates to:
  /// **'Daily Cost'**
  String get dailyCost;

  /// Monthly cost label
  ///
  /// In en, this message translates to:
  /// **'Monthly Cost'**
  String get monthlyCost;

  /// Expert recommendations section
  ///
  /// In en, this message translates to:
  /// **'Expert Recommendations'**
  String get expertRecommendations;

  /// Chat with AI feature
  ///
  /// In en, this message translates to:
  /// **'Chat with AI'**
  String get chatWithAI;

  /// Chatbot placeholder
  ///
  /// In en, this message translates to:
  /// **'Ask me anything about shrimp farming...'**
  String get askMeAnything;

  /// Message input placeholder
  ///
  /// In en, this message translates to:
  /// **'Type your message...'**
  String get typeYourMessage;

  /// User message label
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get youText;

  /// AI assistant label
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get aiAssistant;

  /// Calculation results title
  ///
  /// In en, this message translates to:
  /// **'Calculation Results'**
  String get calculationResults;

  /// Feed calculator title
  ///
  /// In en, this message translates to:
  /// **'Smart Feed Calculator'**
  String get feedCalculatorTitle;

  /// Chatbot page title
  ///
  /// In en, this message translates to:
  /// **'Shrimp AI Chatbot'**
  String get shrimpChatbot;

  /// Scientific name label
  ///
  /// In en, this message translates to:
  /// **'Scientific Name'**
  String get scientificName;

  /// Disease type label
  ///
  /// In en, this message translates to:
  /// **'Disease Type'**
  String get diseaseType;

  /// Disease stage label
  ///
  /// In en, this message translates to:
  /// **'Disease Stage'**
  String get diseaseStage;

  /// Good condition status
  ///
  /// In en, this message translates to:
  /// **'Good Condition'**
  String get goodCondition;

  /// Excellent health status
  ///
  /// In en, this message translates to:
  /// **'Excellent Health'**
  String get excellentHealth;

  /// Total biomass label
  ///
  /// In en, this message translates to:
  /// **'Total Biomass'**
  String get totalBiomass;

  /// Average weight in grams label
  ///
  /// In en, this message translates to:
  /// **'Average Weight (grams)'**
  String get averageWeightGrams;

  /// Average length in cm label
  ///
  /// In en, this message translates to:
  /// **'Average Length (cm)'**
  String get averageLengthCm;

  /// Analysis error message
  ///
  /// In en, this message translates to:
  /// **'Error analyzing image'**
  String get errorAnalyzing;

  /// Calculation error message
  ///
  /// In en, this message translates to:
  /// **'Error calculating size'**
  String get errorCalculating;

  /// Feed calculation success
  ///
  /// In en, this message translates to:
  /// **'Feed calculation completed successfully!'**
  String get feedCalculationComplete;

  /// Calculation error prefix
  ///
  /// In en, this message translates to:
  /// **'Error during calculation'**
  String get errorDuringCalculation;
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
      <String>['en', 'hi', 'kn', 'ta', 'te'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

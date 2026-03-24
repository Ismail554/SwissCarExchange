import 'package:flutter/material.dart';

/// App Strings for ScoreLivePro
/// Supports 6 languages: English, Spanish, French, Arabic, Portuguese, German
///
/// Usage:
/// ```dart
/// AppStrings.get(context).appName
/// ```
class AppStrings {
  static const String maybeLater = "Maybe Later";
  static const String saveToFavorites = "Save to Favorites";
  static const String sponserd = "SPONSORED";
  static const String upgradeNow = 'Upgrade Now';
  static const String langChangeAlert =
      "Language changes will take effect after restarting the app.";
  static const String realScoreNews = "Real-Time Football Scores & News";
  static const String copywrite = "© 2025 ScoreLivePRO";
  static const String infoDesc =
      "ScoreLivePRO is not meant for collecting PII or securing sensitive data. This app is designed for entertainment and informational purposes only.";
  // ==================== General ====================
  static const String appName = "Score Live Pro";
  static const String loading = "Loading...";
  static const String error = "Error";
  static const String success = "Success";
  static const String cancel = "Cancel";
  static const String confirm = "Confirm";
  static const String save = "Save";
  static const String delete = "Delete";
  static const String edit = "Edit";
  static const String search = "Search";
  static const String filter = "Filter";
  static const String sort = "Sort";
  static const String refresh = "Refresh";
  static const String retry = "Retry";
  static const String noData = "No data available";
  static const String noInternet = "No internet connection";
  static const String changed = "changed";

  // ==================== Splash & Onboarding ====================
  static const String splashLoading = "Loading...";
  static const String onboardingTitle1 = "Real-Time Scores";
  static const String onboardingTitle2 = "Lightning Fast Notifications";
  static const String onboardingTitle3 = "Personalized Favorites";
  static const String onboardingDescription1 =
      "Get live updates from matches around the world instantly";
  static const String onboardingDescription2 =
      "Never miss a goal, card, or important match event";
  static const String onboardingDescription3 =
      "Follow your favorite teams and leagues to stay updated";
  static const String skip = "Skip";
  static const String next = "Next";
  static const String getStarted = "Get Started";

  // ==================== Authentication ====================
  static const String signIn = "Sign In";
  static const String signUp = "Sign Up";
  static const String signOut = "Sign Out";
  static const String email = "Email";
  static const String emailHint = "Enter your email";
  static const String password = "Password";
  static const String passwordHint = "Enter your password";
  static const String confirmPassword = "Confirm Password";
  static const String confirmPasswordHint = "Re-enter your password";
  static const String fullName = "Full Name";
  static const String fullNameHint = "Enter your full name";
  static const String phone = "Phone";
  static const String phoneHint = "Enter your phone number";
  static const String forgotPassword = "Forgot Password?";
  static const String rememberMe = "Remember Me";
  static const String dontHaveAccount = "Don't have an account?";
  static const String alreadyHaveAccount = "Already have an account?";
  static const String createAccount = "Create Account";
  static const String login = "Login";
  static const String continueText = "Continue";
  static const String orContinueWith = "Or continue with";
  static const String googleSignIn = "Sign in with Google";
  static const String appleSignIn = "Sign in with Apple";
  static const String facebookSignIn = "Sign in with Facebook";

  // ==================== OTP Verification ====================
  static const String otpVerification = "OTP Verification";
  static const String otpInstruction = "Enter the OTP sent to your email";
  static const String otpResendPrompt = "Didn't receive OTP?";
  static const String resendOtp = "Resend OTP";
  static const String verify = "Verify";
  static const String otpSent = "OTP sent successfully";
  static const String otpExpired = "OTP has expired";
  static const String invalidOtp = "Invalid OTP";

  // ==================== Forgot Password ====================
  static const String forgotPasswordTitle = "Forgot Password";
  static const String forgotPasswordDescription =
      "Enter your email to receive password reset instructions";
  static const String resetPassword = "Reset Password";
  static const String passwordResetInstruction =
      "Check your email for password reset instructions";

  // ==================== Home Screen ====================

  static const String welcome_back = "Welcome Back";
  static const String date_today = "Sunday, 25 Dec 2025";

  /// top are newly added
  static const String home = "Home";
  static const String liveMatches = "Live Matches";
  static const String upcomingMatches = "Upcoming Matches";
  static const String finishedMatches = "Finished Matches";
  static const String today = "Today";
  static const String tomorrow = "Tomorrow";
  static const String yesterday = "Yesterday";
  static const String thisWeek = "This Week";
  static const String allMatches = "All Matches";
  static const String noMatches = "No matches available";
  static const String matchDetails = "Match Details";
  static const String live = "LIVE";
  static const String ft = "FT"; // Full Time
  static const String ht = "HT"; // Half Time
  static const String postponed = "Postponed";
  static const String cancelled = "Cancelled";

  // ==================== Leagues ====================
  static const String leagues = "Leagues";
  static const String league = "League";
  static const String allLeagues = "All Leagues";
  static const String popularLeagues = "Popular Leagues";
  static const String myLeagues = "My Leagues";
  static const String standings = "Standings";
  static const String fixtures = "Fixtures";
  static const String results = "Results";
  static const String stats = "Stats";
  static const String topScorers = "Top Scorers";
  static const String topAssists = "Top Assists";
  static const String teamStats = "Team Stats";
  static const String playerStats = "Player Stats";
  static const String noLeagues = "No leagues available";

  // ==================== Teams ====================
  static const String teams = "Teams";
  static const String team = "Team";
  static const String myTeams = "My Teams";
  static const String teamInfo = "Team Info";
  static const String squad = "Squad";
  static const String matches = "Matches";
  static const String nextMatch = "Next Match";
  static const String lastMatch = "Last Match";
  static const String noTeams = "No teams available";

  // ==================== News ====================
  static const String news = "News";
  static const String latestNews = "Latest News";
  static const String trendingNews = "Trending News";
  static const String newsDetails = "News Details";
  static const String readMore = "Read More";
  static const String readLess = "Read Less";
  static const String share = "Share";
  static const String relatedNews = "Related News";
  static const String noNews = "No news available";
  static const String categories = "Categories";
  static const String allCategories = "All Categories";

  // ==================== Favorites ====================
  static const String favorites = "Favorites";
  static const String myFavorites = "My Favorites";
  static const String favoriteTeams = "Favorite Teams";
  static const String browseTeams = "Browse Teams";
  static const String favoriteLeagues = "Favorite Leagues";
  static const String addToFavorites = "Add to Favorites";
  static const String removeFromFavorites = "Remove from Favorites";
  static const String noFavorites = "No favorites yet";
  static const String addFavoritesHint =
      "Start adding your favorite teams and leagues";

  // ==================== Notifications ====================
  static const String notifications = "Notifications";
  static const String notificationSettings = "Notification Settings";
  static const String noNotifications = "No notifications";
  static const String markAllAsRead = "Mark all as read";
  static const String clearAll = "Clear all";
  static const String matchNotifications = "Match Notifications";
  static const String newsNotifications = "News Notifications";
  static const String leagueNotifications = "League Notifications";
  static const String teamNotifications = "Team Notifications";
  static const String enableNotifications = "Enable Notifications";
  static const String notificationPermission = "Notification Permission";
  static const String allowNotifications =
      "Allow notifications to stay updated";

  // ==================== Settings ====================
  static const String settings = "Settings";
  static const String account = "ACCOUNT";
  static const String preferences = "PREFERENCES";
  static const String aboutSection = "ABOUT";
  static const String loginSignUp = "Login / Sign Up";
  static const String syncFavorites = "Sync favorites across devices";
  static const String enabled = "Enabled";
  static const String disabled = "Disabled";
  static const String profile = "Profile";
  static const String editProfile = "Edit Profile";
  static const String language = "Language";
  static const String selectLanguage = "Select Language";
  static const String english = "English";
  static const String spanish = "Spanish";
  static const String french = "French";
  static const String arabic = "Arabic";
  static const String portuguese = "Portuguese";
  static const String german = "German";
  static const String theme = "Theme";
  static const String darkMode = "Dark Mode";
  static const String lightMode = "Light Mode";
  static const String systemDefault = "System Default";
  static const String about = "About";
  static const String appInfo = "App Info";
  static const String version = "Version";
  static const String versionNumber = "Version 1.0.0";
  static const String privacyAndTerms = "Privacy & Terms";
  static const String privacyPolicy = "Privacy Policy";
  static const String termsOfService = "Terms of Service";
  static const String help = "Help";
  static const String support = "Support";
  static const String feedback = "Feedback";
  static const String rateApp = "Rate App";
  static const String shareApp = "Share App";

  // ==================== Match Details ====================
  static const String matchInfo = "Match Info";
  static const String venue = "Venue";
  static const String date = "Date";
  static const String time = "Time";
  static const String referee = "Referee";
  static const String attendance = "Attendance";
  static const String lineups = "Lineups";
  static const String timeline = "Timeline";
  static const String commentary = "Commentary";
  static const String substitutes = "Substitutes";
  static const String events = "Events";
  static const String goal = "Goal";
  static const String yellowCard = "Yellow Card";
  static const String redCard = "Red Card";
  static const String substitution = "Substitution";
  static const String penalty = "Penalty";
  static const String ownGoal = "Own Goal";
  static const String minute = "Minute";
  static const String firstHalf = "First Half";
  static const String secondHalf = "Second Half";
  static const String extraTime = "Extra Time";
  static const String penalties = "Penalties";

  // ==================== Validation Messages ====================
  static const String emailRequired = "Email is required";
  static const String invalidEmail = "Please enter a valid email";
  static const String passwordRequired = "Password is required";
  static const String passwordTooShort =
      "Password must be at least 6 characters";
  static const String passwordsDoNotMatch = "Passwords do not match";
  static const String nameRequired = "Name is required";
  static const String phoneRequired = "Phone number is required";
  static const String invalidPhone = "Please enter a valid phone number";
  static const String fieldRequired = "This field is required";

  // ==================== Error Messages ====================
  static const String somethingWentWrong = "Something went wrong";
  static const String networkError =
      "Network error. Please check your connection";
  static const String serverError = "Server error. Please try again later";
  static const String unauthorized = "Unauthorized. Please login again";
  static const String notFound = "Not found";
  static const String timeout = "Request timeout. Please try again";

  // ==================== Success Messages ====================
  static const String loginSuccess = "Login successful";
  static const String signUpSuccess = "Account created successfully";
  static const String passwordResetSuccess = "Password reset successfully";
  static const String profileUpdated = "Profile updated successfully";
  static const String addedToFavorites = "Added to favorites";
  static const String removedFromFavorites = "Removed from favorites";

  // ==================== Time & Date ====================
  static const String now = "Now";
  static const String ago = "ago";
  static const String minutesAgo = "minutes ago";
  static const String hoursAgo = "hours ago";
  static const String daysAgo = "days ago";
  static const String weeksAgo = "weeks ago";
  static const String monthsAgo = "months ago";
  static const String yearsAgo = "years ago";
  static const String justNow = "Just now";
  static const String am = "AM";
  static const String pm = "PM";

  // ==================== Common Actions ====================
  static const String viewAll = "View All";
  static const String seeMore = "See More";
  static const String seeLess = "See Less";
  static const String loadMore = "Load More";
  static const String showLess = "Show Less";
  static const String close = "Close";
  static const String back = "Back";
  static const String done = "Done";
  static const String ok = "OK";
  static const String yes = "Yes";
  static const String no = "No";
}

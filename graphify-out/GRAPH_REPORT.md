# Graph Report - Rionydo  (2026-05-01)

## Corpus Check
- 143 files · ~166,905 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1009 nodes · 1450 edges · 42 communities detected
- Extraction: 99% EXTRACTED · 1% INFERRED · 0% AMBIGUOUS · INFERRED: 8 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Community 1|Community 1]]
- [[_COMMUNITY_Community 2|Community 2]]
- [[_COMMUNITY_Community 3|Community 3]]
- [[_COMMUNITY_Community 4|Community 4]]
- [[_COMMUNITY_Community 5|Community 5]]
- [[_COMMUNITY_Community 6|Community 6]]
- [[_COMMUNITY_Community 7|Community 7]]
- [[_COMMUNITY_Community 8|Community 8]]
- [[_COMMUNITY_Community 9|Community 9]]
- [[_COMMUNITY_Community 10|Community 10]]
- [[_COMMUNITY_Community 11|Community 11]]
- [[_COMMUNITY_Community 12|Community 12]]
- [[_COMMUNITY_Community 13|Community 13]]
- [[_COMMUNITY_Community 14|Community 14]]
- [[_COMMUNITY_Community 15|Community 15]]
- [[_COMMUNITY_Community 16|Community 16]]
- [[_COMMUNITY_Community 17|Community 17]]
- [[_COMMUNITY_Community 18|Community 18]]
- [[_COMMUNITY_Community 19|Community 19]]
- [[_COMMUNITY_Community 20|Community 20]]
- [[_COMMUNITY_Community 21|Community 21]]
- [[_COMMUNITY_Community 22|Community 22]]
- [[_COMMUNITY_Community 23|Community 23]]
- [[_COMMUNITY_Community 24|Community 24]]
- [[_COMMUNITY_Community 25|Community 25]]
- [[_COMMUNITY_Community 26|Community 26]]
- [[_COMMUNITY_Community 27|Community 27]]
- [[_COMMUNITY_Community 28|Community 28]]
- [[_COMMUNITY_Community 29|Community 29]]
- [[_COMMUNITY_Community 30|Community 30]]
- [[_COMMUNITY_Community 31|Community 31]]
- [[_COMMUNITY_Community 32|Community 32]]
- [[_COMMUNITY_Community 33|Community 33]]
- [[_COMMUNITY_Community 34|Community 34]]
- [[_COMMUNITY_Community 35|Community 35]]
- [[_COMMUNITY_Community 36|Community 36]]
- [[_COMMUNITY_Community 37|Community 37]]
- [[_COMMUNITY_Community 38|Community 38]]
- [[_COMMUNITY_Community 39|Community 39]]
- [[_COMMUNITY_Community 40|Community 40]]
- [[_COMMUNITY_Community 41|Community 41]]

## God Nodes (most connected - your core abstractions)
1. `package:flutter/material.dart` - 101 edges
2. `package:flutter_screenutil/flutter_screenutil.dart` - 87 edges
3. `package:rionydo/app_utils/utils/app_colors.dart` - 82 edges
4. `package:rionydo/app_utils/constants/font_manager.dart` - 57 edges
5. `package:rionydo/core/widgets/common_background.dart` - 35 edges
6. `package:rionydo/core/widgets/custom_back_button.dart` - 26 edges
7. `package:rionydo/app_utils/utils/app_spacing.dart` - 24 edges
8. `package:rionydo/core/widgets/custom_button.dart` - 22 edges
9. `package:rionydo/app_utils/utils/assets_manager.dart` - 16 edges
10. `package:rionydo/core/widgets/widget_snackbar.dart` - 9 edges

## Surprising Connections (you probably didn't know these)
- `fl_register_plugins()` --calls--> `my_application_activate()`  [INFERRED]
  linux\flutter\generated_plugin_registrant.cc → linux\runner\my_application.cc
- `main()` --calls--> `my_application_new()`  [INFERRED]
  linux\runner\main.cc → linux\runner\my_application.cc
- `RegisterPlugins()` --calls--> `OnCreate()`  [INFERRED]
  windows\flutter\generated_plugin_registrant.cc → windows\runner\flutter_window.cpp
- `OnCreate()` --calls--> `GetClientArea()`  [INFERRED]
  windows\runner\flutter_window.cpp → windows\runner\win32_window.cpp
- `OnCreate()` --calls--> `SetChildContent()`  [INFERRED]
  windows\runner\flutter_window.cpp → windows\runner\win32_window.cpp

## Communities

### Community 0 - "Community 0"
Cohesion: 0.03
Nodes (63): build, MaterialApp, MyApp, ScreenUtilInit, AppPadding, AppSpacing, build, CommonBackground (+55 more)

### Community 1 - "Community 1"
Cohesion: 0.03
Nodes (60): AddAuctionView, build, Scaffold, Text, build, CommonBackground, dispose, initState (+52 more)

### Community 2 - "Community 2"
Cohesion: 0.04
Nodes (55): build, CustomBackButton, GestureDetector, build, CommonBackground, dispose, ForgotPassView, _ForgotPassViewState (+47 more)

### Community 3 - "Community 3"
Cohesion: 0.03
Nodes (57): build, _buildProgressBar, _buildStepHeader, ClipRRect, Column, CommonBackground, _CompanyForm, Container (+49 more)

### Community 4 - "Community 4"
Cohesion: 0.05
Nodes (45): AuthProvider, build, OnboardignCommonScaff, Step1Onboarding, build, OnboardignCommonScaff, Step2Onboarding, build (+37 more)

### Community 5 - "Community 5"
Cohesion: 0.04
Nodes (46): main, build, CommonBackground, _handleLogin, LoginViews, _LoginViewsState, AuctionCard, build (+38 more)

### Community 6 - "Community 6"
Cohesion: 0.04
Nodes (45): build, CustomTextField, TextFormField, _BankDetail, _BankDetailRow, _BankDetailsCard, build, Container (+37 more)

### Community 7 - "Community 7"
Cohesion: 0.04
Nodes (40): build, Container, CustomButton, build, Container, Material, _PaymentOptionSheet, _PaymentOptionTile (+32 more)

### Community 8 - "Community 8"
Cohesion: 0.04
Nodes (37): GlobalState, isPremium, AppColors, AppStrings, AppSnackBar, _config, error, info (+29 more)

### Community 9 - "Community 9"
Cohesion: 0.05
Nodes (39): create_auction_helpers.dart, build, CommonBackground, Container, dispose, initState, _SecurityBadge, SignUpView (+31 more)

### Community 10 - "Community 10"
Cohesion: 0.05
Nodes (38): BidsView, _BidsViewState, build, _buildBody, _buildPinnedHeader, _buildTransactionSliver, CommonBackground, Divider (+30 more)

### Community 11 - "Community 11"
Cohesion: 0.06
Nodes (29): AuctionsView, _AuctionsViewState, build, _buildAuctionCard, CommonBackground, GestureDetector, Padding, AuctionManagement (+21 more)

### Community 12 - "Community 12"
Cohesion: 0.07
Nodes (29): apiRequest, _attachAuthHeader, _attachDeviceId, _buildInterceptor, DioManager, init, InterceptorsWrapper, left (+21 more)

### Community 13 - "Community 13"
Cohesion: 0.07
Nodes (29): bigTitleText, bodyLarge, bodyMedium, bodySmall, buttonText, displayLarge, displayMedium, displaySmall (+21 more)

### Community 14 - "Community 14"
Cohesion: 0.11
Nodes (19): RegisterPlugins(), FlutterWindow(), OnCreate(), Create(), Destroy(), EnableFullDpiSupportIfAvailable(), GetClientArea(), GetThisFromHandle() (+11 more)

### Community 15 - "Community 15"
Cohesion: 0.08
Nodes (23): build, CommonBackground, _ContactItem, Container, _FAQItem, _FAQItemState, HelpSupportView, initState (+15 more)

### Community 16 - "Community 16"
Cohesion: 0.09
Nodes (21): BeforeSubsView, build, CommonBackground, build, _buildDataRow, _buildDivider, _buildStatusRow, CommonBackground (+13 more)

### Community 17 - "Community 17"
Cohesion: 0.11
Nodes (18): Align, build, _ChatBubble, _ChatIconButton, _ChatMessage, ChatSupportView, _ChatSupportViewState, Container (+10 more)

### Community 18 - "Community 18"
Cohesion: 0.11
Nodes (18): AccountInfoCard, build, CommonBackground, DealerRatingCard, LogoutButton, MyBidsTile, ProfileSectionTitle, ProfileView (+10 more)

### Community 19 - "Community 19"
Cohesion: 0.11
Nodes (16): AuctionDetails, build, _buildDataCard, Container, Scaffold, build, _buildActiveBids, _buildCompletedBids (+8 more)

### Community 20 - "Community 20"
Cohesion: 0.12
Nodes (16): _AspectRatingCard, build, CommonBackground, Container, dispose, Function, _OverallRatingCard, Padding (+8 more)

### Community 21 - "Community 21"
Cohesion: 0.14
Nodes (13): AuctionBidding, _AuctionBiddingState, build, _buildBidTile, _buildQuickBidButton, _buildTimeBox, Container, _formatCurrency (+5 more)

### Community 22 - "Community 22"
Cohesion: 0.14
Nodes (13): build, _buildCompletedList, _buildPendingList, Column, CommonBackground, PaymentInfoCard, PaymentTransactionCard, RecievePayments (+5 more)

### Community 23 - "Community 23"
Cohesion: 0.14
Nodes (12): build, NotificationSettingTile, Padding, build, CommonBackground, CustomTextField, InkWell, PrivacySettingsView (+4 more)

### Community 24 - "Community 24"
Cohesion: 0.14
Nodes (4): fl_register_plugins(), main(), my_application_activate(), my_application_new()

### Community 25 - "Community 25"
Cohesion: 0.17
Nodes (11): build, _buildBorder, Column, Container, CustomDropdownField, _CustomDropdownFieldState, dispose, Function (+3 more)

### Community 26 - "Community 26"
Cohesion: 0.17
Nodes (11): build, Column, Container, ListTile, Padding, ProfileDivider, ProfileInfoRow, ProfileListTile (+3 more)

### Community 27 - "Community 27"
Cohesion: 0.2
Nodes (9): AnimatedContainer, build, _buildGlow, Container, OnboardignCommonScaff, Scaffold, SizedBox, Spacer (+1 more)

### Community 28 - "Community 28"
Cohesion: 0.29
Nodes (2): FlutterAppDelegate, AppDelegate

### Community 29 - "Community 29"
Cohesion: 0.33
Nodes (3): RegisterGeneratedPlugins(), NSWindow, MainFlutterWindow

### Community 30 - "Community 30"
Cohesion: 0.47
Nodes (4): wWinMain(), CreateAndAttachConsole(), GetCommandLineArguments(), Utf8FromUtf16()

### Community 31 - "Community 31"
Cohesion: 0.4
Nodes (2): RunnerTests, XCTestCase

### Community 32 - "Community 32"
Cohesion: 0.4
Nodes (4): LocalStorageService, SecureStorageHelper, package:flutter_secure_storage/flutter_secure_storage.dart, package:uuid/uuid.dart

### Community 33 - "Community 33"
Cohesion: 0.4
Nodes (4): IconAssets, ImageAssets, JsonAssets, SvgAssets

### Community 34 - "Community 34"
Cohesion: 0.5
Nodes (2): handle_new_rx_page(), Intercept NOTIFY_DEBUGGER_ABOUT_RX_PAGES and touch the pages.

### Community 35 - "Community 35"
Cohesion: 0.67
Nodes (1): GeneratedPluginRegistrant

### Community 36 - "Community 36"
Cohesion: 0.67
Nodes (2): GeneratedPluginRegistrant, -registerWithRegistry

### Community 37 - "Community 37"
Cohesion: 0.67
Nodes (2): PeriodStats, Transaction

### Community 38 - "Community 38"
Cohesion: 1.0
Nodes (1): MainActivity

### Community 39 - "Community 39"
Cohesion: 1.0
Nodes (1): ApiService

### Community 40 - "Community 40"
Cohesion: 1.0
Nodes (1): Either

### Community 41 - "Community 41"
Cohesion: 1.0
Nodes (1): LoginResponse

## Knowledge Gaps
- **752 isolated node(s):** `MainActivity`, `Intercept NOTIFY_DEBUGGER_ABOUT_RX_PAGES and touch the pages.`, `-registerWithRegistry`, `MyApp`, `build` (+747 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **Thin community `Community 28`** (7 nodes): `FlutterAppDelegate`, `AppDelegate.swift`, `AppDelegate.swift`, `AppDelegate`, `.application()`, `.applicationShouldTerminateAfterLastWindowClosed()`, `.applicationSupportsSecureRestorableState()`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 31`** (5 nodes): `RunnerTests.swift`, `RunnerTests.swift`, `RunnerTests`, `.testExample()`, `XCTestCase`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 34`** (4 nodes): `handle_new_rx_page()`, `__lldb_init_module()`, `Intercept NOTIFY_DEBUGGER_ABOUT_RX_PAGES and touch the pages.`, `flutter_lldb_helper.py`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 35`** (3 nodes): `GeneratedPluginRegistrant.java`, `GeneratedPluginRegistrant`, `.registerWith()`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 36`** (3 nodes): `GeneratedPluginRegistrant.m`, `GeneratedPluginRegistrant`, `-registerWithRegistry`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 37`** (3 nodes): `PeriodStats`, `Transaction`, `bids_models.dart`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 38`** (2 nodes): `MainActivity.kt`, `MainActivity`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 39`** (2 nodes): `ApiService`, `api_service.dart`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 40`** (2 nodes): `Either`, `either.dart`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 41`** (2 nodes): `LoginResponse`, `login_response.dart`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `package:flutter/material.dart` connect `Community 8` to `Community 0`, `Community 1`, `Community 2`, `Community 3`, `Community 4`, `Community 5`, `Community 6`, `Community 7`, `Community 9`, `Community 10`, `Community 11`, `Community 13`, `Community 15`, `Community 16`, `Community 17`, `Community 18`, `Community 19`, `Community 20`, `Community 21`, `Community 22`, `Community 23`, `Community 25`, `Community 26`, `Community 27`?**
  _High betweenness centrality (0.284) - this node is a cross-community bridge._
- **Why does `package:flutter_screenutil/flutter_screenutil.dart` connect `Community 0` to `Community 1`, `Community 2`, `Community 3`, `Community 4`, `Community 5`, `Community 6`, `Community 7`, `Community 8`, `Community 9`, `Community 10`, `Community 11`, `Community 13`, `Community 15`, `Community 16`, `Community 17`, `Community 18`, `Community 19`, `Community 20`, `Community 21`, `Community 22`, `Community 23`, `Community 25`, `Community 26`, `Community 27`?**
  _High betweenness centrality (0.164) - this node is a cross-community bridge._
- **Why does `package:rionydo/app_utils/utils/app_colors.dart` connect `Community 0` to `Community 1`, `Community 2`, `Community 3`, `Community 4`, `Community 5`, `Community 6`, `Community 7`, `Community 8`, `Community 9`, `Community 10`, `Community 11`, `Community 15`, `Community 16`, `Community 17`, `Community 18`, `Community 19`, `Community 20`, `Community 21`, `Community 22`, `Community 23`, `Community 25`, `Community 26`, `Community 27`?**
  _High betweenness centrality (0.151) - this node is a cross-community bridge._
- **What connects `MainActivity`, `Intercept NOTIFY_DEBUGGER_ABOUT_RX_PAGES and touch the pages.`, `-registerWithRegistry` to the rest of the system?**
  _752 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.03 - nodes in this community are weakly interconnected._
- **Should `Community 1` be split into smaller, more focused modules?**
  _Cohesion score 0.03 - nodes in this community are weakly interconnected._
- **Should `Community 2` be split into smaller, more focused modules?**
  _Cohesion score 0.04 - nodes in this community are weakly interconnected._
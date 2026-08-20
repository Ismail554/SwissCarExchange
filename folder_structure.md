# Swiss Car Exchange (Rionydo) — Ultimate Future-Ready MVVM Directory Blueprint

This document defines the reference **MVVM (Model-View-ViewModel)** architectural pattern and folder structure designed for maximum scalability, testability, and clean separation of concerns in future production-grade Flutter applications.

---

## 1. Architectural Blueprint (Core Pattern)

The structure isolates visual layout logic, state machine controllers, and hardware/network infrastructures:

```mermaid
graph TD
    subgraph UI Layer (Views)
        View[Screens / Cards / Dialogs] -->|1. User Interacts / Inputs| Action[Dispatch ViewModel Command]
        Render[Dynamic Rebuild] <---|4. Observe via context.select / watch| ViewModel
    end

    subgraph Presentation & State Layer (ViewModels)
        Action -->|2. Runs Logic / Sanitizes| ViewModel[ChangeNotifier Providers]
        ViewModel -->|Updates status parameters| LocalState[isLoading / errorText / dataState]
    end

    subgraph Service & Persistence Layer (Services)
        ViewModel -->|3. Requests Network / Native API| ServiceManager[AppService / ConnectivityService]
        ServiceManager -->|Executes request| Network[DioService / StorageService / CacheService]
        Network -->|Returns DTO| Model[Strongly Typed Models / DTOs]
        Model -.->|Maps data payload| ViewModel
    end
    
    style View fill:#004d4d,stroke:#00cccc,stroke-width:2px,color:#fff
    style ViewModel fill:#800020,stroke:#ff3366,stroke-width:2px,color:#fff
    style ServiceManager fill:#333,stroke:#666,stroke-width:1px,color:#fff
    style Model fill:#003366,stroke:#0066cc,stroke-width:1px,color:#fff
```

### Clean Architecture Ground Rules:
* **Zero UI inside ViewModels**: Controllers must never import `package:flutter/material.dart` (except for `ChangeNotifier` itself) and must not refer to widgets or context styling directly.
* **Strict Serialization Boundaries**: Data entering the system via `DioService` must immediately serialize into typed `Models` to prevent loose JSON maps from floating across presentation screens.
* **Reactive Binding**: Views subscribe to specific parameters of the ViewModel using `context.select<VM, Field>()` to optimize render cycles and avoid redundant widget rebuilds.

---

## 2. Comprehensive Directory Structure Map

Below is the definitive folder mapping detailing the location of all architectural components, core managers, utilities, and views:

```
lib/
├── main.dart                          # App entrypoint. Load assets, load env, trigger boots, boot MultiProvider
├── app.dart                           # Root MaterialApp config. Setup themes, ScreenUtil, and GoRouter bindings
├── app_router.dart                    # Centralized GoRouter manager. Shell routes, guard criteria, and key paths
│
├── core/                              # Shared foundation layer (Isolated; never imports feature directories)
│   │
│   ├── constants/                     # Immutable app configurations and UI design tokens
│   │   ├── api_endpoints.dart         # Path directories for remote REST & WebSocket APIs
│   │   ├── app_padding.dart           # Static responsive margin and padding standards
│   │   └── font_manager.dart          # Centralized TextStyle specifications (weights, sizes)
│   │
│   ├── services/                      # Infrastructural and hardware interfaces
│   │   ├── app_service.dart           # Central boot manager coordinating overall startup sequences
│   │   ├── cache_service.dart         # High-speed memory storage for running application states
│   │   ├── connectivity_service.dart  # Evaluates physical internet connection status (WiFi/Cellular)
│   │   ├── dio_service.dart           # Base HTTP engine managing query parameters and security tokens
│   │   ├── permission_manager.dart    # Standardized drawer requesting system/device permission keys
│   │   ├── storage_service.dart       # Secure encrypted local persistence (Secure Storage / Hive / SharedPref)
│   │   └── theme_service.dart         # Local controller toggling dark/light settings and saving user state
│   │
│   ├── utils/                         # Global pure processing helpers
│   │   ├── app_colors.dart            # Brand primary, accent, dark background, and secondary color codes
│   │   ├── app_spacing.dart           # Standardized vertical/horizontal gap parameters (SizedBox heights)
│   │   ├── app_strings.dart           # Centralized localized string configurations and alert message maps
│   │   ├── asset_manager.dart         # Relative path mappings for vector icons, pictures, and lottie files
│   │   ├── offline_support.dart       # Dynamic sync queues, offline storage caches, and connection checkers
│   │   ├── platform_utility.dart      # Evaluates device states (Android vs iOS vs Web)
│   │   └── validator.dart             # Pure email, password complexity, and empty form validators
│   │
│   └── widgets/                       # Core reusable visuals used across all modules
│       ├── common_background.dart     # Responsive layout scaffold equipped with premium gradients
│       ├── custom_button.dart         # Action button supporting real-time visual loading indicators
│       ├── custom_snackbar.dart       # Customized notification toast alerts (success, failure, warning)
│       └── network_info_bar.dart      # Dynamic top-level alert displayed when connectivity is lost
│
├── models/                            # Plain Dart classes, Domain Entities, & JSON Parsers
│   ├── user_model.dart                # User auth credentials configuration DTO
│   ├── auction_model.dart             # Details, specs, countdown timers, bidding list schemas
│   └── navigation_item.dart           # Tab indicators and routing variables
│
├── controllers/ (or viewmodels/)      # State controllers managing view variables and event commands
│   ├── auth_provider.dart             # Coordinates session lifecycles, user authentication, logouts
│   ├── onboarding_provider.dart       # Form tracking, page views, slider indices, and completion gates
│   ├── theme_provider.dart            # Subscribes to ThemeService to dynamically shift brightness
│   └── navigation_provider.dart       # Keeps active tabs, indices, and page transitions
│
└── views/                             # Visual Presentation layer (Screens, Widgets, & Painters)
    ├── splash/                        # Launcher entry view evaluating session state before navigation
    │   └── splash_view.dart
    │
    ├── onboarding/                    # Informational introduction slider view
    │   └── onboarding_view.dart
    │
    ├── basic_navigation/              # Persistent layout framing for index stacked dashboard shell
    │   ├── widgets/
    │   └── bottom_nav_view.dart
    │
    └── home/                          # User feeds and real-time statistics
        ├── widgets/                   # Highly localized cards, buttons, or scroll lists
        └── home_view.dart
```

---

## 3. Core Component Roles & Integration Guidelines

### 📶 Offline Support & Network Info (`connectivity_service.dart` & `offline_support.dart`)
* **Role**: Monitors hardware network capabilities continuously.
* **Interaction**: `connectivity_service.dart` broadcasts current connection states. When standard internet is lost, `network_info_bar.dart` renders a persistent, non-dismissible barrier. Failed transactions are queued inside `offline_support.dart` to trigger retry pipelines upon connection restoration.

### 🔒 Core Permission Manager (`permission_manager.dart`)
* **Role**: Abstracts native Android/iOS permission requests (Camera, Storage, Location).
* **Interaction**: View layer calls helper functions within `PermissionManager` which interact with native SDK platforms to prompt users. If rejected, the manager navigates to system settings seamlessly.

### 🔑 Shared Local Storage & Caching (`storage_service.dart` & `cache_service.dart`)
* **Role**: `storage_service.dart` handles persistent key-value encryption (auth tokens, refresh codes). `cache_service.dart` holds volatile, high-speed RAM structures.
* **Interaction**: Auth ViewModels read tokens from secure storage at runtime to skip login gates during launch checks.

---

## 4. Standard Implementation Flow Example (User Sign In)

### Step 1: State Holder (ViewModel / Controller)
```dart
// Path: lib/controllers/auth_provider.dart
import 'package:flutter/foundation.dart';
import 'package:rionydo/core/services/dio_service.dart';
import 'package:rionydo/core/services/storage_service.dart';
import 'package:rionydo/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final DioService _dioService = DioService();
  final StorageService _storageService = StorageService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserModel? _user;
  UserModel? get user => _user;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners(); // View rebuilds instantly to show loading indicator

    try {
      final response = await _dioService.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        // Parse payload into a model
        _user = UserModel.fromJson(response.data);
        
        // Persist session tokens
        await _storageService.writeSecure('token', _user!.accessToken);
        
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Sign in flow exception: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners(); // View rebuilds to hide loading indicator
    }
  }
}
```

### Step 2: Presentation Layer (View Screen)
```dart
// Path: lib/views/home/login_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rionydo/controllers/auth_provider.dart';
import 'package:rionydo/core/widgets/custom_button.dart';
import 'package:rionydo/core/widgets/custom_text_field.dart';
import 'package:rionydo/core/widgets/custom_snackbar.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _onLoginPressed() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      CustomSnackBar.error(context, message: 'Please enter all credentials');
      return;
    }

    final success = await context.read<AuthProvider>().login(email, password);
    
    if (success && mounted) {
      CustomSnackBar.success(context, message: 'Welcome back!');
      Navigator.pushReplacementNamed(context, '/home');
    } else if (mounted) {
      CustomSnackBar.error(context, message: 'Invalid credentials or request error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Rebuild only when AuthProvider.isLoading changes
    final isLoading = context.select<AuthProvider, bool>((vm) => vm.isLoading);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(controller: _emailController, hintText: 'Email'),
            const SizedBox(height: 16),
            CustomTextField(controller: _passwordController, hintText: 'Password', obscureText: true),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Login',
              isLoading: isLoading,
              onPressed: _onLoginPressed,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
```

---

&copy; 2026 Architectural Engineering Standards. All upcoming application modules must strictly observe this reference blueprint.

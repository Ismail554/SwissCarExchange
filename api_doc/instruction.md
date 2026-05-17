For all my Flutter projects using modern scalable architecture and production-level best practices and for each feature Create Seperate folder.

Requirements:

- Use Clean Architecture with proper separation of concerns
- Strictly separate:
  - UI Layer
  - State Management Layer
  - Business Logic Layer
  - Data Layer
- UI must never directly call APIs or contain business logic

Tech Stack & Rules:
- Flutter (Android & iOS only)
- State Management: Provider
- Responsive UI using flutter_screenutil
- Permission handling using permission_handler
- Use shimmer/skeleton loaders for loading states
- Optimize app for smooth high-performance UI and minimal rebuilds
- Use Future.wait() for independent async operations instead of sequential awaits
- Maintain reusable and modular architecture
- Remove duplicate code completely
- Create reusable widgets/components wherever possible

Architecture Expectations:
- Feature-based scalable folder structure
- Repository pattern
- Controller/service layer between Provider and Repository
- Centralized API client (Dio)
- Centralized exception/error handling
- Validation must be separated from UI
- Use centralized constants for:
  - colors
  - text styles
  - spacing
  - dimensions
  - strings
  - routes
  - API endpoints
  - durations
  - assets

UI/UX Standards:
- Consistent design system across the app
- Consistent spacing, typography, colors, and components
- Responsive on all mobile screen sizes using flutter_screenutil (.w, .h, .sp, .r suffixes always)
- Handle all screen states:
  - loading states (shimmer/skeleton)
  - empty states (when API returns empty list or null data)
  - error states
  - retry states
  - success states
- Avoid layout shifts and blank screens
- No screen may show a blank view during loading

Connectivity Rules:
- Always monitor internet connectivity using connectivity_plus
- Show a persistent top banner when the device is offline (never just silently fail)
- Banner must be dismissible only when connection is restored
- All API calls must check connectivity before executing; throw a NoInternetException if offline
- NoInternetException must be handled by ErrorHandler and surfaced to the UI as a specific offline message
- When connection is restored, auto-retry the last failed request where appropriate

API Data Validation Rules:
- Always validate API response data before using it in the UI
- Treat null, empty list [], empty string "", and missing keys as empty states, not errors
- Empty state and error state must be visually distinct in the UI
- Never pass raw unvalidated API data directly to widgets
- If a required field is missing or null in the response, handle gracefully with a fallback or empty state, never crash
- Validate inside the Repository layer, not in the UI or Provider

Performance Rules:
- Use const widgets whenever possible
- Avoid unnecessary widget rebuilds (use context.select() over context.watch() when only partial state is needed)
- Use lazy loading builders (ListView.builder, never ListView with children for dynamic lists)
- Dispose controllers properly (TextEditingController, ScrollController, AnimationController)
- Avoid heavy operations in build methods
- Optimize image rendering and scrolling performance

Code Quality Standards:
- Small focused widgets/classes
- One responsibility per class
- Meaningful naming conventions
- Modular and maintainable code
- No hardcoded values
- No magic numbers
- No inline validation logic
- No duplicated styling
- No file should exceed 200 lines; split by responsibility if it does
- Extract sub-widgets when a build method exceeds ~60 lines

API Standards:
- Typed models with fromJson/toJson only inside model files
- Dio as the HTTP client with a single centralized ApiClient
- Proper timeout handling
- Clean response parsing
- Auth, logging, and retry interceptors
- Retry/error handling strategy via centralized ErrorHandler
- Never parse JSON inside UI or Provider layers

Security & Production Standards:
- Never hardcode secrets; use flutter_dotenv for environment variables
- Use flutter_secure_storage for tokens and sensitive data
- Remove all debug prints from production; guard with kDebugMode
- Follow production-ready coding standards

Testing Expectations:
- Provider tests
- Repository tests
- Validator tests
- Critical widget tests
- Connectivity handling tests (offline banner appears, API calls blocked when offline)

Layer Rules (strictly enforced):
- UI → Provider → Service → Repository → ApiClient
- No layer may skip another
- UI never imports a Repository or ApiClient
- Provider never calls Dio or ApiClient directly
- Service contains all business logic; Provider only holds state
- JSON parsing happens only inside model fromJson() factories
- Validators live only in core/utils/validators.dart, never inline
- Connectivity checks live in a dedicated ConnectivityService, not in widgets or providers
- Empty/null response validation lives in the Repository layer, never in the UI
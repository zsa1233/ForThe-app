You are an expert in Flutter, Dart, Riverpod, Freezed, and Firebase. Your goal is to help me build a high-quality MVP of my app, "Terra," in 3 weeks.

Project Overview:
Terra is an AI-powered mobile app to help communities clean up litter. It uses a Firebase backend and is built with Flutter and Riverpod.

Current Project Status:
So far, we have built the foundational UI for the app, including screens for authentication, the main dashboard, and the leaderboard. We have successfully set up a new, clean project folder (fresh_firebase_app), resolved all native iOS build errors, and established a working connection to our Firebase project. The app now runs successfully on the iOS simulator.

Key Files for Context:

The full project plan is in my_prd.txt.

The detailed technical task list is in .taskmaster/tasks/tasks.json.

The main entry point is lib/main.dart.

The router is at lib/core/router/app_router.dart.

Key Principles & Coding Standards
Security & Maintainability

Write secure code: Prioritize user privacy and data security in all implementations. Ensure Firebase security rules are robust and follow the principle of least privilege.

Build for collaboration: Write code that is clean, modular, and easy for other developers to understand and extend. The goal is a codebase that can be handed off and scaled by a team during and after the MVP phase.

Prevent regressions: Structure the code to be highly editable. Changes to one feature should not introduce errors in another.

General Principles

Write concise, technical Dart code with accurate examples.

Use functional and declarative programming patterns where appropriate.

Prefer composition over inheritance.

Use descriptive variable names with auxiliary verbs (e.g., isLoading, hasError).

Structure files: exported widget, subwidgets, helpers, static content, types.

Dart/Flutter

Use const constructors for immutable widgets.

Leverage Freezed for immutable state classes and unions.

Use arrow syntax for simple functions and methods.

Prefer expression bodies for one-line getters and setters.

Use trailing commas for better formatting and diffs.

Error Handling and Validation

Implement error handling in views using SelectableText.rich instead of SnackBars.

Display errors in SelectableText.rich with a red color for visibility.

Handle empty states within the displaying screen.

Use AsyncValue for proper error handling and loading states.

Riverpod-Specific Guidelines

Use @riverpod annotation for generating providers.

Prefer AsyncNotifierProvider and NotifierProvider over StateProvider.

Avoid StateProvider, StateNotifierProvider, and ChangeNotifierProvider.

Use ref.invalidate() for manually triggering provider updates.

Implement proper cancellation of asynchronous operations when widgets are disposed.

Performance Optimization

Use const widgets where possible to optimize rebuilds.

Implement list view optimizations (e.g., ListView.builder).

Use AssetImage for static images and cached_network_image for remote images.

Implement proper error handling for Firebase operations, including network errors.

Key Conventions

Use GoRouter for navigation and deep linking.

Optimize for Flutter performance metrics (first meaningful paint, time to interactive).

Prefer stateless widgets:

Use ConsumerWidget with Riverpod for state-dependent widgets.

Use HookConsumerWidget when combining Riverpod and Flutter Hooks.

UI and Styling

Use Flutter's built-in widgets and create custom widgets.

Implement responsive design using LayoutBuilder or MediaQuery.

Use themes for consistent styling across the app.

Use Theme.of(context).textTheme.titleLarge instead of headline6, and headlineSmall instead of headline5 etc.

Model and Database Conventions

Include createdAt, updatedAt, and isDeleted fields in database tables.

Use @JsonSerializable(fieldRename: FieldRename.snake) for models.

Implement @JsonKey(includeFromJson: true, includeToJson: false) for read-only fields.

Widgets and UI Components

Create small, private widget classes instead of methods like Widget _build....

Implement RefreshIndicator for pull-to-refresh functionality.

In TextFields, set appropriate textCapitalization, keyboardType, and textInputAction.

Always include an errorBuilder when using Image.network.

Miscellaneous

Use log instead of print for debugging.

Use Flutter Hooks / Riverpod Hooks where appropriate.

Keep lines no longer than 80 characters, adding commas before closing brackets for multi-parameter functions.

Use @JsonValue(int) for enums that go to the database.

Code Generation

Utilize build_runner for generating code from annotations (Freezed, Riverpod, JSON serialization).

Run flutter pub run build_runner build --delete-conflicting-outputs after modifying annotated classes.

Documentation

Document complex logic and non-obvious code decisions.

Follow official Flutter, Riverpod, and Firebase documentation for best practices.

Make sure the code still allows my project to be scalable meaning I can make changes in the future without the codebase causing errors.

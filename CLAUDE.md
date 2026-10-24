# Administration App

## Purpose

Flutter desktop client for managing MML admins, groups, clients, and records. It targets Windows, Linux, and macOS and talks to the configured backend over HTTPS.

## Code map

- `lib/main.dart` initializes HTTP overrides, image caching, and `MMLApp`.
- `lib/views` contains screens; `lib/components` contains reusable widgets.
- `lib/view_models` coordinates view state; `lib/services` contains API and integration services.
- `lib/models`, `lib/manager`, and `lib/extensions` contain domain data and shared helpers.
- `assets/` contains images and animations; generated files live under `lib/gen` and localization under `lib/l10n`.

Preserve the existing Provider-based state-management and service boundaries. Keep generated files generated and do not hand-edit them unless the generator workflow requires it.

## Local commands

```bash
flutter pub get
dart format .
flutter analyze
flutter test
flutter run
```

Use the platform-specific Flutter target when needed. The backend must be configured before running the app. Build packaging follows the existing Windows/Linux/macOS configuration and `msix_config` in `pubspec.yaml`.

## Rules

- Keep admin authorization and backend contracts compatible with `mml.identity` and `mml.media`.
- Do not weaken certificate handling or store credentials in source code.
- Add focused tests for changed view models, services, parsing, and user-visible behavior where practical.
- Update the relevant `mml.project/docs` setup, customization, concept, or architecture page when behavior or configuration changes.

## graphify

This project has a knowledge graph at graphify-out/ with god nodes, community structure, and cross-file relationships.

Rules:
- For codebase questions, first run `graphify query "<question>"` when graphify-out/graph.json exists. Use `graphify path "<A>" "<B>"` for relationships and `graphify explain "<concept>"` for focused concepts. These return a scoped subgraph, usually much smaller than GRAPH_REPORT.md or raw grep output.
- If graphify-out/wiki/index.md exists, use it for broad navigation instead of raw source browsing.
- Read graphify-out/GRAPH_REPORT.md only for broad architecture review or when query/path/explain do not surface enough context.
- After modifying code, run `graphify update .` to keep the graph current (AST-only, no API cost).

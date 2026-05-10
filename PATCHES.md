# Patches & Improvements (Lusan Sapkota Fork)

This document tracks the improvements and fixes applied to this fork of the Resource Monitor GNOME Shell extension.

## Integrated Pull Requests
- **Community Contributions**: Integrated 3 stale pull requests from the upstream repository to bring the extension up to date with community-driven fixes and features.

## Interaction & Navigation
- **Configurable Click Actions**: Added support for custom left-click behaviors via the preferences menu.
- **Reliable Settings Launch**: Implemented a robust fallback system using `Main.extensionManager` to ensure the preferences window opens even in restrictive GNOME environments.
- **Dynamic Tooltips**: Updated the panel indicator to show current interaction mappings dynamically.

## Robust Application Discovery
- **Smart Monitor Lookup**: Completely overhauled how the extension finds and launches system monitors. It now searches for:
    - Modern GNOME System Monitor (`org.gnome.SystemMonitor`)
    - Mission Center (`io.missioncenter.MissionCenter`)
    - Resources (`net.nokyan.Resources`)
    - GNOME Usage (`org.gnome.Usage`)
- **Fuzzy Search Fallback**: If standard IDs aren't found, the extension performs a fuzzy search by name and ID through all installed applications.
- **Command-Line Matching**: Added the ability to identify applications by matching their internal command-line strings.
- **PATH-based Fallback**: Added a final fallback that checks the system `PATH` for common binary names.

## Compatibility & Stability
- **GNOME 45/50+ Support**: Modernized the codebase for ESM (ECMAScript Modules) and fixed compatibility issues with newer GNOME Shell versions (up to 50.1).
- **Robust Launch Logic**: Added safety checks for `app.activate()`, `app.launch()`, and `app.open_new_window()` to handle differences in how various GNOME versions manage application objects.
- **Settings Integrity**: Cleaned up orphaned GSettings references to prevent "key undefined" errors in the shell logs.

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.1.0]
### Added
- **Dynamic Multi-language i18n:** Native support for 15 languages, including Venezuelan Spanish, French, Portuguese, Japanese, Esperanto, among others.
- **Real-time Switch:** Ability to change the language instantly without needing to reload the application.
- **Biography:** Inclusion of the author's full biography (VenezuenBiggie24) in the "About" section.

## [3.0.0]
### Changed
- **Official Rebranding:** The project was officially renamed to **PKGMachete**.
- **Massive Redesign (Premium UI):** Completely revamped interface with a "Premium/Gamer" style, utilizing Glassmorphism, cyberpunk dark themes, and cyan gradients.

### Added
- **Real-time Log Console:** Integration of an in-app console to monitor the live output of the C++ engine.
- **Automatic Installer:** Inclusion of the `build_dmg.sh` script with a `.command` file to facilitate installation and bypass Gatekeeper automatically.

## [2.2.0]
### Added
- **Custom Output:** Ability to select a specific output directory (previously restricted to the same source folder).
- **ETA (Estimated Time):** Implementation of a live mathematical algorithm to calculate and display the estimated time of completion.

## [2.1.0]
### Added
- **PS5 Support:** Official built-in support for merging PlayStation 5 PKG files.
- **Graphical Interface (V1):** Creation of the first basic version of the Graphical User Interface using SwiftUI.

### Changed
- **Engine Rewrite:** Algorithm rewritten to a "two-pass" system to prevent the generation of orphaned files during the merging process.

## [2.0.0]
### Changed
- **macOS Port:** Native migration of the C++ engine to macOS using `clang++` compilation, handled by VenezuenBiggie24.

## [1.0.0]
### Added
- **Original Project:** CLI tool developed in C++ to merge split PS4/PS5 PKG files on Windows systems. Originally created by Tustin (https://github.com/Tustin/pkg-merge).

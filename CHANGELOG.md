# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [5.0.0] - 2026-07-27
### Added
- **Dynamic In-App Changelog:** A new UI modal in the Header to view the version history and new features seamlessly.
- **GitHub Link:** Added a direct repository link in the Header UI (curly braces icon).
- **Environment Isolation:** Forced `process.environment = [:]` to clear runtime variables, neutralizing potential injection vectors into the C++ binary from macOS terminal/sandbox environments.

### Changed
- **Asynchronous UI Rendering (SwiftUI):** Moved the `JSONDecoder` of the backend output (`parseOutput()`) into a background `DispatchQueue` to eliminate UI freezing and frame-drops when reading heavy JSON streams.
- **Per-Thread Descriptors:** (C++) Replaced shared file descriptors with thread-local descriptors, eliminating VFS Lock contention and maximizing I/O performance on macOS.
- **Page Cache Management:** Implemented `fcntl` with `F_NOCACHE` (macOS) to bypass the system's page cache and avoid RAM saturation during massive file merges.
- **Magic Bytes Validation:** Integrated mandatory `has_pkg_magic()` pre-flight checks to actively reject counterfeit or maliciously formatted PKG chunks before any merging occurs.

### Fixed
- **JSON Serialization:** Replaced plain-text logs with serialized, escaped JSON using a custom `escape_json()` parser in C++, ensuring data stability for inter-process communication.
- **Out-Of-Bounds Crash Fix:** Corrected bounds validation when detecting `part_str` suffix in filename chunking logic.

## [4.0.0] - 2026-07-26
### Added
- **Multi-Threading Support:** Integrated hardware-level concurrency by dispatching chunks across available CPU cores natively via `<thread>`.
- **Intelligent I/O Allocation:** Implemented direct parallel I/O with `pwrite()` and intelligent pre-allocation using `F_PREALLOCATE` (`fcntl`) for zero-time file building on macOS drives.
- **Dracarys Magic Override (Easter Egg):** A new "Force Merge" UI prompt titled "Dracarys! (Usar Magia)". It gracefully hooks into `pkgmachete-cli --force` allowing power users to bypass mathematical chunk-validation for non-standard PKGs, injecting Game of Thrones easter eggs to the error logs.

### Changed
- **C++20 Migration:** Upgraded the core engine to modern C++20 standard, replacing obsolete data structures with `std::string_view` and `std::filesystem` for extreme speed tuning.

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

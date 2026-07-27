# 🗡️ PKGMachete: The Ultimate Multi-Platform Merger

![macOS](https://img.shields.io/badge/macOS-000000?style=for-the-badge&logo=apple&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Windows](https://img.shields.io/badge/Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![Status](https://img.shields.io/badge/Status-Active-success?style=for-the-badge)

**PKGMachete** is the ultimate tool designed to efficiently merge split PlayStation 4 and PlayStation 5 PKG files. What started as a macOS exclusive has evolved into a fully robust, state-of-the-art **Multi-Platform Ecosystem**. 

Whether you are on a high-end Mac, a custom Linux rig, a Windows gaming PC, or your Android smartphone, merging your backups has never been easier, faster, and more stylish. Our engine is engineered to prevent freezing, ensure 100% data integrity, and take full advantage of native OS capabilities.

## ✨ Multi-Platform Power & Stability

Our commitment to quality means PKGMachete runs natively and flawlessly on all four platforms:

### 🍏 macOS (The Premium Edition)
- **UI:** Built in beautiful SwiftUI featuring Glassmorphism, subtle animations, and live ETA calculations.
- **Engine:** C++20 backend utilizing `F_NOCACHE` parallel I/O allocations to saturate modern NVMe drives without locking the OS cache.

### 🐧 Linux (The Hacker Edition)
- **UI:** Custom Qt C++ interface designed with rigorous throttling limits (50ms) to ensure the UI remains buttery smooth even when parsing millions of I/O operations per second.
- **Engine:** Fully asynchronous JSON stream parsing natively handling `stdout` and `stderr` independently.

### 🪟 Windows (The Gamer Edition)
- **UI:** WinUI 3 (C++/WinRT) using modern Mica and Glassmorphism effects.
- **Engine:** Employs raw `CreateFile` with `FILE_FLAG_NO_BUFFERING` alongside hardware-aligned `VirtualAlloc` buffers for extreme speeds. Uses `co_await winrt::resume_on_signal` to prevent the ThreadPool from ever freezing your system.

### 🤖 Android (The Mobile Edition)
- **UI:** Built in Kotlin with Coroutines running securely on `Dispatchers.IO` to guarantee your phone never experiences an ANR (Application Not Responding) crash.
- **Engine:** Uses the Storage Access Framework (SAF) passing secure File Descriptors directly to a native JNI/C++ backend, executing `pwrite()` POSIX syscalls to bypass Scoped Storage limits effortlessly without ROOT.

## 🚀 Key Shared Features
*   🎮 **Full PS4 & PS5 Support:** A guaranteed two-pass algorithm prevents corrupted or orphaned files.
*   🛡️ **Magic Bytes Validation:** Anti-tamper pre-flight system safely blocks fake chunks before merging.
*   🌍 **Dynamic Multi-language i18n:** Instantly switch between English, Spanish, French, Portuguese, Japanese, and more.
*   💻 **JSON Console Engine:** Advanced background logging serialized in pristine JSON for live monitoring.

## 📸 Screenshots

![Main Screen](screenshot.png)

## 📦 Installation & Releases

1. Go to the [Releases](#) tab on GitHub.
2. Download the version corresponding to your platform:
   - `.dmg` for macOS
   - `.zip` source files for Linux/Windows to compile directly via CMake.
   - Android source ready for Android Studio Native C++.

## 🤝 Credits & Acknowledgements

*   **Tustin:** Creator of the original CLI engine in C++ for Windows ([Tustin/pkg-merge](https://github.com/Tustin/pkg-merge)). Full credit goes to him for the original algorithm engineering and program foundation!
*   **VenezuenBiggie24:** Developer of the native ports, GUI architecture, and overall ecosystem orchestrator.

---
*Made with 🫀 and lots of dedication.*

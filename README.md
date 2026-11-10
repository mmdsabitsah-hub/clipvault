# ClipVault (Stages 1-2)

Setup:
  flutter create --org com.clipvault --project-name clipvault --platforms android .
  flutter pub get
  flutter run

Requires Flutter 3.27+ (CardThemeData, Color.toARGB32, withValues).
Add <uses-permission android:name="android.permission.INTERNET"/> to
android/app/src/main/AndroidManifest.xml before building a release APK.

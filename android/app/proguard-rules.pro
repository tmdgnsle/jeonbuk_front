# Preserve the developer.log() method calls
-keep class dart.** { *; }
-keep class io.flutter.** { *; }
-keep class android.util.Log { *; }

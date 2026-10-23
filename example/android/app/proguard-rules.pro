# ==============================================================================
# Hardened ProGuard / R8 Rules for Production Minification & High Obfuscation
# ==============================================================================

# ── Flutter Framework & Plugins ──────────────────────────────────────────────
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.engine.FlutterJNI {
    native <methods>;
}
-keep class io.flutter.embedding.engine.plugins.** { *; }

# Preserve native method declarations for JNI / FFI calls
-keepclasseswithmembernames class * {
    native <methods>;
}

# ── ML Kit & Camera Support ──────────────────────────────────────────────────
-dontwarn com.google.mlkit.**
-dontwarn com.google.android.gms.**
-dontwarn androidx.camera.**

# ── Obfuscation & Package Flattening ─────────────────────────────────────────
# Repackage all obfuscated classes into the root package to flatten hierarchy
-repackageclasses ''
-allowaccessmodification
-mergeinterfacesaggressively
-overloadaggressively

# Rename source file attributes to disguise original file structure
-renamesourcefileattribute SourceFile
-keepattributes SourceFile,LineNumberTable

# ── Strip Android Debug Logging in Release ───────────────────────────────────
-assumenosideeffects class android.util.Log {
    public static boolean isLoggable(java.lang.String, int);
    public static int v(...);
    public static int d(...);
    public static int i(...);
    public static int w(...);
}


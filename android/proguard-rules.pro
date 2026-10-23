# ==============================================================================
# Flutter Face Liveness - Consumer ProGuard / R8 Rules
# Injected into consuming applications to enable maximum minification & obfuscation
# ==============================================================================

# Keep Flutter plugin registration entry point for reflection
-keep public class com.cerisetechsolutions.flutter_face_liveness.FlutterFaceLivenessPlugin {
    public <init>();
}

# Preserve native method declarations for Dart FFI and JNI bindings
-keepclasseswithmembernames class * {
    native <methods>;
}

# TensorFlow Lite (JNI & C API runtime)
-keep class org.tensorflow.lite.** { *; }
-dontwarn org.tensorflow.lite.**

# Google ML Kit Vision & Face Detection
-dontwarn com.google.mlkit.**
-dontwarn com.google.android.gms.**
-dontwarn com.google.android.gms.internal.mlkit_vision_face.**

# AndroidX Camera
-dontwarn androidx.camera.**


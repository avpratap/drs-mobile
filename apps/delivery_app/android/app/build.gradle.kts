import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Release signing comes from android/key.properties (git-ignored; CI writes it from secrets).
// Without it, release builds fall back to the debug key so `flutter run --release` works locally.
// `flutter build/run --dart-define=K=V` reaches Gradle as the base64,
// comma-separated `dart-defines` property. Reading the Maps key from it keeps
// ONE source of truth for Dart and the Android manifest.
val dartDefines: Map<String, String> =
    (project.findProperty("dart-defines") as String?)
        ?.split(",")
        ?.mapNotNull { encoded ->
            runCatching { String(java.util.Base64.getDecoder().decode(encoded)) }.getOrNull()
        }
        ?.mapNotNull { pair -> pair.split("=", limit = 2).takeIf { it.size == 2 }?.let { it[0] to it[1] } }
        ?.toMap()
        ?: emptyMap()

val keystoreProperties = Properties().apply {
    val f = rootProject.file("key.properties")
    if (f.exists()) f.inputStream().use { load(it) }
}

android {
    namespace = "in.drsdairy.delivery"
    // Android 16 (API 36) SDK; matches Flutter 3.47 defaults.
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "in.drsdairy.delivery"
        // minSdk 24 = Android 7.0 (Flutter 3.47 default; flutter_secure_storage needs >= 23).
        minSdk = 24
        // Play requires targeting a recent API level; 36 = Android 16.
        targetSdk = 36
        // versionCode / versionName come from pubspec.yaml `version:`.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        // Never commit the key. Preferred: --dart-define=DRS_GOOGLE_MAPS_API_KEY=…
        // (same value the Dart side checks); env var / Gradle property also work.
        manifestPlaceholders["googleMapsApiKey"] =
            dartDefines["DRS_GOOGLE_MAPS_API_KEY"]
                ?: System.getenv("DRS_GOOGLE_MAPS_API_KEY")
                ?: (project.findProperty("DRS_GOOGLE_MAPS_API_KEY") as String?)
                ?: ""
    }

    signingConfigs {
        if (keystoreProperties.getProperty("storeFile") != null) {
            create("release") {
                storeFile = file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.findByName("release") ?: signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

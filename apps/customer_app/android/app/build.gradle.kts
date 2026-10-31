import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Release signing (see docs/RELEASE.md). Never committed. Sources, first wins:
//   1. Environment: DRS_ANDROID_KEYSTORE_PATH, DRS_ANDROID_KEYSTORE_PASSWORD,
//      DRS_ANDROID_KEY_ALIAS, DRS_ANDROID_KEY_PASSWORD (CI secrets).
//   2. android/key.properties: storeFile, storePassword, keyAlias, keyPassword
//      (git-ignored; for a local release machine).
// Deliberately NOT --dart-define: defines are compiled into the app binary.
// Without a keystore, release builds use the debug key so `flutter run
// --release` works locally; set DRS_REQUIRE_RELEASE_SIGNING=true (store
// builds) to fail instead.
val keystoreProperties = Properties().apply {
    val f = rootProject.file("key.properties")
    if (f.exists()) f.inputStream().use { load(it) }
}

fun signingValue(env: String, prop: String): String? =
    System.getenv(env)?.takeIf { it.isNotBlank() }
        ?: keystoreProperties.getProperty(prop)?.takeIf { it.isNotBlank() }

val releaseStoreFile: String? = signingValue("DRS_ANDROID_KEYSTORE_PATH", "storeFile")
val requireReleaseSigning = System.getenv("DRS_REQUIRE_RELEASE_SIGNING") == "true"

android {
    namespace = "in.drsdairy.customer"
    // Android 16 (API 36) SDK; matches Flutter 3.47 defaults.
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // Required by flutter_local_notifications (java.time on older Android).
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "in.drsdairy.customer"
        // minSdk 24 = Android 7.0 (Flutter 3.47 default; flutter_secure_storage needs >= 23).
        minSdk = 24
        // Play requires targeting a recent API level; 36 = Android 16.
        targetSdk = 36
        // versionCode / versionName come from pubspec.yaml `version:`.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // Build flavors (flutter run/build --flavor dev|prod). `dev` installs
    // side by side with `prod` (".dev" id suffix) and talks to a local
    // backend by default; `prod` defaults to the live backend. The Dart side
    // reads the flavor via `appFlavor` (see DrsEnv).
    buildFeatures {
        // AGP 9 turns resValue() off by default; the flavors use it for the
        // launcher label.
        resValues = true
    }

    flavorDimensions += "env"
    productFlavors {
        create("dev") {
            dimension = "env"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            resValue("string", "app_name", "DRS Dev")
        }
        create("prod") {
            dimension = "env"
            resValue("string", "app_name", "DRS Dairy")
        }
    }

    signingConfigs {
        if (releaseStoreFile != null) {
            create("release") {
                storeFile = file(releaseStoreFile)
                storePassword = signingValue("DRS_ANDROID_KEYSTORE_PASSWORD", "storePassword")
                keyAlias = signingValue("DRS_ANDROID_KEY_ALIAS", "keyAlias")
                keyPassword = signingValue("DRS_ANDROID_KEY_PASSWORD", "keyPassword")
            }
        }
    }

    buildTypes {
        release {
            val release = signingConfigs.findByName("release")
            if (release == null && requireReleaseSigning) {
                throw GradleException(
                    "Release signing required but no keystore configured (docs/RELEASE.md)",
                )
            }
            signingConfig = release ?: signingConfigs.getByName("debug")
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
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

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

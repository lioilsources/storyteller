import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Upload-signing credentials. `android/key.properties` is never committed: CI
// (.github/workflows/release-android.yml) writes it from the ANDROID_KEYSTORE_*
// secrets before `flutter build appbundle --release`. When the file is absent —
// every local checkout, every debug build — the release type falls back to the
// debug keys, so `flutter build apk --debug` and `flutter run` keep working
// without any keystore on the machine.
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.inputStream().use { keystoreProperties.load(it) }
}

android {
    // Left on the original id on purpose: it is the Kotlin package MainActivity
    // actually lives in (android/app/src/main/kotlin/com/lioilsources/storyteller),
    // and the manifest's `.MainActivity` is resolved against it. Only
    // applicationId — what Play/Firebase see — follows the com.ol1n.* convention.
    namespace = "com.lioilsources.storyteller"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // Must match the Firebase Android app's package name and the iOS bundle id
        // (com.ol1n.storyteller) — see RELEASING.md.
        applicationId = "com.ol1n.storyteller"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (keystorePropertiesFile.exists()) {
            create("release") {
                // storeFile is relative to this module dir (android/app/), which is
                // where CI decodes ANDROID_KEYSTORE_BASE64 to release.keystore.
                storeFile = file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (keystorePropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                // No upload keystore here — debug keys, so local release builds run.
                // A CI release build always writes key.properties first, so this
                // branch never produces an artifact that reaches Play or Firebase.
                signingConfigs.getByName("debug")
            }
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

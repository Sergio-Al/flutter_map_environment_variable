import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// load .env file from project root
val envFile = File(project.rootProject.projectDir.parentFile, ".env")
val envProperties = Properties()
if (envFile.exists()) {
    envProperties.load(FileInputStream(envFile))
    println("✓ Loaded .env file from ${envFile.absolutePath}")
} else {
    println("Warning: Environment file .env not found at ${envFile.absolutePath}")
    println("Using empty API key as fallback")
}

val googleMapsApiKey = envProperties.getProperty("GOOGLE_MAPS_API_KEY", "")

if (googleMapsApiKey.isEmpty()) {
    println("Warning: GOOGLE_MAPS_API_KEY is not set in the .env file.")
    println("Make sure to set it to avoid runtime issues.")
} else {
    println("✓ GOOGLE_MAPS_API_KEY loaded from .env file.")
}


android {
    namespace = "com.example.tarea_map"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.tarea_map"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        manifestPlaceholders["googleMapsApiKey"] = googleMapsApiKey
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

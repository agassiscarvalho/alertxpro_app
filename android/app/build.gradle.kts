plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")

    // FIREBASE
    id("com.google.gms.google-services")
}

android {
    namespace = "dev.agassis.alertxpro.alertxpro_app"

    // ANDROID SDK
    compileSdk = 36

    defaultConfig {
        applicationId = "dev.agassis.alertxpro.alertxpro_app"

        minSdk = flutter.minSdkVersion

        targetSdk = 36

        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        isCoreLibraryDesugaringEnabled = true

        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    // DESUGAR
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}

flutter {
    source = "../.."
}
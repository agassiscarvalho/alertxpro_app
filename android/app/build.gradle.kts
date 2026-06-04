plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "dev.agassis.alertxpro.alertxpro_app"

    // 🔥 ATUALIZADO (OBRIGATÓRIO)
    compileSdk = 36

    defaultConfig {
        applicationId = "dev.agassis.alertxpro.alertxpro_app"

        // 👇 IMPORTANTE (mínimo recomendado pro plugin)
        minSdk = flutter.minSdkVersion

        // 🔥 ATUALIZADO
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
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}

flutter {
    source = "../.."
}

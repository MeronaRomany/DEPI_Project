plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.depi_project"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    // 1. إعدادات التوقيع الموحدة للتيم
    signingConfigs {
        getByName("debug") {
            // يتوقع وجود الملف في نفس فولدر الـ app
            storeFile = file("debug.keystore")
            storePassword = "android"
            keyAlias = "androiddebugkey"
            keyPassword = "android"
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.depi_project"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        getByName("debug") {
            // ربط نسخة الـ debug بالإعدادات الموحدة
            signingConfig = signingConfigs.getByName("debug")
        }
        release {
            // تأكدي من تغيير هذا عند رفع التطبيق للمتجر فعلياً
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
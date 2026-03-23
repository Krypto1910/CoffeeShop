plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter Gradle Plugin
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.ct312h_project"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    defaultConfig {
        applicationId = "com.example.ct312h_project"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    // buildTypes {
    //     release {
    //         signingConfig = signingConfigs.getByName("debug")
    //     }
    // }

    signingConfigs {
        create("release") {
            storeFile = file("C:/Users/User/upload-keystore.jks")
            storePassword = "123456"
            keyAlias = "upload"
            keyPassword = "123456"
        }
    }

    buildTypes {
        release {
            // Chỉ định dùng cấu hình release vừa tạo ở trên
            signingConfig = signingConfigs.getByName("release")
            
            // Các cấu hình tối ưu hóa khác
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

dependencies {
    // 🔴 BẮT BUỘC cho flutter_local_notifications
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}

flutter {
    source = "../.."
}

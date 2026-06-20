plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.sesan_travel"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11

        // CHUYỂN DÒNG ĐÓ XUỐNG ĐÂY (nhớ có thêm chữ "is" ở đầu nha Nhi)
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.sesan_travel"
        minSdk = flutter.minSdkVersion // 21
        targetSdk = flutter.targetSdkVersion  // 34
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // GIỮ LẠI DÒNG NÀY Ở ĐÂY:
        multiDexEnabled = true
    }



    // ... các phần còn lại giữ nguyên
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

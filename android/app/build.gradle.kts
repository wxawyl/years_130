plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.live_to_130"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true   // 关键修复：使用 is 前缀
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()  // 暂时保留，虽然 deprecated 但还能用
        // 若要彻底消除警告，可改用下面的 compilerOptions（可选）
        // compilerOptions {
        //     jvmTarget.set(JavaVersion.VERSION_17.toString())
        // }
    }

    defaultConfig {
        applicationId = "com.example.live_to_130"
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    implementation("androidx.window:window:1.0.0")
    implementation("androidx.window:window-java:1.0.0")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

flutter {
    source = "../.."
}

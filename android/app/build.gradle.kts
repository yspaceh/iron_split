import java.util.Properties
import java.io.FileInputStream

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.ironsplit.iron_split"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.ironsplit.iron_split"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
            val storeFilePath = keystoreProperties.getProperty("storeFile")
            if (storeFilePath != null) {
                storeFile = file(storeFilePath)
            }
            storePassword = keystoreProperties.getProperty("storePassword")
        }
    }

    buildTypes {
        // Kotlin 必須用 getByName 來呼叫已存在的 release 區塊
        getByName("release") {
            // (原本 Flutter 預設的 minifyEnabled 等設定留著就好)
            signingConfig = signingConfigs.getByName("release")
        }
        
        getByName("debug") {
            // debug 什麼都不用加，系統會自動處理
        }
    }

    flavorDimensions += "default"

    productFlavors {
        // 2. 開發環境
        create("dev") {
            dimension = "default"
            applicationId = "com.ironsplit.dev"
            resValue("string", "app_name", "Iron Split Dev")
        }
        
        // 3. 正式環境
        create("prod") {
            dimension = "default"
            applicationId = "com.ironsplit.app"
            resValue("string", "app_name", "Iron Split")
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = "17"
    }
}

flutter {
    source = "../.."
}

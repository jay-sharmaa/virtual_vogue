plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.virtualvogue"
    compileSdk = flutter.compileSdkVersion ?: 34
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.virtualvogue"
        minSdk = 24
        targetSdk = flutter.targetSdkVersion ?: 34
        versionCode = flutter.versionCode ?: 1
        versionName = flutter.versionName ?: "1.0"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    buildFeatures {
        compose = true
    }

    composeOptions {
        kotlinCompilerExtensionVersion = "1.4.8" // Use a stable version
    }
}

dependencies {
    // Core Android dependencies
    implementation("androidx.core:core-ktx:1.10.1")

    // Compose dependencies - use the BOM for consistent versions
    implementation(platform("androidx.compose:compose-bom:2023.06.01"))
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.material3:material3")
    implementation("androidx.compose.ui:ui-tooling-preview")
    implementation("androidx.activity:activity-compose:1.7.2")
}

flutter {
    source = "../.."
}
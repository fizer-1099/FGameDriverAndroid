plugins { id("com.android.application") }

android {
    namespace = "ir.balasari.fgamedriver"
    compileSdk = 35
    defaultConfig {
        applicationId = "ir.balasari.fgamedriver"
        minSdk = 23
        targetSdk = 35
        versionCode = 1
        versionName = "1.0"
    }
}

dependencies {
    implementation("androidx.webkit:webkit:1.12.1")
}

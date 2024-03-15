package co.th.sic.nfcenabler

import android.os.Bundle
import android.os.PersistableBundle
import io.flutter.embedding.android.FlutterActivity
import com.microsoft.appcenter.AppCenter
import com.microsoft.appcenter.analytics.Analytics
import com.microsoft.appcenter.crashes.Crashes

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        AppCenter.start(application, "79e6b9c5-6be5-41bb-8972-20090aa34264",
                Analytics::class.java, Crashes::class.java)
        super.onCreate(savedInstanceState, persistentState)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }
}

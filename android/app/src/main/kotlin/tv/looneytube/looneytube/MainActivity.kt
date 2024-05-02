package tv.looneytube.looneytube

import android.content.Context
import android.os.Bundle
import androidx.annotation.NonNull
import com.google.android.gms.cast.framework.CastContext
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        val castContext = CastContext.getSharedInstance(this)

        super.onCreate(savedInstanceState)
    }
}

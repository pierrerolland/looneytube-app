package tv.looneytube.looneytube

import android.content.Context
import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.videoplayer.*

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine:
                                        FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.getPlugins().add(VideoPlayerPlugin())
    }
}

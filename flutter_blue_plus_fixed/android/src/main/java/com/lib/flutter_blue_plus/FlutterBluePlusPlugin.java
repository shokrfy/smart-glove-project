package com.lib.flutter_blue_plus;

import android.util.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;

public class FlutterBluePlusPlugin implements FlutterPlugin {
    @Override
    public void onAttachedToEngine(FlutterPluginBinding binding) {
        Log.i("FlutterBluePlus", "Plugin attached");
    }

    @Override
    public void onDetachedFromEngine(FlutterPluginBinding binding) {
        Log.i("FlutterBluePlus", "Plugin detached");
    }
}
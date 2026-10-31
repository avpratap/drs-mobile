import Flutter
import GoogleMaps
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    // The Maps key comes from Dart (--dart-define=DRS_GOOGLE_MAPS_API_KEY),
    // so it is never compiled into the iOS project. Dart only calls this when
    // a key is configured; without one the app shows a route sketch instead
    // of creating a map, so the SDK is never used uninitialised.
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "DrsMapsKey") {
      let channel = FlutterMethodChannel(name: "drs/maps", binaryMessenger: registrar.messenger())
      channel.setMethodCallHandler { call, result in
        guard call.method == "provideApiKey", let key = call.arguments as? String, !key.isEmpty else {
          result(false)
          return
        }
        result(GMSServices.provideAPIKey(key))
      }
    }
  }
}

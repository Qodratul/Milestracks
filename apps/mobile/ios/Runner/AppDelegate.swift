import Flutter
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
    let channel = FlutterMethodChannel(
      name: "com.milestracks/storage",
      binaryMessenger: engineBridge.engine.binaryMessenger
    )
    channel.setMethodCallHandler { call, result in
      guard call.method == "getApplicationSupportDirectory" else {
        result(FlutterMethodNotImplemented)
        return
      }
      do {
        let directory = try FileManager.default.url(
          for: .applicationSupportDirectory,
          in: .userDomainMask,
          appropriateFor: nil,
          create: true
        )
        result(directory.path)
      } catch {
        result(FlutterError(code: "storage_unavailable", message: error.localizedDescription, details: nil))
      }
    }
    let deviceChannel = FlutterMethodChannel(
      name: "com.milestracks/device",
      binaryMessenger: engineBridge.engine.binaryMessenger
    )
    deviceChannel.setMethodCallHandler { call, result in
      guard call.method == "getIanaTimezone" else {
        result(FlutterMethodNotImplemented)
        return
      }
      result(TimeZone.current.identifier)
    }
  }
}

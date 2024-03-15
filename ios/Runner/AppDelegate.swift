import UIKit
import Flutter
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    AppCenter.start(withAppSecret: "22f3aed5-0e51-437c-9fe8-742a081297dd", services:[
      Analytics.self,
      Crashes.self
    ])
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

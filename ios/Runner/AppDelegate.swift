import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // TODO: Add your Google Maps API Key
    GMSServices.provideAPIKey("AIzaSyAs0P-uY0grNE0Eg4r-yuy4C931jKgXve8")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

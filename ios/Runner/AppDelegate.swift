import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Get API key from Info.plist (configured via build environment)
    guard let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
          let plist = NSDictionary(contentsOfFile: path),
          let apiKey = plist["GMSApiKey"] as? String else {
      fatalError("Google Maps API key not found in Info.plist")
    }
    
    // Initialize Google Maps SDK with secure API key
    GMSServices.provideAPIKey(apiKey)
    
    // Log warning if using development key
    if apiKey.contains("development") || apiKey == "your-development-key-here" {
      print("⚠️  WARNING: Using development Google Maps API key")
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

import UIKit
import Flutter
import Firebase
import GoogleMaps
import flutter_downloader

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GMSServices.provideAPIKey("AIzaSyAoT3-7ga8TaBnb2X3ElYTfIP6hx78vHwE")
      let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
      FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
     
      FlutterDownloaderPlugin.setPluginRegistrantCallback({ registry in
              if (!registry.hasPlugin("FlutterDownloaderPlugin")) {
                     FlutterDownloaderPlugin.register(with: registry.registrar(forPlugin: "FlutterDownloaderPlugin")!)
                  }
          })

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

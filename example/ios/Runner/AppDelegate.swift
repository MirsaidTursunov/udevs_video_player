import UIKit
import AVFAudio
import AVFoundation
import GoogleCast
import Flutter

let kPrefAppVersion = "app_version"
let kPrefSDKVersion = "sdk_version"
let kPrefEnableMediaNotifications = "enable_media_notifications"

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    let kReceiverAppID = "7B356178"
    
    fileprivate var enableSDKLogging = false
    fileprivate var mediaNotificationsEnabled = false
    fileprivate var firstUserDefaultsSync = false
    fileprivate var useCastContainerViewController = false
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
              
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback)
        } catch  {
            print("Audio session failed")
        }
        populateRegistrationDomain()

        // We are forcing a custom container view controller, but the Cast Container is also available.
        useCastContainerViewController = false

        // Set your receiver application ID.
        let options = GCKCastOptions(discoveryCriteria: GCKDiscoveryCriteria(applicationID: kReceiverAppID))
        options.physicalVolumeButtonsWillControlDeviceVolume = true
        
        /** Following code enables CastConnect */
        let launchOption = GCKLaunchOptions()
        launchOption.androidReceiverCompatible = true
        options.launchOptions = launchOption
        
        GCKCastContext.setSharedInstanceWith(options)
        GCKCastContext.sharedInstance().useDefaultExpandedMediaControls = true

        GCKCastContext.sharedInstance().sessionManager.add(self)
        GCKCastContext.sharedInstance().imagePicker = self
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func setupCastLogging() {
      let logFilter = GCKLoggerFilter()
      let classesToLog = ["GCKDeviceScanner", "GCKDeviceProvider", "GCKDiscoveryManager",
                          "GCKCastChannel", "GCKMediaControlChannel", "GCKUICastButton",
                          "GCKUIMediaController", "NSMutableDictionary"]
      logFilter.setLoggingLevel(.verbose, forClasses: classesToLog)
      GCKLogger.sharedInstance().filter = logFilter
      GCKLogger.sharedInstance().delegate = self
    }
}


// MARK: - Working with default values

extension AppDelegate {
  func populateRegistrationDomain() {
    let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
    var appDefaults = [String: Any]()
    if let settingsBundleURL = Bundle.main.url(forResource: "Settings", withExtension: "bundle") {
      loadDefaults(&appDefaults, fromSettingsPage: "Root", inSettingsBundleAt: settingsBundleURL)
    }
    let userDefaults = UserDefaults.standard
    userDefaults.register(defaults: appDefaults)
    userDefaults.setValue(appVersion, forKey: kPrefAppVersion)
    userDefaults.setValue(kGCKFrameworkVersion, forKey: kPrefSDKVersion)
    userDefaults.synchronize()
  }

  func loadDefaults(_ appDefaults: inout [String: Any], fromSettingsPage plistName: String,
                    inSettingsBundleAt settingsBundleURL: URL) {
    let plistFileName = plistName.appending(".plist")
    let settingsDict = NSDictionary(contentsOf: settingsBundleURL.appendingPathComponent(plistFileName))
    if let prefSpecifierArray = settingsDict?["PreferenceSpecifiers"] as? [[AnyHashable: Any]] {
      for prefItem in prefSpecifierArray {
        let prefItemType = prefItem["Type"] as? String
        let prefItemKey = prefItem["Key"] as? String
        let prefItemDefaultValue = prefItem["DefaultValue"] as? String
        if prefItemType == "PSChildPaneSpecifier" {
          if let prefItemFile = prefItem["File"] as? String {
            loadDefaults(&appDefaults, fromSettingsPage: prefItemFile, inSettingsBundleAt: settingsBundleURL)
          }
        } else if let prefItemKey = prefItemKey, let prefItemDefaultValue = prefItemDefaultValue {
          appDefaults[prefItemKey] = prefItemDefaultValue
        }
      }
    }
  }

  @objc func syncWithUserDefaults() {
    let userDefaults = UserDefaults.standard

    let mediaNotificationsEnabled = userDefaults.bool(forKey: kPrefEnableMediaNotifications)
    GCKLogger.sharedInstance().delegate?.logMessage?("Notifications on? \(mediaNotificationsEnabled)", at: .debug, fromFunction: #function, location: "AppDelegate.swift")

    if firstUserDefaultsSync || (self.mediaNotificationsEnabled != mediaNotificationsEnabled) {
      self.mediaNotificationsEnabled = mediaNotificationsEnabled
      if useCastContainerViewController {
        let castContainerVC = (window?.rootViewController as? GCKUICastContainerViewController)
        castContainerVC?.miniMediaControlsItemEnabled = mediaNotificationsEnabled
      } else {
//        let rootContainerVC = (window?.rootViewController as? RootContainerViewController)
//        rootContainerVC?.miniMediaControlsViewEnabled = mediaNotificationsEnabled
      }
    }
    firstUserDefaultsSync = false
  }
}


// MARK: - GCKLoggerDelegate

extension AppDelegate: GCKLoggerDelegate {
  func logMessage(_ message: String,
                  at _: GCKLoggerLevel,
                  fromFunction function: String,
                  location: String) {
    if enableSDKLogging {
      // Send SDK's log messages directly to the console.
      print("\(location): \(function) - \(message)")
    }
  }
}

// MARK: - GCKSessionManagerListener

extension AppDelegate: GCKSessionManagerListener {
  func sessionManager(_: GCKSessionManager, didEnd _: GCKSession, withError error: Error?) {
    if error == nil {
      
    } else {
      let message = "Session ended unexpectedly:\n\(error?.localizedDescription ?? "")"
      showAlert(withTitle: "Session error", message: message)
    }
  }

  func sessionManager(_: GCKSessionManager, didFailToStart _: GCKSession, withError error: Error) {
    let message = "Failed to start session:\n\(error.localizedDescription)"
    showAlert(withTitle: "Session error", message: message)
  }

  func showAlert(withTitle title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    window?.rootViewController?.present(alert, animated: true, completion: nil)
  }
}

// MARK: - GCKUIImagePicker

extension AppDelegate: GCKUIImagePicker {
  func getImageWith(_ imageHints: GCKUIImageHints, from metadata: GCKMediaMetadata) -> GCKImage? {
    let images = metadata.images
    guard !images().isEmpty else { print("No images available in media metadata."); return nil }
    if images().count > 1, imageHints.imageType == .background {
      return images()[1] as? GCKImage
    } else {
      return images()[0] as? GCKImage
    }
  }
}

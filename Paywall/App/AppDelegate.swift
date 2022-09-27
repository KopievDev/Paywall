//
//  AppDelegate.swift
//  Paywall
//
//  Created by Ivan Kopiev on 04.09.2022.
//

import UIKit
import FirebaseCore
import Firebase
import FirebaseMessaging
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes
import AppCenterDistribute

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        FBService.shared.start()
        NotificationManager.shared.requestAuth()

        AppCenter.start(withAppSecret: "a15e0387-c170-4a12-9a95-096e246f27ac", services:[
          Analytics.self,
          Crashes.self,
          Distribute.self
        ])
        return true
    }
    
//
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        print("Firebase registration token: \(String(describing: fcmToken))")
//        FBService.add(token: fcmToken)
//    }
    


    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}




import NotificationCenter
import UserNotifications

struct Notifucka: Codable {
    //MARK: - Properties
    var time: Date = Date()
    var title: String = "Тест"
    var body: String = "Тест"
    var identifier = UUID().uuidString
    
    //MARK: - Helpers
    func getFormmatedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = Locale.current.isRussian ? "HH:mm" : "h:mm a"
        return formatter.string(from: time)
    }
    
    func isEquale(time: Date) -> Bool {
        let calendar = Calendar.current
        let minute = calendar.component(.minute, from: time)
        let hour = calendar.component(.hour, from: time)
        let selfMinute = calendar.component(.minute, from: self.time)
        let selfHour = calendar.component(.hour, from: self.time)
        return minute == selfMinute && hour == selfHour
    }
    
    func getDateComponents() -> DateComponents {Calendar.current.dateComponents([.hour,.minute,.second], from: time)}
    
    init(time: Date) {self.time = time}
    init(){}
    init(time: Date, title: String, body: String) {
        self.title = title
        self.body = body
        self.time = time
    }
}


enum Reminder {
    //MARK: - Properies
    
    static func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    static func getRequest() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { isComplted, _ in
        }
    }
    
    static func createNotificatication(for reminder: Notifucka, userInfo: [String:Any] = [:], repeats: Bool = true) {
        let content = UNMutableNotificationContent()
        content.title = reminder.title
        content.body = reminder.body
        content.sound = .default
        content.badge = 1
        content.userInfo = userInfo
        UIApplication.shared.applicationIconBadgeNumber += 1
        
//        let imageName = "applelogo"
//        guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: "jpg") else { return }
//        let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
//        content.attachments = [attachment]
        let triger = UNCalendarNotificationTrigger(dateMatching: reminder.getDateComponents(), repeats: repeats)
        let request = UNNotificationRequest(identifier: reminder.identifier , content: content, trigger: triger)
        UNUserNotificationCenter.current().add(request) { _ in}
    }
}


extension Locale {
  var isRussian: Bool {
    return languageCode == "ru"
  }
}

class NotificationManager: NSObject {
    
    struct Ids {
        static let link = "Link"
        static let linkCategory = "linkCategory"
    }
    
   static let shared = NotificationManager()
    
    private override init() {
        super.init()
        registerCategories()
    }
    
    func registerCategories() {
        let linkAction = UNNotificationAction(identifier: Ids.link, title: Ids.link, options: .destructive)
        let customCategories = UNNotificationCategory(identifier: Ids.linkCategory,
                                                      actions: [linkAction],
                                                      intentIdentifiers: [],
                                                      options: .customDismissAction)
//        https://mustdev.ru/images/where.gif
        UNUserNotificationCenter.current().setNotificationCategories([customCategories])
    }
    
    func requestAuth() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { success, error in
            if success {
                print("✅ [NotificationManager] request authorization success ")
                DispatchQueue.main.async { UIApplication.shared.registerForRemoteNotifications() }
            } else {
                print("🔥 [NotificationManager] ", error?.localizedDescription ?? "error request authorization")
            }
        }
    }
    
    func createNotification(with notifucka: Notifucka, userInfo: [String:Any] = [:], repeats: Bool = true) {
        let content = UNMutableNotificationContent()
        content.title = notifucka.title
        content.body = notifucka.body
        content.sound = .default
        content.badge = 1
        content.userInfo = userInfo
        content.categoryIdentifier = Ids.linkCategory
        UIApplication.shared.applicationIconBadgeNumber += 1
        
        let imageName = "where"
        guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: "gif") else { return }
        let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
        content.attachments = [attachment]
        let triger = UNCalendarNotificationTrigger(dateMatching: notifucka.getDateComponents(), repeats: repeats)
        let request = UNNotificationRequest(identifier: notifucka.identifier , content: content, trigger: triger)
        UNUserNotificationCenter.current().add(request) { _ in}
    }
    
    private func saveImage(_ data: Data) -> UNNotificationAttachment? {
        let name = UUID().uuidString
        guard let format = ImageFormat(data) else {
            // not an image
            return nil
        }
        let url = URL(fileURLWithPath: NSTemporaryDirectory())
        let directory = url.appendingPathComponent(ProcessInfo.processInfo.globallyUniqueString, isDirectory: true)
        do {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
            let fileURL = directory.appendingPathComponent(name, isDirectory: true).appendingPathExtension(format.extension)
            try data.write(to: fileURL, options: .atomic)
            return try UNNotificationAttachment(identifier: name, url: fileURL, options: nil)
        } catch {
            return nil
        }
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("didReceive")
    
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound,.badge,.alert])
    }
    
}

enum ImageFormat: String {
    case png, jpg, gif

    init?(_ data: Data) {
        if let type = ImageFormat.get(from: data) {
            self = type
        } else {
            return nil
        }
    }

    var `extension`: String {
        return rawValue
    }
}

extension ImageFormat {
    static func get(from data: Data) -> ImageFormat? {
        guard let firstByte = data.first else { return nil }
        switch firstByte {
        case 0x89:
            return .png
        case 0xFF:
            return .jpg
        case 0x47:
            return .gif
        default:
            return nil
        }
    }
}

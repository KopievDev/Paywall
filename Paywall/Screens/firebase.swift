//
//  firebase.swift
//  Paywall
//
//  Created by Ivan Kopiev on 08.09.2022.
//

import Firebase
import FirebaseCore
import FirebaseMessaging
import UserNotifications

struct Notification {
    var subtitle: String?
    var title: String?
    var body: String
    var sound: String?
    var badge: Int
    
    var dict: [String:Any] {
        var result = [String:Any]()
        result["subtitle"] = subtitle
        result["title"] = title
        result["body"] = body
        result["sound"] = sound
        result["badge"] = badge
        return result
    }
}

struct Message {
    var to: String
    var notification: Notification
    var data: [String:Any] = [:]
    var timeToLive: Int = 21600
    var priority = "high"
    
    var dict: [String:Any] {
        var result = [String:Any]()
        result["to"] = to
        result["data"] = data
        result["timeToLive"] = timeToLive
        result["priority"] = priority
        result["notification"] = notification.dict
        return result
    }
    
    func jsonData() -> Data? { dict.json.data(using: .utf8) }
}

extension Dictionary {
    var json: String {
        if JSONSerialization.isValidJSONObject(self) {
            if let theJSONData = try? JSONSerialization.data(withJSONObject: self, options: []) {
                return String(data: theJSONData, encoding: .utf8) ?? "{}"
            } else {
                return "{}"
            }
        } else {
            return "{}"
        }
    }
}

class Messaging1 {
    
    private static let auth = "AAAA6PR27yI:APA91bHu9tuK7K6cutQJIAWzIyUmclmQz8bRzQj24Im5WRUykqxNPTIQ9ppTqsrttCKN39V-qfiGpwNPkKuXy31qMUSl8hDHoDYy7fDB_0tQq2WwUbG1dDG8lS3ttQI6bzRH6WY67Ynr"
    
    class func send(message: Message) {
                
        let postData = message.jsonData()
        
        var request = URLRequest(url: URL(string: "https://fcm.googleapis.com/fcm/send")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("key=\(auth)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
    
    class func send(to token: String, message: String, title: String) {
                
       let semaphore = DispatchSemaphore (value: 0)
        
        let parameters = "{\n    \"to\": \"\(token)\",\n    \"notification\": {\n        \"subtitle\": null,\n        \"title\": \"\(title)\",\n        \"body\": \"\(message)\",\n        \"sound\": \"default\",\n        \"badge\": 1\n    },\n    \"data\": {\n        \"subtitle\": null,\n        \"body\": \"Here is a messages\",\n        \"screen_type\": \"chat\",\n        \"screen_id\": 1547\n    },\n    \"time_to_live\": 21600,\n    \"priority\": \"high\"\n}"
        let postData = parameters.data(using: .utf8)
        
        var request = URLRequest(url: URL(string: "https://fcm.googleapis.com/fcm/send")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("key=AAAA6PR27yI:APA91bHu9tuK7K6cutQJIAWzIyUmclmQz8bRzQj24Im5WRUykqxNPTIQ9ppTqsrttCKN39V-qfiGpwNPkKuXy31qMUSl8hDHoDYy7fDB_0tQq2WwUbG1dDG8lS3ttQI6bzRH6WY67Ynr", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                semaphore.signal()
                return
            }
            print(String(data: data, encoding: .utf8)!)
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
    }
    
}

class FBService: NSObject {
    
    static let shared: FBService = FBService()
    
    private override init() { super.init() }
    
    func start() {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        registerForNotifications()
    }
    
    private static let tokens = Firestore.firestore().collection("tokens")

    class func add(token: String?) {
        if let saveToken = UserDefaults.standard.string(forKey: "token") {
            if token == saveToken { return }
        }
        if let device = UIDevice.current.identifierForVendor?.uuidString, let token = token {
            let model = UIDevice.current.model
            let lang = Locale.current.languageCode ?? "nil"
            let region = Locale.current.regionCode ?? "nil"
            let date = Date().string
            let data: [String:Any] = ["model":model, "lang":lang, "region":region,"token":token, "device":device, "date":date]
            tokens.document(device).setData(["data":data])
            UserDefaults.standard.set(token, forKey: "token")
        }
    }
    
    func registerForNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in}
        UIApplication.shared.registerForRemoteNotifications()
    }
}

extension FBService: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("[token]: \(fcmToken ?? "")")
        FBService.add(token: fcmToken)
    }
}
//
//extension FBService: UNUserNotificationCenterDelegate {
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
//        print(#function)
//        print(response.notification.request.content.userInfo)
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
//        print(#function)
//        return [.badge, .sound, .alert]
//    }
//
//
//}

extension Date {
    var string: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: self)
    }
}

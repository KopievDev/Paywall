//
//  Deeplinker.swift
//  Paywall
//
//  Created by Ivan Kopiev on 05.09.2022.
//

import UIKit

class Deeplinker {
    
    static func route(to deeplink: String) {
        guard let url = URL(string: deeplink), let vc = MainVC.instantiate() as? MainVC else { return }
        let query = url.queryDictionary
        vc.emptyViewInserted = query?[b:"fixSize"] == true
        vc.screenName = url.host ?? "paywall"
        UIApplication.topViewController()?.present(vc, animated: true)
    }
}

extension UIApplication {
    
    open class func topViewController() -> UIViewController? {
        
        if var vc = UIApplication.shared.keyWindow?.rootViewController{
            
            if vc is UITabBarController{
                vc = (vc as! UITabBarController).selectedViewController!
            }
            
            if vc is UINavigationController{
                vc = (vc as! UINavigationController).topViewController!
            }
            
            while ((vc.presentedViewController) != nil &&
                (String(describing: type(of: vc.presentedViewController!)) != "SFSafariViewController") &&
                (String(describing: type(of: vc.presentedViewController!)) != "UIAlertController")) {
                    vc = vc.presentedViewController!
                    if vc is UINavigationController{
                        vc = (vc as! UINavigationController).topViewController!
                    }
            }
            
            return vc;
            
        } else {
            return nil
        }
        
    }
}

extension URL {
    var queryDictionary: [String: Any]? {
        guard let query = self.query else { return nil}
        var queryStrings = [String: Any]()
        for pair in query.components(separatedBy: "&") {
            let key = pair.components(separatedBy: "=")[0]
            let value = pair
                .components(separatedBy:"=")[1]
                .replacingOccurrences(of: "+", with: " ")
                .removingPercentEncoding ?? ""
            if value == "false" || value == "true" {
                queryStrings[key] = value == "true" ? true:false
            } else {
                queryStrings[key] = value
            }
        }
        return queryStrings
    }
}

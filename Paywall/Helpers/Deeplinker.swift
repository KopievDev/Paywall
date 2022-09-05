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


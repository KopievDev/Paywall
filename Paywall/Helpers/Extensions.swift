//
//  Extensions.swift
//  Paywall
//
//  Created by Ivan Kopiev on 04.09.2022.
//

import UIKit

typealias IndexBlock = (Int) -> Void
typealias StringBlock = (String) -> Void
typealias Cells = [Cell]
typealias ArrayBlock = ([[String:Any]]) -> Void
typealias CellsBlock = (Cells) -> Void
typealias VoidBlock = () -> Void

extension String {
    static let data = "data"
    static let reuse = "reuse"
    static let name = "name"
    static let description = "description"
    static let icon_url = "icon_url"
    static let link = "link"
    static let body = "body"
    static let services = "services"
    static let text = "text"
    static let textColor = "textColor"
    static let font = "font"
    static let size = "size"
    static let color = "color"
    static let deeplink = "deeplink"
    static let deeplinks = "deeplinks"
    static let height = "height"
    static let weight = "weight"
    static let width = "width"
    static let id = "id"
    static let fixSize = "fixSize"
    static let paywall = "paywall"
    static let array = "array"
    static let image = "image"
    static let selected = "selected"
    static let buttons = "buttons"
    static let action = "action"
    static let deeplinkAction = "deeplinkAction"

    
}


extension Dictionary {
    subscript(a idx: Key) -> [Any?] {
        get {
            return self[idx] as? [Any?] ?? []
        }
        set {
            if let v = newValue as? Value {
                self[idx] = v
            }
        }
    }
    
    subscript(a0 idx: Key) -> [Any?]? {
        get {
            return self[idx] as? [Any?]
        }
        set {
            if let v = newValue as? Value {
                self[idx] = v
            }
        }
    }
    
    subscript(ad idx: Key) -> [[String: Any]] {
        get {
            return self[idx] as? [[String: Any]] ?? []
        }
        set {
            if let v = newValue as? Value {
                self[idx] = v
            }
        }
    }
    
    subscript(ad0 idx: Key) -> [[String: Any]]? {
        get {
            return self[idx] as? [[String: Any]]
        }
        set {
            if let v = newValue as? Value {
                self[idx] = v
            }
        }
    }
    
    subscript(i idx: Key) -> Int {
        get {
            return self[idx] as? Int ?? 0
        }
        set {
            if let v = newValue as? Value {
                self[idx] = v
            }
        }
    }
    
    subscript(i0 idx: Key) -> Int? {
        get {
            return self[idx] as? Int
        }
        set {
            if let v = newValue as? Value {
                self[idx] = v
            }
        }
    }
    
    
    subscript(b idx: Key) -> Bool {
        get {
            return self[idx] as? Bool ?? false
        }
        set {
            if let v = newValue as? Value {
                self[idx] = v
            }
        }
    }
    
    subscript(b0 idx: Key) -> Bool? {
        get {
            return self[idx] as? Bool
        }
        set {
            if let v = newValue as? Value {
                self[idx] = v
            }
        }
    }
    
    subscript(f idx: Key) -> Float {
        get {
            return self[idx] as? Float ?? Float(self[idx] as? Double ?? 0.0)
        }
        set {
            if let v = newValue as? Value {
                self[idx] = v
            }
        }
    }
    
    subscript(gf idx: Key) -> CGFloat {
        get {
            return self[idx] as? CGFloat ?? CGFloat(self[idx] as? Double ?? 0.0)
        }
        set {
            if let v = newValue as? Value {
                self[idx] = v
            }
        }
    }
    
    subscript(gf0 idx: Key) -> CGFloat? {
        get {
            if let res = self[idx] as? CGFloat {
                return res
            }
            return nil
        }
        set {
            if let v = newValue as? Value {
                self[idx] = v
            }
        }
    }
    
    subscript(f0 idx: Key) -> Float? {
        get {
            if let res = self[idx] as? Float {
                return res
            }
            
            if let res = self[idx] as? Double {
                return Float(res)
            }
            return nil
        }
        set {
            if let v = newValue as? Value {
                self[idx] = v
            }
        }
    }
    
    subscript(s idx: Key) -> String {
        get {
            return self[idx] as? String ?? ""
        }
        set {
            if let v = newValue as? Value {
                self[idx] = v
            }
        }
    }
    
    subscript(s0 idx: Key) -> String? {
        get {
            return self[idx] as? String
        }
        set {
            if let v = newValue as? Value {
                self[idx] = v
            }
        }
    }
    
    subscript(d idx: Key) -> [String: Any] {
        get {
            return self[idx] as? [String: Any] ?? [:]
        }
        set {
            if let v = newValue as? Value {
                self[idx] = v
            }
        }
    }
    
    subscript(d0 idx: Key) -> [String: Any]? {
        get {
            return self[idx] as? [String: Any]
        }
        set {
            if let v = newValue as? Value {
                self[idx] = v
            }
        }
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension UIImageView {
    
    func setImage(urlString: String) {
        let cache = URLCache.shared
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        if cache.cachedResponse(for: request) != nil {
            loadImageFromCache(imageURL: url)
        } else {
            downloadImage(imageURL: url)
        }
    }
    
    private func downloadImage(imageURL: URL) {
        let request = URLRequest(url: imageURL)
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async { self.transition(to: image) }
        }.resume()
    }
    
    private func loadImageFromCache(imageURL: URL) {
        let cache = URLCache.shared
        let request = URLRequest(url: imageURL)
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
                DispatchQueue.main.async { self.image = image }
            }
        }
    }
    
    func transition(to image: UIImage?) {
        UIView.transition(with: self, duration: 0.3, options: [.transitionCrossDissolve]) { self.image = image }
    }
    
    func setImage(_ image: UIImage) {
        self.alpha = 0
        self.image = image
        UIView.animate(withDuration: 0.3) { self.alpha = 1 }
    }
    
}


extension UIImage {
    
    convenience init?(url: String) {
        guard let url = URL(string: url), let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }
    
}

extension UIFont {
    enum Font: String { case bold, regular }
    
    class func font(type: Font, size: CGFloat) -> UIFont {
        switch type {
        case .bold: return UIFont.boldSystemFont(ofSize: size)
        case .regular: return UIFont.systemFont(ofSize: size)
        }
    }
}

@propertyWrapper
public struct UsesAutoLayout<T: UIView> {
    public var wrappedValue: T {
        didSet {
            wrappedValue.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        wrappedValue.translatesAutoresizingMaskIntoConstraints = false
    }
}


protocol Storyboarded {
    static func instantiate() -> UIViewController?
    static func instantiateWithNav() -> UIViewController?
    static var storyboardName: String {get}
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> UIViewController? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        return storyboard.instantiateInitialViewController() as? Self
    }
    
    static func instantiateWithNav() -> UIViewController? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        let navVc =  storyboard.instantiateInitialViewController() as? UINavigationController
        return navVc?.viewControllers.first as? Self
    }

    static var storyboardName: String {
        String(describing: Self.self).hasSuffix("VC") ? (String(describing: Self.self) as NSString).replacingOccurrences(of: "VC", with: "") : String(describing: Self.self)
    }
}

public extension UIStoryboard {
    /// SwifterSwift: Instantiate a UIViewController using its class name.
    ///
    /// - Parameter name: UIViewController type.
    /// - Returns: The view controller corresponding to specified class name.
    func instantiateViewController<T: UIViewController>(withClass name: T.Type) -> T? {
        return instantiateViewController(withIdentifier: String(describing: name)) as? T
    }
}

extension UITableView {
    var isNeedInsertEmptyCell: Bool { frame.height > contentSize.height }
    var diffHeight: CGFloat { frame.height - contentSize.height }
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

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            if newValue > 0 {
                layer.masksToBounds = true
            }
        }
        get { return layer.cornerRadius }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set { layer.borderWidth = newValue / UIScreen.main.scale}
        get { return layer.borderWidth * UIScreen.main.scale }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set { layer.borderColor = newValue?.cgColor  }
        get { return (layer.borderColor != nil ? UIColor(cgColor: layer.borderColor!) : nil) }
    }
    
}

extension UIButton {
    
    convenience init(text: String, deeplink: String?) {
        self.init(frame: .zero)
        setTitle(text, for: .normal)
        accessibilityLabel = deeplink
    }
    
    @objc public func animateIn(view: UIView) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn) {
            view.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc public func animateOut(view viewToAnimate: UIView) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: .curveEaseIn) {
            viewToAnimate.transform = .identity
        }
    }
    
    func startAnimatingPressActions() {
        addTarget(self, action: #selector(animateIn(view:)), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(animateOut(view:)), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
    }
}

//
//  Dict.swift
//  Paywall
//
//  Created by Ivan Kopiev on 04.09.2022.
//

import UIKit
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

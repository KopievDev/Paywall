//
//  Merginable.swift
//  Paywall
//
//  Created by Ivan Kopiev on 27.09.2022.
//

import Foundation

extension Encodable {
    var dictionary: [String : Any]? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? encoder.encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String : Any] }
    }
}

protocol Merginable: Codable {
    mutating func merge(_ raw: [String : Any])
}

extension Merginable {
    mutating func merge(_ raw: [String : Any]) {
        guard let oldValue = dictionary else { return }
        let newValue = oldValue.merging(raw) { $1 }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let data = try JSONSerialization.data(withJSONObject: newValue, options: .prettyPrinted)
            self = try decoder.decode(Self.self, from: data)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

struct TextData: Merginable {
    

    
    
}

extension Decodable {
    init(_ raw: [String : Any]) throws {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let data = try JSONSerialization.data(withJSONObject: raw, options: .prettyPrinted)
            self = try decoder.decode(Self.self, from: data)
        } catch let error  {
            print(error.localizedDescription)
            throw error
        }
    }
}

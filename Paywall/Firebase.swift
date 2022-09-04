//
//  Firebase.swift
//  Paywall
//
//  Created by Ivan Kopiev on 04.09.2022.
//

import Firebase
typealias Cells = [Cell]
typealias ArrayBlock = ([[String:Any]]) -> Void
typealias CellsBlock = (Cells) -> Void
typealias VoidBlock = () -> Void

class Firebase {
    static private let paywall = Firestore.firestore().collection("paywall")
    
    static func getPaywall(completion: @escaping CellsBlock) {
        paywall.getDocuments { query, error in
            guard error == nil else {
                print("Error getting documents: \(String(describing: error))")
                completion([])
                return
            }
            completion(query?.documents.map(self.fetch) ?? [])
        }
    }

    static private  func fetch(from document:QueryDocumentSnapshot)-> Cell {
        Cell(reuseId: document.data()[s:"id"], data: document.data()[d:"data"])
    }
}

struct Cell {
    let reuseId: String
    var data: [String:Any]
}

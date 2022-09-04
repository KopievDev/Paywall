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
    static private let onboarding = Firestore.firestore().collection("onboarding")

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
    
    static func getScreen(name: String, completion: @escaping CellsBlock) {
        getCells(from: ref(type: name), completion: completion)
    }
    
    static func getOnboarding(completion: @escaping CellsBlock) {
        onboarding.getDocuments { query, error in
            guard error == nil else {
                print("Error getting documents: \(String(describing: error))")
                completion([])
                return
            }
            completion(query?.documents.map(self.fetch) ?? [])
        }
    }
    
    static func getCells(from ref: CollectionReference, completion: @escaping CellsBlock) {
        ref.getDocuments { query, error in
            guard error == nil else {
                print("Error getting documents: \(String(describing: error))")
                completion([])
                return
            }
            completion(query?.documents.map(self.fetch) ?? [])
        }
    }
    
    static func ref(type: String) -> CollectionReference {
        Firestore.firestore().collection(type)
    }

    static private  func fetch(from document:QueryDocumentSnapshot)-> Cell {
        Cell(reuseId: document.data()[s:"id"], data: document.data()[d:"data"])
    }
}

struct Cell {
    let reuseId: String
    var data: [String:Any]
}

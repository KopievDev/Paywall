//
//  Firebase.swift
//  Paywall
//
//  Created by Ivan Kopiev on 04.09.2022.
//

import Firebase

final class Firebase {
    private let paywall = Firestore.firestore().collection("paywall")
    private let onboarding = Firestore.firestore().collection("onboarding")

    static let shared = Firebase()
    
    func getPaywall(completion: @escaping CellsBlock) {
        paywall.getDocuments { query, error in
            guard error == nil else {
                print("Error getting documents: \(String(describing: error))")
                completion([])
                return
            }
            completion(query?.documents.map(self.fetch) ?? [])
        }
    }
    
    
    
    func getScreen(name: String, completion: @escaping CellsBlock) -> ListenerRegistration {
        getCellsListner(from: ref(type: name), completion: completion)
    }
    
    func getOnboarding(completion: @escaping CellsBlock) {
        onboarding.getDocuments { query, error in
            guard error == nil else {
                print("Error getting documents: \(String(describing: error))")
                completion([])
                return
            }
            completion(query?.documents.map(self.fetch) ?? [])
        }
    }
    
    func getCells(from ref: CollectionReference, completion: @escaping CellsBlock) {
        ref.getDocuments { query, error in
            guard error == nil else {
                print("Error getting documents: \(String(describing: error))")
                completion([])
                return
            }
            completion(query?.documents.map(self.fetch) ?? [])
        }
    }
    
    func getCellsListner(from ref: CollectionReference, completion: @escaping CellsBlock) -> ListenerRegistration {
       return ref.addSnapshotListener { query, error in
            guard error == nil else {
                print("Error getting documents: \(String(describing: error))")
                completion([])
                return
            }
            completion(query?.documents.map(self.fetch) ?? [])
        }
    }
            
//        }) { query, error in
//            guard error == nil else {
//                print("Error getting documents: \(String(describing: error))")
//                completion([])
//                return
//            }
//            completion(query?.documents.map(self.fetch) ?? [])
//        }
//    }
    
    func ref(type: String) -> CollectionReference {
        Firestore.firestore().collection(type)
    }

    private  func fetch(from document:QueryDocumentSnapshot)-> Cell {
        Cell(reuseId: document.data()[s:.id], data: document.data()[d:.data])
    }
}

struct Cell {
    let reuseId: String
    var data: [String:Any]
}

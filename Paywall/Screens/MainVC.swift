//
//  MainVC.swift
//  Paywall
//
//  Created by Ivan Kopiev on 04.09.2022.
//

import UIKit
import Firebase

final class MainVC: UIViewController, Storyboarded {
    // MARK: - Properties
    @IBOutlet var tableView: UITableView!
    private var screenName: String = "paywall"
    var emptyViewInserted = false
    lazy var dataSource: Listable = DataSource(tableView: tableView, data: cells)
    weak var listner: ListenerRegistration?
    
    private var cells: Cells = [] {
        didSet {
            dataSource.set(data: cells)
            fixScreen()
        }
    }
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       listner = Firebase.shared.getScreen(name: screenName) {  [weak self] in
            self?.cells = $0
            self?.addAction()
            print("UPDATE SCREEN")
        }
        
//        let message = Message(to: "emDZMng0_kaWrxK6EYwd6E:APA91bHdcbBlvIjRrtl_r7LZAylVt40WpHFncPkP7EHWstOW-qcsJAa2caCScnOA-CoUPMOxPJYQF0Lf0j6BS5EyCIcNr6_W7gKH899VlzkWf_KS3Wqi6m0LI5x0Oi6FP_Hta0Ghv1rA", notification: Notification(subtitle: "Hello", title: "Title", body: "Body text", badge: 1))
//
//        Messaging.send(message: message)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        listner?.remove()
        listner = nil
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    // MARK: - Helpers
    
    func set(screenName: String) {
        self.screenName = screenName
    }
    private func addAction() {
        let subscribeBlock: IndexBlock = { number in
            switch number {
            case 0: print("DId WEEK")
            case 1: print("DId Years")
            default: break
            }
        }
        
        let tryAction: VoidBlock = {
            print("TRYYYY!!!")
        }
        
        let deeplincAction: StringBlock  = { Deeplinker.route(to: $0) }
        
        let termsAction: IndexBlock = { number in
            print(number)
        }
        
        for index in 0..<cells.count {
            if cells[index].reuseId == "SubscribeButtonCell" {
                cells[index].data[.action] = subscribeBlock
            }
            
            if cells[index].reuseId == "ButtonCell" {
                cells[index].data[.action] = tryAction
                cells[index].data[.deeplinkAction] = deeplincAction
            }
            
            if cells[index].reuseId == "TermsCell" {
                cells[index].data[.action] = termsAction
                cells[index].data[.deeplinkAction] = deeplincAction
            }
        }
    }
    
    func fixScreen() {
        if tableView.isNeedInsertEmptyCell && !emptyViewInserted {
            if let index = cells.firstIndex(where: { $0.reuseId == "ImageCell" }) {
                cells.insert(Cell(reuseId: "EmptyCell", data: [.height: tableView.diffHeight]), at: index + 1)
                emptyViewInserted = true
            }
        }
    }
}

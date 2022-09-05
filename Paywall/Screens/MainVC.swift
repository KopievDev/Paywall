//
//  MainVC.swift
//  Paywall
//
//  Created by Ivan Kopiev on 04.09.2022.
//

import UIKit

final class MainVC: UIViewController, Storyboarded {
    // MARK: - Properties
    @IBOutlet var tableView: UITableView!
    private var screenName: String = "paywall"
    var emptyViewInserted = false
    lazy var dataSource: Listable = DataSource(tableView: tableView, data: cells)
    private var cells: Cells = [] {
        didSet {
            dataSource.set(data: cells)
            fixScreen()
        }
    }
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Firebase.getScreen(name: screenName) {  [weak self] in
            self?.cells = $0
            self?.addAction()
        }
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

//
//  ViewController.swift
//  Paywall
//
//  Created by Ivan Kopiev on 04.09.2022.
//

import UIKit
typealias IndexBlock = (Int) -> Void
typealias StringBlock = (String) -> Void

class MainVC: UIViewController, Storyboarded {

    var screenName: String = "paywall"
    @IBOutlet var tableView: UITableView!
    lazy var dataSource: Listable = DataSource(tableView: tableView, data: cells)
    private var cells: Cells = [] {
        didSet {
            dataSource.set(data: cells)
            fixScreen()
        }
    }
    
    var emptyViewInserted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Firebase.getScreen(name: screenName) {  [weak self] in
            self?.cells = $0
            self?.addAction()
        }
    }
    
    func addAction() {
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
        
        let deeplincAction: StringBlock  = { [weak self] deeplink in
            print(deeplink)
            let vc = MainVC.instantiate() as? MainVC
            vc?.screenName = "onboarding"
            self?.present(vc!, animated: true)
        }
        
        let termsAction: IndexBlock = { number in
            print(number)
        }
        
        
        for index in 0..<cells.count {
            if cells[index].reuseId == "SubscribeButtonCell" {
                cells[index].data["action"] = subscribeBlock
            }
            
            if cells[index].reuseId == "ButtonCell" {
                cells[index].data["action"] = tryAction
                cells[index].data["deeplinkAction"] = deeplincAction
            }
            
            if cells[index].reuseId == "TermsCell" {
                cells[index].data["action"] = termsAction
            }
        }
    }
    
    func fixScreen() {
        if tableView.isNeedInsertEmptyCell && !emptyViewInserted {
            if let index = cells.firstIndex(where: { $0.reuseId == "ImageCell" }) {
                cells.insert(Cell(reuseId: "EmptyCell", data: ["height": tableView.diffHeight]), at: index + 1)
                emptyViewInserted = true
            }
        }
    }
}

extension UITableView {
    var isNeedInsertEmptyCell: Bool { frame.height > contentSize.height }
    var diffHeight: CGFloat { frame.height - contentSize.height }
}

//
//  DataSource.swift
//  Paywall
//
//  Created by Ivan Kopiev on 04.09.2022.
//

import UIKit

protocol Listable: UITableViewDataSource {
    var tableView: UITableView? { get set }
    var data: Cells { set get }
    func set(data: Cells?)
    func set(tableView: UITableView?)
    func data(for indexPath: IndexPath) -> Cell
}

    
extension Listable {
    func data(for indexPath: IndexPath) -> Cell { data[indexPath.row] }
    func set(data: Cells?) {
        guard let data = data else { return }
        self.data = data
        tableView?.reloadData()
        tableView?.layoutIfNeeded()
        tableView?.isScrollEnabled = tableView?.contentSize.height ?? 0 >= tableView?.bounds.height ?? 0
    }
    
    func set(tableView: UITableView?) {
        self.tableView = tableView
        tableView?.dataSource = self
        tableView?.reloadData()
    }
}

final class DataSource: NSObject, Listable {
    
    init(tableView: UITableView? = nil, data: Cells = []) {
        super.init()
        self.set(tableView: tableView)
        self.data = data
        tableView?.reloadData()
    }
    
    var tableView: UITableView?
    var data: Cells = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { data.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellData.reuseId, for: indexPath)
        (cell as? ReusableCell)?.render(data: cellData)
        return cell
    }
}


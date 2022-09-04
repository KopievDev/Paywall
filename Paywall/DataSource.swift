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

class ReusableCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
    

    func render(data: Cell) { }
    func setUp() {}
    
    override func prepareForReuse() {
        subviews.forEach { view in
            (view as? UILabel)?.text = nil
            (view as? UILabel)?.attributedText = nil
            (view as? UIImageView)?.image = nil
        }
    }
}

class LogoCell: ReusableCell {
    
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

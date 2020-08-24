//
//  CurrencyListView.swift
//  CurrencyApp
//
//  Created by Dmitry Kuzin on 24.08.2020.
//  Copyright © 2020 Dmitry Kuzin. All rights reserved.
//

import UIKit

protocol CurrencyListViewDelegate: class {
    func currencyListView(_ view: CurrencyListView, didSelectVariant variant: CurrencyVariant)
}

class CurrencyListView: UIView {
    
    @IBOutlet weak private var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak private var tableView: UITableView!
    
    weak var delegate: CurrencyListViewDelegate?
    
    var variant: CurrencyVariant!
    private (set) var variants: [CurrencyVariant] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        variants = Currency.variants
        isHidden = true
        bottomConstraint.constant = -UIScreen.main.bounds.height
        heightConstraint.constant = (CGFloat(variants.count) * 44.0) + 34.0
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        hide()
    }
    
    func show() {
        bottomConstraint.constant = 0
        tableView.reloadData()
        isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    @objc func hide() {
        bottomConstraint.constant = -UIScreen.main.bounds.height
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
        }, completion: { _ in
            self.isHidden = true
        })
    }
    
}

extension CurrencyListView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return variants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyItemTableCell", for: indexPath)
        let variant = variants[indexPath.row]
        cell.textLabel?.text = variant.title
        if let currentVariant = self.variant {
            cell.textLabel?.alpha = variant.title == currentVariant.title ? 1.0 : 0.7
            cell.textLabel?.font = variant.title == currentVariant.title ? UIFont(name: "Lato-Black", size: 14) : UIFont(name: "Lato-Regular", size: 14)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.currencyListView(self, didSelectVariant: variants[indexPath.row])
    }
    
}

//
//  CurrencyListView.swift
//  CurrencyApp
//
//  Created by Dmitry Kuzin on 24.08.2020.
//  Copyright © 2020 Dmitry Kuzin. All rights reserved.
//

import UIKit

class CurrencyListView: UIView {
    
    @IBOutlet weak private var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var bottomConstraint: NSLayoutConstraint!
    
    var fromCurrency: Currency!
    var toCurrency: Currency!
    private (set) var variants: [String] = []
    
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
        cell.textLabel?.text = variants[indexPath.row]
        if let from = fromCurrency, let to = toCurrency {
            cell.textLabel?.alpha = variants[indexPath.row] == "\(from.rawValue) → \(to.rawValue)" ? 1.0 : 0.7
            cell.textLabel?.font = variants[indexPath.row] == "\(from.rawValue) → \(to.rawValue)" ? UIFont(name: "Lato-Black", size: 14) : UIFont(name: "Lato-Regular", size: 14)
        }
        return cell
    }
    
}

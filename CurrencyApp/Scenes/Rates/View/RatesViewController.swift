//
//  ViewController.swift
//  CurrencyApp
//
//  Created by Dmitry Kuzin on 24.08.2020.
//  Copyright © 2020 Dmitry Kuzin. All rights reserved.
//

import UIKit

class RatesViewController: UIViewController {

    @IBOutlet private weak var rateLabel: UILabel!
    @IBOutlet private weak var currenciesLabel: UILabel!
    @IBOutlet private weak var yesterdayInfoLabel: UILabel!
    @IBOutlet private weak var updatedLabel: UILabel!
    @IBOutlet private weak var currencyListView: CurrencyListView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private let viewModel = RatesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyListView.delegate = self
        viewModel.updateHandler = { [weak self] error in
            self?.activityIndicator.stopAnimating()
            if let error = error {
                self?.display(error: error)
            } else {
                self?.updateContent()
            }
        }
    }

}

// MARK: - Content
extension RatesViewController {
    
    func updateContent() {
        rateLabel.text = viewModel.rateValue
        currenciesLabel.text = viewModel.currenciesValue
        yesterdayInfoLabel.attributedText = viewModel.rateChangeValue
        updatedLabel.text = viewModel.updateValue
    }
    
}

// MARK: - Actions
extension RatesViewController {

    @IBAction private func listTouched() {
        viewModel.updateCurrencies(for: currencyListView)
        currencyListView.show()
    }
    
    @IBAction private func refreshTouched() {
        activityIndicator.startAnimating()
        viewModel.refreshData()
    }
    
    @IBAction private func reverseTouched() {
        viewModel.reverseCurrencies()
    }
    
}

// MARK: - CurrencyListViewDelegate
extension RatesViewController: CurrencyListViewDelegate {
    
    func currencyListView(_ view: CurrencyListView, didSelectVariant variant: CurrencyVariant) {
        viewModel.selectCurrencies(variant: variant)
        view.hide()
    }
    
}

//
//  CurrencyViewModel.swift
//  CurrencyApp
//
//  Created by Dmitry Kuzin on 24.08.2020.
//  Copyright © 2020 Dmitry Kuzin. All rights reserved.
//

import Foundation

class RatesViewModel {
    
    private var latestRates: LatestRatesResponse?
    private var base: Currency = .EUR
    private var fromCurrency: Currency = .EUR
    private var toCurrency: Currency = .RUB
    private let networkService = RatesNetworkService()
    var updateHandler: ((Error?) -> Void)?
    
    init() {
        fetchRates(with: base)
    }
    
    private func fetchRates(with base: Currency) {
        let parameters = LatestRatesParameters(base: base)
        networkService.fetchLatestRates(with: parameters) { [weak self] result in
            switch result {
            case .success(let response):
                self?.latestRates = response
                self?.updateHandler?(nil)
            case .failure(let error):
                self?.updateHandler?(error)
            }
        }
    }
    
    var rateValue: String? {
        let rate = latestRates?.rate(from: fromCurrency, to: toCurrency) ?? 0
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 4
        return numberFormatter.string(from: NSNumber(value: rate))
    }
    
    var currenciesValue: String? {
        return "\(fromCurrency.rawValue) → \(toCurrency.rawValue)"
    }
    
}

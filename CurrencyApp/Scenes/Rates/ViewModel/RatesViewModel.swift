//
//  CurrencyViewModel.swift
//  CurrencyApp
//
//  Created by Dmitry Kuzin on 24.08.2020.
//  Copyright © 2020 Dmitry Kuzin. All rights reserved.
//

import UIKit

class RatesViewModel {
    
    private var latestRates: LatestRatesResponse?
    private var yesterdayRates: LatestRatesResponse?
    private var base: Currency = .EUR
    private var fromCurrency: Currency = .EUR
    private var toCurrency: Currency = .RUB
    private let networkService = RatesNetworkService()
    private (set) var updatedDate: Date?
    var updateHandler: ((Error?) -> Void)?
    
    init() {
        fetchRates(with: base)
    }
    
    private func fetchRates(with base: Currency) {
        let parameters = LatestRatesParameters(base: base)
        let fetchGroup = DispatchGroup()
        
        var error: Error?
        
        fetchGroup.enter()
        networkService.fetchRates(with: parameters, date: Date()) { [weak self] result in
            switch result {
            case let .success(response):
                self?.latestRates = response
            case let .failure(requestError):
                error = requestError
            }
            fetchGroup.leave()
        }
        fetchGroup.enter()
        networkService.fetchRates(with: parameters, date: Date().addDays(-10)) { [weak self] result in
            switch result {
            case let .success(response):
                self?.yesterdayRates = response
            case let .failure(requestError):
                error = requestError
            }
            fetchGroup.leave()
        }
        
        fetchGroup.notify(queue: .main) { [weak self] in
            self?.updatedDate = Date()
            self?.updateHandler?(error)
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
    
    var updateValue: String? {
        guard let date = updatedDate else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return String(format: "update_at".localized, dateFormatter.string(from: date))
    }
    
    var rateChangeValue: NSAttributedString? {
        let todayRate = latestRates?.rate(from: fromCurrency, to: toCurrency) ?? 0
        let yesterdayRate = yesterdayRates?.rate(from: fromCurrency, to: toCurrency) ?? 0
        let percent = ((todayRate/yesterdayRate) - 1) * 100
        
        if percent > 0 {
            return NSAttributedString(string: percentRateChanges(percent), attributes: [.foregroundColor: UIColor(red: 0.494, green: 0.827, blue: 0.129, alpha: 1)])
        } else if percent < 0 {
            return NSAttributedString(string: percentRateChanges(percent), attributes: [.foregroundColor: UIColor(red: 0.816, green: 0.008, blue: 0.106, alpha: 1)])
        }
        return nil
    }
    
    private func percentRateChanges(_ percent: Double) -> String {
        let count = Int(percent)
        
        if (Double(Int(percent)) - percent != 0) {
            return String(format: "currency_is_up_since_yesterday_2".localized, fromCurrency.title, String(format: "%.1f", percent))
        }
        
        let Y = count % 10
        if (Y == 0 || (Y >= 5 && Y <= 9) || (count >= 5 && count <= 20)) {
            return String(format: "currency_is_up_since_yesterday_0".localized, fromCurrency.title, String(format: "%.1f", percent))
        }
        if (Y == 1) {
            return String(format: "currency_is_up_since_yesterday_1".localized, fromCurrency.title, String(format: "%.1f", percent))
        }
        if (Y < 5) {
            return String(format: "currency_is_up_since_yesterday_2".localized, fromCurrency.title, String(format: "%.1f", percent))
        }
        return ""
    }
    
}

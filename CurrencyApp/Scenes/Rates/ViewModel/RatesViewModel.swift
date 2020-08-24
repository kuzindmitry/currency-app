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
    private var fromCurrency: Currency {
        get {
            return Currency(rawValue: UserDefaults.standard.string(forKey: #function) ?? "") ?? .USD
        }
        set { UserDefaults.standard.set(newValue.rawValue, forKey: #function) }
    }
    private var toCurrency: Currency {
        get {
            return Currency(rawValue: UserDefaults.standard.string(forKey: #function) ?? "") ?? .EUR
        }
        set { UserDefaults.standard.set(newValue.rawValue, forKey: #function) }
    }
    private let networkService = RatesNetworkService()
    private (set) var updatedDate: Date?
    var updateHandler: ((Error?) -> Void)?
    
    init() {
        fetchRates(with: base)
    }
    
}

// MARK: - Fetch
extension RatesViewModel {
    
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
        networkService.fetchRates(with: parameters, date: Date().addDays(-1)) { [weak self] result in
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
    
}

// MARK: - Update Currency
extension RatesViewModel {
    
    func updateCurrencies(for listView: CurrencyListView) {
        listView.variant = (from: fromCurrency, to: toCurrency, title: "\(fromCurrency.rawValue) → \(toCurrency.rawValue)")
    }
    
    func selectCurrencies(variant: CurrencyVariant) {
        fromCurrency = variant.from
        toCurrency = variant.to
        updateHandler?(nil)
    }
    
}

// MARK: - Values
extension RatesViewModel {
    
    var rateValue: String? {
        let rate = latestRates?.rate(from: fromCurrency, to: toCurrency) ?? 0
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 3
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
        var percent = ((todayRate/yesterdayRate) - 1) * 100
        
        if percent > 0 {
            return NSAttributedString(string: percentRateChanges(percent, isUp: true), attributes: [.foregroundColor: UIColor(red: 0.494, green: 0.827, blue: 0.129, alpha: 1)])
        } else if percent < 0 {
            percent = percent * -1
            return NSAttributedString(string: percentRateChanges(percent, isUp: false), attributes: [.foregroundColor: UIColor(red: 0.816, green: 0.008, blue: 0.106, alpha: 1)])
        }
        return nil
    }
    
    private func percentRateChanges(_ percent: Double, isUp: Bool) -> String {
        let count = Int(ceil(percent))
        let Y = count % 10
        
        if (Y == 0 || (Y >= 5 && Y <= 9) || (count >= 5 && count <= 20)) {
            return String(format: isUp ? "currency_is_up_since_yesterday_0".localized : "currency_fell_since_yesterday_0".localized, fromCurrency.title, "\(count)")
        }
        if (Y == 1) {
            return String(format: isUp ? "currency_is_up_since_yesterday_1".localized : "currency_fell_since_yesterday_1".localized, fromCurrency.title, "\(count)")
        }
        if (Y < 5) {
            return String(format: isUp ? "currency_is_up_since_yesterday_2".localized : "currency_fell_since_yesterday_2".localized, fromCurrency.title, "\(count)")
        }
        return ""
    }
    
}

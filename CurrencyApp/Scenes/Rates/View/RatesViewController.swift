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
    
    private let viewModel = RatesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.updateHandler = { [weak self] error in
            if let error = error {
                self?.display(error: error)
            } else {
                self?.updateContent()
            }
        }
    }
    
    func updateContent() {
        rateLabel.text = viewModel.rateValue
    }

}


//
//  ResultViewController.swift
//  simpexMethod
//
//  Created by Artem Talko on 02.06.2024.
//

import UIKit

final class ResultViewController: UIViewController {
    private let mainView = ResultView()
    
    override func loadView() {
         view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0.2314, green: 0.1333, blue: 0.3176, alpha: 1.0)
        
        addTargets()
    }
    
    private func addTargets() {
        
    }
}


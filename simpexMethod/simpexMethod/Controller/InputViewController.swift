//
//  ViewController.swift
//  simpexMethod
//
//  Created by Artem Talko on 29.05.2024.
//

import UIKit

final class InputViewController: UIViewController {
    private let mainView = InputView()
    private var numberOfVariables = 1
    private var numberOfConstraints = 1
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0.2314, green: 0.1333, blue: 0.3176, alpha: 1.0)
        
        addTargets()
    }
}


//MARK: Actions
extension InputViewController {
    @objc private func variableSliderChanged(_ sender: UISlider) {
        let value = String(Int(sender.value))
        mainView.countVariablesLabel.text = value
        numberOfVariables = Int(sender.value)
    }
    
    @objc private func constraintSliderChanged(_ sender: UISlider) {
        let value = String(Int(sender.value))
        mainView.countConstraintsLabel.text = value
        numberOfConstraints = Int(sender.value)
    }
    
    @objc private func selectionButtonPressed(_ sender: UIButton) {
        let equationVC = InputFunctionViewController()
        
        equationVC.configure(numberOfVariables: numberOfVariables, numberOfConstraints: numberOfConstraints )
        
        navigationController?.pushViewController(equationVC, animated: true)
    }
}

//MARK: Helpers
extension InputViewController {
    private func addTargets() {
        mainView.variableSlider.addTarget(self, action: #selector(variableSliderChanged(_ :)), for: .valueChanged)
        mainView.contraintSlider.addTarget(self, action: #selector(constraintSliderChanged(_ :)), for: .valueChanged)
        
        mainView.selectionButton.addTarget(self, action: #selector(selectionButtonPressed), for: .touchUpInside)
    }
}

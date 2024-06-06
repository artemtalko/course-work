//
//  InputFunctionViewController.swift
//  simpexMethod
//
//  Created by Artem Talko on 30.05.2024.
//

import UIKit

final class InputFunctionViewController: UIViewController {
    private let mainView = InputFunctionView()
    
    private var numberOfVariables: Int = 1
    private var numberOfConstraints: Int = 1
    
    override func loadView() {
         view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 0.2314, green: 0.1333, blue: 0.3176, alpha: 1.0)
        
        addTargets()
        setupTableView()
    }
    
    func configure(numberOfVariables: Int, numberOfConstraints: Int) {
        self.numberOfVariables = numberOfVariables
        self.numberOfConstraints = numberOfConstraints
        mainView.numberOfVariables = numberOfVariables
    }
    
    private func setupTableView() {
        mainView.constraintsTableView.dataSource = self
        mainView.constraintsTableView.delegate = self
        mainView.constraintsTableView.register(InputFunctionTableViewCell.self, forCellReuseIdentifier: InputFunctionTableViewCell.cellID)
    }
}


//MARK: TableView
extension InputFunctionViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return numberOfConstraints
        }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InputFunctionTableViewCell.cellID, for: indexPath) as? InputFunctionTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.countOfVariables = numberOfVariables
            return cell
        }
}


//MARK: Helpers
extension InputFunctionViewController {
    private func addTargets() {
        mainView.toSolveButton.addTarget(self, action: #selector(selectionButtonPressed(_ :)), for: .touchUpInside)
    }
}

//MARK: Get Data from TableView
extension InputFunctionViewController {
    // Target function coefficients
    private func getTargetFunctionData() -> [Fraction] {
        var targetFunctionData: [Fraction] = []
        
        for textField in mainView.coefficientTextFields {
            guard let text = textField.text, let value = Double(text) else {
                continue
            }
            targetFunctionData.append(Fraction(Int(value), 1))
        }
        
        return targetFunctionData
    }
    
    // Constraints data
    ///coefficients are for each variable in the target function
    ///sign is the sign of the constraint
    ///rhs is the right hand side of the constraint
    private func getConstraintsData() -> [(coefficients: [Fraction], sign: String, rhs: Fraction?)]{
        var constraintsData: [(coefficients: [Fraction], sign: String, rhs: Fraction?)] = []
        
        for cell in mainView.constraintsTableView.visibleCells {
            guard let inputCell = cell as? InputFunctionTableViewCell else {
                continue
            }
            let constraintValues = inputCell.getConstraintValues()
            guard let coefficients = constraintValues.coefficients else {
                continue
            }
            let fractionCoefficients = coefficients.map { Fraction(Int($0), 1) }
            let rhs = constraintValues.rhs.map { Fraction(Int($0), 1) }
            constraintsData.append((fractionCoefficients, constraintValues.sign, rhs))
        }
        
        print("constraintsData-->>>>")
        print(constraintsData)
        print("------------------")
        return constraintsData
    }
    
    private func prepareSimplexTableau() -> SimplexTableau {
        let targetCoeff = getTargetFunctionData()
        let constrData = getConstraintsData()
         
        var A: [[Fraction]] = []
        var b: [Fraction] = []
         
        for constraint in constrData {
            guard let rhs = constraint.rhs else {
                continue
            }
            A.append(constraint.coefficients)
            b.append(rhs)
        }
         
        print(SimplexTableau(c: targetCoeff, A: A, b: b))
        
        return SimplexTableau(c: targetCoeff, A: A, b: b)
    }
}


//MARK: Action
extension InputFunctionViewController {
    @objc private func selectionButtonPressed(_ sender: UIButton) {
        let resultVC = ResultViewController()
        let simplexTableau = prepareSimplexTableau()
        
        resultVC.configure(simplexTableau: simplexTableau)
        
        navigationController?.pushViewController(resultVC, animated: true)
    }
}

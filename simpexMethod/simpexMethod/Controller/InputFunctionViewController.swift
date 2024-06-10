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
        
        print("Target Function Data: \(targetFunctionData)")
        return targetFunctionData
    }
    
    //≤  ≥  =
    // Constraints data
    private func getConstraintsData() -> [(coefficients: [Fraction], sign: String, rhs: Fraction?)] {
        var constraintsData: [(coefficients: [Fraction], sign: String, rhs: Fraction?)] = []
        
        for cell in mainView.constraintsTableView.visibleCells {
            guard let inputCell = cell as? InputFunctionTableViewCell else {
                continue
            }
            let constraintValues = inputCell.getConstraintValues()
            guard let coefficients = constraintValues.coefficients else {
                continue
            }
            var fractionCoefficients = coefficients.map { Fraction(Int($0), 1) }
            guard var rhs = constraintValues.rhs.map({ Fraction(Int($0), 1) }) else {
                continue
            }
            rhs.varType = .personal

            // Check if the right-hand side is negative
            if rhs.numerator < 0 {
                // Change the sign of all coefficients and the sign of the constraint
                fractionCoefficients = fractionCoefficients.map { Fraction(-$0.numerator, $0.denominator) }
                constraintsData.append((fractionCoefficients, flipSign(constraintValues.sign), Fraction(-rhs.numerator, rhs.denominator)))
            } else {
                constraintsData.append((fractionCoefficients, constraintValues.sign, rhs))
            }
        }
        
        print("Constraints Data: \(constraintsData)")
        return constraintsData
    }
    
    // Function to flip the sign
    private func flipSign(_ sign: String) -> String {
        switch sign {
        case "≤":
            return "≥"
        case "≥":
            return "≤"
        default:
            return sign
        }
    }
    
    private func prepareSimplexTableau() -> SimplexTableau {
        let targetCoeff = getTargetFunctionData()
        let constrData = getConstraintsData()

        var A: [[Fraction]] = []
        var b: [Fraction] = []
        var updatedTargetCoeff = targetCoeff

        for constraint in constrData {
            guard let rhs = constraint.rhs else {
                continue
            }
      
            var coefficients = constraint.coefficients
            var slackSurplusArtificial: [Fraction] = []
            
            //MARK: Inset Oleg method
            slackSurplusArtificial = Array(repeating: Fraction(0, 1), count: constrData.count)
            slackSurplusArtificial[A.count] = Fraction(1, 1)
            coefficients.append(contentsOf: slackSurplusArtificial)
            updatedTargetCoeff.append(Fraction(0, 1))
            
//            switch constraint.sign {
//            case "≤":
//                // Add slack variable
//               
//            case "≥":
//                // Add surplus variable and artificial variable
//                slackSurplusArtificial = Array(repeating: Fraction(0, 1), count: constrData.count)
//                slackSurplusArtificial[A.count] = Fraction(-1, 1)
//                coefficients.append(contentsOf: slackSurplusArtificial)
//                updatedTargetCoeff.append(Fraction(0, 1))
//                // Artificial variable
//                coefficients.append(Fraction(1, 1))
//                updatedTargetCoeff.append(Fraction(0, 1)) // Artificial variables are usually not added to the objective function directly
//            default:
//                continue
//            }
//            
            A.append(coefficients)
            
            b.append(rhs)
            
        }

        // Normalize the size of each row in A to match the total number of variables + slack/surplus/artificial variables
        let totalVariables = updatedTargetCoeff.count
        for i in 0..<A.count {
            while A[i].count < totalVariables {
                A[i].append(Fraction(0, 1))
            }
        }

        // Create the delta row
        let deltaRow = updatedTargetCoeff.map { Fraction(-$0.numerator, $0.denominator, $0.varType) }
        
        let tableau = SimplexTableau(c: updatedTargetCoeff, A: A, b: b, deltaRow: deltaRow, pivotSearchingString: [])
        print("Initial Simplex Tableau:")
        tableau.printTableau()
        
        
        
        return tableau
    }
}

//MARK: Action
extension InputFunctionViewController {
    @objc private func selectionButtonPressed(_ sender: UIButton) {
        
        
        
        let simplexTableau = prepareSimplexTableau()
        
        let simplexSolution = SimplexSolution(tableau: simplexTableau)
        
        
        
        let result = simplexSolution.solveWithIterations()
        
        //MARK: в резалті всі ітерації(весь розвʼязок), треба передати його в resultVC та правильно показати в таблицях.
        
        
        let resultVC = ResultViewController(simplexSolution: result)
        navigationController?.pushViewController(resultVC, animated: true)
    }
}

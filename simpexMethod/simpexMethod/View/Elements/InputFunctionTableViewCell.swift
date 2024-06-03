//
//  InputFunctionTableViewCell.swift
//  simpexMethod
//
//  Created by Artem Talko on 31.05.2024.
//

import UIKit
import SnapKit

final class InputFunctionTableViewCell: UITableViewCell {
    static let cellID = String(describing: InputFunctionTableViewCell.self)
    
    var countOfVariables: Int? {
        didSet {
            setupStrings()
        }
    }
    
    private var coefficientTextFields: [UITextField] = []
    private var variableLabels: [UILabel] = []
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let signSegmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["≤", "≥", "="])
        segmentControl.selectedSegmentIndex = 2
        return segmentControl
    }()
    
    private let rightHandSideTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "RHS"
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .clear
        
        contentView.addSubview(stackView)
        
        setupConstraints()
    }
    
    private func setupStrings() {
        guard let numVars = countOfVariables else {
            return
        }
        
        coefficientTextFields.forEach { $0.removeFromSuperview() }
        variableLabels.forEach { $0.removeFromSuperview() }
        coefficientTextFields.removeAll()
        variableLabels.removeAll()
        
        for i in 0..<numVars {
            let textField = UITextField()
            textField.borderStyle = .roundedRect
            textField.placeholder = "Coeff \(i+1)"
            coefficientTextFields.append(textField)
            stackView.addArrangedSubview(textField)
            
            let label = UILabel()
            label.textAlignment = .center
            
            if numVars == 1 {
                label.text = "x\(i + 1)"
            } else {
                label.text = "x\(i + 1) +"
            }
            
            
            variableLabels.append(label)
            stackView.addArrangedSubview(label)
        }
        
        stackView.addArrangedSubview(signSegmentControl)
        stackView.addArrangedSubview(rightHandSideTextField)
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.trailing.equalToSuperview().offset(-8)
        }
    }
    
    // Function to read values from the fields
    func getConstraintValues() -> (coefficients: [Double]?, sign: String, rhs: Double?) {
        let coefficients = coefficientTextFields.compactMap { Double($0.text ?? "") }
        let sign = signSegmentControl.titleForSegment(at: signSegmentControl.selectedSegmentIndex) ?? "="
        let rhs = Double(rightHandSideTextField.text ?? "")
        return (coefficients, sign, rhs)
    }
}

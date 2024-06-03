//
//  InputFunctionView.swift
//  simpexMethod
//
//  Created by Artem Talko on 30.05.2024.
//
import UIKit
import SnapKit

final class InputFunctionView: UIView {
    
    // UI Elements
    private let targetFunctionLabel: UILabel = {
        let label = UILabel()
        label.text = "Оберіть куди прямує функція:"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    let targetFunctionSegmentControl: UISegmentedControl = {
        let items = ["Max", "Min"]
        let segmentControl = UISegmentedControl(items: items)
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()
    
    private let functionLabel: UILabel = {
        let label = UILabel()
        label.text = "F(x1, ..., xn) ="
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let functionInputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    let constraintsTableView: UITableView = {
        let constraintsTableView = UITableView()
        constraintsTableView.separatorStyle = .none
        constraintsTableView.backgroundColor = .clear
        
        return constraintsTableView
    }()
    
    let toSolveButton: UIButton = {
        let toSolveButton = UIButton()
        toSolveButton.setTitle("Розрахувати", for: .normal)
        toSolveButton.titleLabel?.font = .systemFont(ofSize: 24)
        toSolveButton.backgroundColor = .white
        toSolveButton.setTitleColor(.black, for: .normal)
        toSolveButton.layer.cornerRadius = 10
        toSolveButton.clipsToBounds = true
        
        return toSolveButton
    }()
    
    var numberOfVariables: Int = 0 {
        didSet {
            setupFunctionInputFields()
        }
    }
    
    var coefficientTextFields: [UITextField] = []
    private var variableLabels: [UILabel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(targetFunctionLabel)
        addSubview(targetFunctionSegmentControl)
        addSubview(functionLabel)
        addSubview(functionInputStackView)
        addSubview(constraintsTableView)
        addSubview(toSolveButton)
        
        setupConstraints()
    }
    
    private func setupFunctionInputFields() {
        coefficientTextFields.forEach { $0.removeFromSuperview() }
        variableLabels.forEach { $0.removeFromSuperview() }
        coefficientTextFields.removeAll()
        variableLabels.removeAll()
        
        for i in 0..<numberOfVariables {
            let textField = UITextField()
            textField.borderStyle = .roundedRect
            textField.placeholder = "Coeff \(i+1)"
            coefficientTextFields.append(textField)
            functionInputStackView.addArrangedSubview(textField)
            
            let label = UILabel()
            label.text = "x\(i + 1)"
            variableLabels.append(label)
            functionInputStackView.addArrangedSubview(label)
            
            if i < numberOfVariables - 1 {
                let plusLabel = UILabel()
                plusLabel.text = "+"
                functionInputStackView.addArrangedSubview(plusLabel)
            }
        }
    }
    
    private func setupConstraints() {
        targetFunctionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.equalToSuperview().offset(40)
        }
        
        targetFunctionSegmentControl.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(120)
            make.leading.equalTo(targetFunctionLabel.snp.trailing).offset(20)
            make.centerY.equalTo(targetFunctionLabel.snp.centerY)
        }
        
        functionLabel.snp.makeConstraints { make in
            make.top.equalTo(targetFunctionSegmentControl.snp.bottom).offset(40)
            make.width.equalTo(200)
            make.leading.equalToSuperview().offset(40)
        }
        
        functionInputStackView.snp.makeConstraints { make in
            make.leading.equalTo(functionLabel.snp.trailing).offset(10)
            make.centerY.equalTo(functionLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-40)
        }
        
        constraintsTableView.snp.makeConstraints { make in
            make.top.equalTo(functionInputStackView.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(400)
        }
        
        toSolveButton.snp.makeConstraints { make in
            make.top.equalTo(constraintsTableView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(160)
            make.height.equalTo(80)
        }
    }
}

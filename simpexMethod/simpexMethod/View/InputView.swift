//
//  InputView.swift
//  simpexMethod
//
//  Created by Artem Talko on 29.05.2024.
//
import UIKit
import SnapKit

final class InputView: UIView {
    private let variablesLabel: UILabel = {
        let variablesLabel = UILabel()
        variablesLabel.text = "Оберіть кількість змінних:"
        variablesLabel.font = .systemFont(ofSize: 28, weight: .bold)
        
        return variablesLabel
    }()
    
    let countVariablesLabel: UILabel = {
        let countVariablesLabel = UILabel()
        countVariablesLabel.font = .systemFont(ofSize: 24, weight: .bold)
        countVariablesLabel.text = "1"
        
        return countVariablesLabel
    }()
    
    let variableSlider: UISlider = {
        let variableSlider = UISlider()
        variableSlider.minimumValue = 1
        variableSlider.maximumValue = 10
        variableSlider.value = 1
        variableSlider.isContinuous = true
        
        return variableSlider
    }()
    
    private let contrainsLabel: UILabel = {
        let contrainsLabel = UILabel()
        contrainsLabel.text = "Оберіть кількість обмежень:"
        contrainsLabel.font = .systemFont(ofSize: 28, weight: .bold)
        
        return contrainsLabel
    }()
    
    let countConstraintsLabel: UILabel = {
        let countConstraintsLabel = UILabel()
        countConstraintsLabel.font = .systemFont(ofSize: 24, weight: .bold)
        countConstraintsLabel.text = "1"
        
        return countConstraintsLabel
    }()
    
    let contraintSlider: UISlider = {
        let contraintSlider = UISlider()
        contraintSlider.minimumValue = 1
        contraintSlider.maximumValue = 10
        contraintSlider.value = 1
        contraintSlider.isContinuous = true
        return contraintSlider
    }()
    
    let selectionButton: UIButton = {
        let selectionButton = UIButton()
        selectionButton.setTitle("Далі", for: .normal)
        selectionButton.titleLabel?.font = .systemFont(ofSize: 24)
        selectionButton.backgroundColor = .white
        selectionButton.setTitleColor(.black, for: .normal)
        selectionButton.layer.cornerRadius = 10
        selectionButton.clipsToBounds = true
        
        return selectionButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(variablesLabel)
        addSubview(variableSlider)
        addSubview(countVariablesLabel)
        
        addSubview(contrainsLabel)
        addSubview(contraintSlider)
        addSubview(countConstraintsLabel)
        
        addSubview(selectionButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        variablesLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(200)
            make.centerX.equalToSuperview()
        }
        
        countVariablesLabel.snp.makeConstraints { make in
            make.top.equalTo(variablesLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        variableSlider.snp.makeConstraints { make in
            make.top.equalTo(countVariablesLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(50)
        }
        
        contrainsLabel.snp.makeConstraints { make in
            make.top.equalTo(variableSlider.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }
        
        countConstraintsLabel.snp.makeConstraints { make in
            make.top.equalTo(contrainsLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        contraintSlider.snp.makeConstraints { make in
            make.top.equalTo(countConstraintsLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(50)
        }
        
        selectionButton.snp.makeConstraints { make in
            make.top.equalTo(contraintSlider.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(140)
            make.height.equalTo(80)
        }
    }
}

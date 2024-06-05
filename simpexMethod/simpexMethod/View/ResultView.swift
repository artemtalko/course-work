//
//  ResultView.swift
//  simpexMethod
//
//  Created by Artem Talko on 02.06.2024.
//

import UIKit
import SnapKit

final class ResultView: UIView {
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        return stackView
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "Результат розрахунків:"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    let simplexTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        return tableView
    }()

    let solveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Solve", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()

    private let solutionLabel: UILabel = {
        let label = UILabel()
        label.text = "Solution will be displayed here."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        setupStackView()
        setupConstraints()
    }
    
    private func setupStackView() {
        stackView.addArrangedSubview(resultLabel)
        stackView.addArrangedSubview(simplexTableView)
        stackView.addArrangedSubview(solveButton)
        stackView.addArrangedSubview(solutionLabel)
    }

//    func displaySolution(_ solution: String) {
//        solutionLabel.text = solution
//    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }

        resultLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
        }

        simplexTableView.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        solveButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        solutionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
}

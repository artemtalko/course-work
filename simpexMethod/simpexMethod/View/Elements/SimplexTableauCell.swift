//
//  SimplexTableauCell.swift
//  simpexMethod
//
//  Created by Artem Talko on 03.06.2024.
//

import UIKit

final class SimplexTableauCell: UITableViewCell {
    static let cellID = String(describing: SimplexTableauCell.self)
    
    private var labels: [UILabel] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        for _ in 0..<10 {
            let label = UILabel()
            label.textAlignment = .center
            stackView.addArrangedSubview(label)
            labels.append(label)
        }
    }
    
    func configure(with row: [Decimal]) {
        for (index, value) in row.enumerated() {
            if index < labels.count {
                labels[index].text = "\(value)"
            }
        }
    }
}

//
//  SimplexIterationCell.swift
//  simpexMethod
//
//  Created by Artem Talko on 03.06.2024.
//


import UIKit
import UIKit

final class SimplexIterationCell: UITableViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    private var tableau: SimplexTableau!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        contentView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func configure(with tableau: SimplexTableau) {
        self.tableau = tableau
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (tableau.numberOfConstraints + 2) * (tableau.numberOfVariables + 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        cell.backgroundColor = .white
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        
        // Видаляємо всі підкомпоненти з комірки
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        // Додаємо текстове значення у комірку
        let label = UILabel(frame: cell.contentView.bounds)
        label.textAlignment = .center
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: cell.frame.height/4)
        
        let row = indexPath.row / (tableau.numberOfVariables + 2)
        let col = indexPath.row % (tableau.numberOfVariables + 2)
        
        if row == 0 {
            if col == 0 {
                cell.backgroundColor = UIColor(hue: 0.2028, saturation: 0.14, brightness: 0.63, alpha: 1.0)
                label.text = "C"
                label.font = .boldSystemFont(ofSize: cell.frame.height/4)
            } else if col == tableau.numberOfVariables + 1 {
                label.font = .boldSystemFont(ofSize: cell.frame.height/4)
                label.text = "RHS"
                cell.backgroundColor = UIColor(hue: 0.2028, saturation: 0.14, brightness: 0.63, alpha: 1.0)
            } else {
                label.text = tableau.objectiveCoefficients[col - 1].description
            }
        } else if row == tableau.numberOfConstraints + 1 {
            if col == 0 {
                label.text = "Δ"
                label.font = .boldSystemFont(ofSize: cell.frame.height/4)
                cell.backgroundColor = UIColor(hue: 0.2028, saturation: 0.14, brightness: 0.63, alpha: 1.0)
            } else if col < tableau.deltaRow.count + 1 {
                label.font = .boldSystemFont(ofSize: cell.frame.height/4)
                label.text = tableau.deltaRow[col - 1].description
            }
        } else {
            if col == 0 {
                label.text = "\(row)"
            } else if col == tableau.numberOfVariables + 1 {
                label.text = tableau.rhs[row - 1].description
            } else {
                label.text = tableau.matrix[row - 1][col - 1].description
            }
        }
        
        cell.contentView.addSubview(label)
        
        return cell
    }


    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / CGFloat(tableau.numberOfVariables + 2)
        let height = collectionView.bounds.height / CGFloat(tableau.numberOfConstraints + 2)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

//
//  ResultViewController.swift
//  simpexMethod
//
//  Created by Artem Talko on 02.06.2024.
//

import UIKit

final class ResultViewController: UIViewController {
    private let mainView = ResultView()
    private var simplexSolution: SimplexSolution?
    private var simplexTableau: SimplexTableau?
    
    var iterations: [[[Fraction]]] = [] {
        didSet {
            setupTables()
        }
    }

    var tableau: [[Fraction]] = [] {
        didSet {
            mainView.simplexTableView.reloadData()
        }
    }

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.2314, green: 0.1333, blue: 0.3176, alpha: 1.0)
        addTargets()
        
        // Configure the view if the tableau is already set
        if let tableau = simplexTableau {
            configure(simplexTableau: tableau)
        }
    }

    func configure(simplexTableau: SimplexTableau) {
           self.simplexSolution = SimplexSolution(tableau: simplexTableau)
           self.simplexTableau = simplexTableau
           mainView.simplexTableView.reloadData()
       }
    
    private func setupTables() {
    
        for subview in mainView.stackView.arrangedSubviews where subview is UITableView {
            mainView.stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        for iteration in iterations {
            
            let tableView = UITableView()
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(SimplexTableauCell.self, forCellReuseIdentifier: SimplexTableauCell.cellID)
            tableView.tag = iterations.firstIndex(of: iteration) ?? 0
            
            mainView.stackView.addArrangedSubview(tableView)
            tableView.reloadData()
        }
    }

    private func addTargets() {
        mainView.solveButton.addTarget(self, action: #selector(solveSimplexMethod), for: .touchUpInside)
    }

    @objc private func solveSimplexMethod() {
        guard let simplexSolution = simplexSolution else { return }
        
        let result = simplexSolution.solveWithIterations()
        
       // iterations = result.iterations
        
        // Виведення фінального рішення в консоль
        print("Final Solution:")
        print(result.solutionString)
        
        print("hueta tyt")
        
        for i in 0..<(result.iterations.last?.rhs.count)! {
            print(result.iterations.last?.rhs[i].varType)
        }
      
        print("/////---------------------/////")
        print(iterations)
    }
    
    private func setupTableView() {
        mainView.simplexTableView.dataSource = self
        mainView.simplexTableView.delegate = self
        mainView.simplexTableView.register(SimplexTableauCell.self, forCellReuseIdentifier: SimplexTableauCell.cellID)
    }
}


//MARK: TableView
extension ResultViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return iterations[tableView.tag].count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Повертаємо кількість стовпців в поточному рядку
        return iterations[tableView.tag][section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SimplexTableauCell", for: indexPath) as! SimplexTableauCell
        let row = iterations[tableView.tag][indexPath.section]
        cell.configure(with: row)
        return cell
    }
}

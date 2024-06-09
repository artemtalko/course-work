//
//  SimplexTableau.swift
//  simpexMethod
//
//  Created by Artem Talko on 02.06.2024.
//

import Foundation


class SimplexTableau {
    var objectiveCoefficients: [Fraction]
    var basis: [Int]
    var matrix: [[Fraction]]
    var rhs: [Fraction]
    var deltaRow: [Fraction]
    var basisObjectiveCoefficients: [Fraction] // Новий масив для зберігання коефіцієнтів базисних змінних
    
    var numberOfConstraints: Int
    var numberOfVariables: Int
    
    init(c: [Fraction], A: [[Fraction]], b: [Fraction], deltaRow: [Fraction]) {
        self.numberOfConstraints = A.count
        self.numberOfVariables = c.count
        
        self.objectiveCoefficients = c
        self.basis = Array(numberOfVariables..<(numberOfVariables + numberOfConstraints))
        self.matrix = A
        self.rhs = b
        self.deltaRow = deltaRow
        self.basisObjectiveCoefficients = Array(repeating: Fraction(0, 1), count: numberOfConstraints) // Ініціалізація
        
        updateBasisObjectiveCoefficients()
    }
    
    func updateBasisObjectiveCoefficients() {
        for i in 0..<basis.count {
            let basisIndex = basis[i]
            if basisIndex < objectiveCoefficients.count {
                basisObjectiveCoefficients[i] = objectiveCoefficients[basisIndex]
            } else {
                basisObjectiveCoefficients[i] = Fraction(0, 1) // або інше значення за замовчуванням
            }
        }
    }

    
    func copy() -> SimplexTableau {
        let c = objectiveCoefficients.map { $0 }
        let A = matrix.map { $0.map { $0 } }
        let b = rhs.map { $0 }
        let deltaRow = self.deltaRow.map { $0 }
        let basisObjectiveCoefficients = self.basisObjectiveCoefficients.map { $0 }
        
        let copyTableau = SimplexTableau(c: c, A: A, b: b, deltaRow: deltaRow)
        copyTableau.basisObjectiveCoefficients = basisObjectiveCoefficients
        
        return copyTableau
    }
    
    func printTableau() {
        for i in 0..<matrix.count {
            print(matrix[i].map { $0.description }.joined(separator: "\t | \t") + "\t | \t" + rhs[i].description)
        }
        print("c: " + objectiveCoefficients.map { $0.description }.joined(separator: "\t | \t"))
        print("delta: " + deltaRow.map { $0.description }.joined(separator: "\t | \t"))
        print("Basis Objective Coefficients: " + basisObjectiveCoefficients.map { $0.description }.joined(separator: "\t | \t"))
    }
}
